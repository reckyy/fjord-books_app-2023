# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  REPORT_URL = %r{http://localhost:3000/reports/(\d+)}

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      create_mention(@report.id)
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      @report.mention_reports.destroy_all
      create_mention(@report.id)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def extract_report_ids(text, report_url: REPORT_URL)
    text.scan(report_url).flatten.uniq
  end

  def create_mention(report_id)
    mentioned_ids = extract_report_ids(@report.content)
    return if mentioned_ids.empty?

    mentioned_ids.each do |id|
      MentionReport.create(report_id:, mentioned_report_id: id)
    end
  end

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
