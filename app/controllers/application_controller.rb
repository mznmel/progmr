class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def login_required
    if not current_user
      flash.now[:warning] = t(:youHaveToLoginFirst)
      redirect_to login_path
    end
  end

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
