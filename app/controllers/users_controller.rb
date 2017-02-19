class UsersController < ApplicationController
  before_action :logged_in?, only: [:show, :edit, :update, :destroy]
  before_action :current_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    if password? && matching_password?
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        render :new
      end
    else
      redirect_to new_user_path, alert: "passwords must match and cannot be left blank"
    end
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def matching_password?
    params[:user][:password] == params[:user][:password_confirmation]
  end
end
