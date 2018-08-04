class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index,:edit,:update,:show,:destroy]
  before_action :correct_user, only:[:edit,:update,:show]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated:  true).page(params[:page])
  end

  def new
    @user = User.new
  end

  def show
      @user = User.find(params[:id])
      @dailyreports = @user.dailyreports.page(params[:page]).per(10)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account."
      redirect_to root_url and return unless @user.activated?
    else
      render 'new'
    end

  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to current_user unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
