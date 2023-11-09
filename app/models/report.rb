# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions, dependent: :destroy
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report
  has_many :inverse_of_report_mentions, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: 'mentioned_report'
  has_many :mentioned_reports, through: :inverse_of_report_mentions, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  REPORT_URL = %r{http://localhost:3000/reports/(\d+)}

  def save_with_mentions
    Report.transaction do
      (save && save_mentions(id)) || raise(ActiveRecord::Rollback)
    end
  end

  def update_with_mentions(report_params, report_id)
    Report.transaction do
      (update(report_params) && save_mentions(report_id)) || raise(ActiveRecord::Rollback)
    end
  end

  def save_mentions(report_id)
    report_mentions.destroy_all
    mentioned_ids = content.to_s.scan(REPORT_URL).flatten.uniq
    return true if mentioned_ids.empty?

    mentioned_ids.each do |id|
      ReportMention.create(report_id:, mentioned_report_id: id)
    end
  end
end
