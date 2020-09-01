class PhoneVerificationsController < ApplicationController
  def new
  end

  def create
    current_user.phone = params[:phone_number]
    current_user.country_code = params[:country_code]
    current_user.save
    @response = Authy::PhoneVerification.start(
      via: params[:method],
      country_code: params[:country_code],
      phone_number: params[:phone_number]
    )
    if @response.ok?
      redirect_to challenge_phone_verifications_path(I18n.locale)
    else
      render :new
    end
  end

  def challenge
  end

  def verify
    @response = Authy::PhoneVerification.check(
      verification_code: params[:code],
      country_code: current_user.country_code,
      phone_number: current_user.phone
    )
    if @response.ok?
      current_user.verified = true
      current_user.save
      redirect_to root_path(I18n.locale), notice: t('verify.success_message')
    else
      render :challenge
    end
  end
end
