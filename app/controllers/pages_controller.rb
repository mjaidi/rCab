class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def about
  end

  def cgu
  end

  def security
  end

  def services
  end

  def support
  end

  def lang
    initial_locale = I18n.locale.to_s
    I18n.locale = params[:lang].to_sym
    new_locale = I18n.locale.to_s
    new_url = request.referrer&.include?("/#{initial_locale}/") ? request.referrer.gsub("/#{initial_locale}/", "/#{new_locale}/") : root_url(I18n.locale)
    redirect_to new_url
  end
end
