class ReportsController < ApplicationController
  def home
    if logged_in?
      @dailyreport = current_user.dailyreports.build
    else
      redirect_to login_url
    end
  end

  def all
    @date = Time.parse(params[:date]) if !params[:date].blank?
    @msg = "not found reports!"
    if logged_in? && @date.nil?
      @feed_items = Dailyreport.where("DATE(created_at) = '#{Date.today}'").page(params[:page]).per(35)
    elsif logged_in? && @date
      @feed_items = Dailyreport.where(created_at: @date.all_day).page(params[:page]).per(35)
    else
      redirect_to login_url
    end
  end
end
