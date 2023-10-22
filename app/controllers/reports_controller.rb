class ReportsController < ApplicationController
  def index
    @reports = Report.includes(:user).order(:id).page(params[:page])
  end
end
