class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_phone_verification_path(I18n.locale)
  end
end