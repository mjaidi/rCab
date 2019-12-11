class CourseChannel < ApplicationCable::Channel
  def subscribed
     stream_from "course_channel_#{params[:id]}_#{params[:lang]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
