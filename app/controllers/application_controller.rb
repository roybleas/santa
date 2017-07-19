class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def content_not_found
    render file: "#{Rails.root}/public/404", layout: true, status: :not_found
  end
end
