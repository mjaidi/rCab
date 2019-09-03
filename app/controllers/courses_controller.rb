require 'date'

class CoursesController < ApplicationController
  before_action :set_course, only: [:client, :driver, :edit, :update, :select, :start, :end, :set_price, :destroy]

  def demandes
    @courses = policy_scope(Course).select{ |course| course.status == "search" }
  end

  def dashboard
    @courses = policy_scope(Course).reject{ |course| course.status == "search" }
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

  def new
    @course = Course.new
    authorize @course
  end

  def select
    @course.status = "accepted"
    @course.driver = current_user
    if @course.save
      redirect_to driver_course_path(@course)
    else
      redirect_to demandes_path
    end
  end

  def start
    @course.status = "arrived"
    if @course.save
      redirect_to driver_course_path(@course)
    else
      redirect_to driver_course_path(@course)
    end
  end

  def end
    @course.status = "finished"
    if @course.save
      redirect_to driver_course_path(@course)
    else
      redirect_to driver_course_path(@course)
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
          redirect_to client_course_path(@course)
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
    redirect_to client_course_path(@course)
  end

  def update
    if @course.update(course_params)
      redirect_to @course
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to new_course_path
  end

  private
    def set_course
      @course = Course.find(params[:id])
      authorize @course
    end

    def course_params
      params.require(:course).permit(:start_address, :end_address)
    end
end
