require 'date'

class CoursesController < ApplicationController
  before_action :set_course, only: [:client, :driver, :edit, :update, :select, :start, :end, :destroy, :set_price, :map_display]


  def demandes
    @courses = policy_scope(Course).select{ |course| course.status == "search" }
  end

  def dashboard
    @courses = policy_scope(Course).reject{ |course| course.status == "search" }
  end

  def driver_dashboard
    @courses = policy_scope(Course).reject{ |course| course.status == "search" }
    @total_courses = @courses.map{|c| c.price}.compact.sum.round(2)
  end

  def client
    @markers = {
      start_address: { lat: @course.start_lat, lng: @course.start_lon },
      end_address: { lat: @course.end_lat, lng: @course.end_lon }
    }
  end

  def driver
    @markers = {
      start_address: { lat: @course.start_lat, lng: @course.start_lon },
      end_address: { lat: @course.end_lat, lng: @course.end_lon }
    }
  end

  def map_display
    @markers = {
      start_address: { lat: @course.start_lat, lng: @course.start_lon },
      end_address: { lat: @course.end_lat, lng: @course.end_lon }
    }
  end

  def new
    @course = Course.new
    authorize @course
    unless current_user.verified
      redirect_to new_phone_verification_path(I18n.locale), alert: 'Vous devez vérifier votre numéro pour continuer'
    end
  end

  def select
    @course.status = "accepted"
    @course.driver = current_user
    if @course.save
      redirect_to driver_course_path(I18n.locale,@course)
      broadcast_course(@course)
    else
      redirect_to demandes_path
    end
  end

  def start
    @course.status = "arrived"
    if @course.save
      broadcast_course(@course)
    end
  end

  def end
    @course.status = "finished"
    if @course.save
      broadcast_course(@course)
    end
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.client = current_user
    @course.status = "pending"
    if @course.save
      respond_to do |format|
        format.html {
          @course.status = 'search'
          @course.save
          redirect_to client_course_path(I18n.locale,@course)
        }
        format.js
      end
    else
      flash.now[:alert] = @course.errors.full_messages
      render :new
    end
  end

  def set_price
    @course.status = 'search'
    @course.save
    redirect_to client_course_path(I18n.locale,@course)
    broadcast_new_course
  end

  def update
    if @course.update(course_params)
      redirect_to dashboard_path(I18n.locale)
    end
  end

  def destroy
    @course.destroy
    redirect_to new_course_path(I18n.locale)
  end

  private
    def set_course
      @course = Course.find(params[:id])
      authorize @course
    end

    def course_params
      params.require(:course).permit(:start_address, :end_address, :start_lat, :start_lon, :end_lat, :end_lon, :note, :comment)
    end

    def broadcast_course(course)
      # broadcast course for each language, then pick up depending on subscription params
      I18n.available_locales.each do |l|
        I18n.with_locale(l) do
          ActionCable.server.broadcast "course_channel_#{@course.id}_#{l}",
              driver_status:  render_driver_status(@course),
              client_status:  render_client_status(@course),
              id: @course.id,
              lang: l.to_s
        end
      end
    end

    def render_driver_status(course)
      render_to_string(partial: 'driver_status', locals: { course: course })
    end

    def render_client_status(course)
      render_to_string(partial: 'client_status', locals: { course: course })
    end

    def broadcast_new_course
      # broadcast course for each language, then pick up depending on subscription params
      @notifications = Course.where(status: 'search').order(created_at: :desc)
      I18n.available_locales.each do |l|
        I18n.with_locale(l) do
          ActionCable.server.broadcast "new_course_channel_drivers_#{1}_#{l}",
              notification_count:  renter_notification_count,
              notification_content:  render_notification_content,
              lang: l.to_s
        end
      end
    end

    def renter_notification_count
      render_to_string(partial: 'shared/notifications_count', locals: { notifications: @notifications, notification_notice: 'Nouvelle Course'})
    end

    def render_notification_content
      render_to_string(partial: 'shared/notifications_content', locals: { notifications: @notifications})
    end
end
