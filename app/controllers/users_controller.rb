class UsersController < ApplicationController
  def signup
    @user = User.new
  end

  def doSignup
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path, notice: t(:userAddedSuccessfully)
    else
      render action: "signup"
    end
  end

end
