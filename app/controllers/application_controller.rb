class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :layout_logic

  protected
  def login_required
    if not current_user
      flash[:warning] = t(:youHaveToLoginFirst)
      redirect_to login_path
      return false
    end
  end

  protected
  def admins_only
    if current_user.is_admin != true
      flash[:warning] = "You are not allowed to do this!"
      redirect_to login_path
      return false
    end
  end

  protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  protected
  def layout_logic
    @top_users = User.order("(comments_karma + posts_karma) DESC").limit(10)
  end
end
