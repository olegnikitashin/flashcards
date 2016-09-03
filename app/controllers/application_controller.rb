class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  private

  def set_locale
    I18n.locale = if current_user
      current_user.language
    else
      params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
