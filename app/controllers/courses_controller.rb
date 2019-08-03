require 'date'

class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = policy_scope(Course).order(created_at: :asc)
  end

  def show
  end

  def new
    @course = Course.new
    authorize @course
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.price = calculate_price
    @course.client = current_user
    @course.driver = User.first
    @course.status = "Looking for a driver"
    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
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

  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course was successfully destroyed.'
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
