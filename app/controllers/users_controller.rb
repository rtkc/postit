class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]
  before_action :account_owner_access_only, only: [:edit, :show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'You have signed up successfully.'
      redirect_to root_path
    else 
      flash[:error] = 'Please input a valid username and password.'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update

    if @user.update(user_params) 
      flash[:notice] = 'You have successfully updated your profile.'
      render :new
    else 
      flash[:error] = "Something is wrong"
      render :edit
    end
  end

  def show
    
  end

  private 
  def user_params
    params.require(:user).permit(:username, :password)
  end

  def set_user
     @user = User.find(params[:id])
  end
end
