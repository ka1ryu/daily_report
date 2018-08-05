class DailyreportsController < ApplicationController
  before_action :logged_in_user, only:[:create,:edit, :destroy, :update]
  before_action :correct_user, only: [:edit,:destroy, :update]
  
  def create
    @dailyreport = current_user.dailyreports.build(dailyreport_params)
    if @dailyreport.save
      flash[:success] = "Micropost created!"
      redirect_to '/reports/all'
    else
      @feed_items = []
      render 'reports/home'
    end
  end

  def edit
  end

  def update
    if @dailyreport.update_attributes(dailyreport_params)
      flash[:success] = "Your Dailyreport Updated!"
      redirect_to reports_all_path
    else
      render 'edit'
    end
  end

  def destroy
    @dailyreport.destroy
    flash[:success] = "Dailyreport deleted"
    redirect_to request.referrer || root_url
  end

  private

   def dailyreport_params
     params.require(:dailyreport).permit(:content)
   end

   def correct_user
      @dailyreport = current_user.dailyreports.find_by(id: params[:id])
      redirect_to root_url if @dailyreport.nil?
   end
end
