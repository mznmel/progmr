class UsersController < ApplicationController
  def signup
    @user = User.new
  end

  def doSignup
    @user = User.new(params[:user])
    if @user.save
      # login the user
      session[:user_id] = @user.id
      redirect_to root_path, notice: t(:userAddedSuccessfully)
    else
      render "signup"
    end
  end

  def login
    # render 'login'
  end

  def doLogin
    # Check whether the user used his email or his username to login
    userIdentifier = params[:user_or_email]
    if userIdentifier.include? "@"
      user = User.find_by_email(userIdentifier)
    else
      user = User.find_by_username(userIdentifier)
    end

    # is the user exists? If yes authenticate him!
    if user && user.authenticate(params[:password])
      # set session
      session[:user_id] = user.id
      redirect_to root_path, notice: t(:loggedInSuccessfully)
    else
      flash.now[:loginFormError] = t(:invalidUsernameOrPassword)
      render "login"
    end

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: t(:loggedOutSuccessfully)
  end
end
