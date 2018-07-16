class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index

  end

  def show
      @user = User.find(params[:id])
    if current_user == @user
      #ユーザーが自分のページへのアクセスする場合
      @user = User.find(params[:id])
    elsif current_user.nil?
      redirect_to('/login')
    else
      redirect_to current_user
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Welcome Nippo tools"
      redirect_to @user
    else
      render 'new'
    end

  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
