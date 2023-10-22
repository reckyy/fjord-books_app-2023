# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit]
  before_action :set_my_report, only: %i[update destroy]
  def index
    @reports = Report.includes(:user).order(:id).page(params[:page])
  end

  def new
    @report = current_user.reports.new
  end

  def show; end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def set_my_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
