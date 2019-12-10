class NewCourseChannel < ApplicationCable::Channel
  def subscribed
     stream_from "new_course_channel_drivers_#{params[:driver]}_#{params[:lang]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
