require 'date'

class CoursesController < ApplicationController
  before_action :set_course, only: [:client, :driver, :edit, :update, :select, :start, :end]

  def demandes
    @courses = policy_scope(Course).select{ |course| course.status == "search" }
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
      redirect_to driver_course_path(@course), notice: 'Course accepted.'
    else
      redirect_to demandes_path , notice: 'Course not accepted.'
    end
  end

  def start
    @course.status = "arrived"
    if @course.save
      redirect_to driver_course_path(@course), notice: 'Course finished.'
    else
      redirect_to driver_course_path(@course), notice:  'Course not finished.'
    end
  end

  def end
    @course.status = "finished"
    if @course.save
      redirect_to driver_course_path(@course), notice: 'Course started.'
    else
      redirect_to driver_course_path(@course), notice:  'Course not started.'
    end
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.price = calculate_price
    @course.client = current_user
    @course.driver = User.first
    @course.status = "search"
    if @course.save
      redirect_to client_course_path(@course), notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_course
      @course = Course.find(params[:id])
      authorize @course
    end

    def course_params
      params.require(:course).permit(:start_address, :end_address)
    end

    def calculate_price
      10
    end
end
