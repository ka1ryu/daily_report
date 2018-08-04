class ReportsController < ApplicationController
  def home
    @dailyreport = current_user.dailyreports.build if logged_in?
  end

  def all
    @feed_items = Dailyreport.where("DATE(created_at) = '#{Date.yesterday}'").page(params[:page]).per(35) if logged_in?
  end
end
