class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:dashboard, :demandes, :driver_dashboard], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: [:dashboard, :demandes, :driver_dashboard], unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé a éffectuer cette action."
    redirect_to(root_path(I18.locale))
  end

  # Devise Signup parameters update
  def configure_permitted_parameters
    added_attrs = [:email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :phone, :verified_whatsapp, :admin, :driver, :photo_moto, :photo_cin, :photo, :country_code]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  protected

  def after_sign_in_path_for(resource)
    root_path(I18n.locale)
  end

  def after_sign_out_path_for(resource)
    root_path(I18n.locale)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end


  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /^phone_verifications/ || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
