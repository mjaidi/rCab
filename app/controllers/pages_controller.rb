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
    I18n.locale = params[:lang].to_sym
    redirect_to root_path(I18n.locale)
  end
end
