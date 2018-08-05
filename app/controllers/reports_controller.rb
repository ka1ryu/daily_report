class ReportsController < ApplicationController
  def home
    if logged_in?
      @dailyreport = current_user.dailyreports.build
    else
      redirect_to login_url
    end
  end

  def all
    @feed_items = Dailyreport.where("DATE(created_at) = '#{Date.today}'").page(params[:page]).per(35) if logged_in?
  end
end
