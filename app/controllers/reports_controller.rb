# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @reports = Report.includes(:user).order(:id).page(params[:page])
  end

  def new
    @report = current_user.reports.new
  end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
