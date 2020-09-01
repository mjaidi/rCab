class Api::V1::UsersController < Api::V1::BaseController
  before_action :find_user, only: [:set_location]

  def set_location
    if @user.update(user_params)
      @user.last_location_update = Time.current
      @user.save
      render json: {success: true}
      ActionCable.server.broadcast "location_channel_#{params[:course_id]}",
        lat:  @user.last_lat,
        lng:  @user.last_lng
    else
      render json: {success: false}
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_lat, :last_lng)
  end

  def find_user
    @user = User.find_by_id(params[:id])
    authorize @user
  end
end


