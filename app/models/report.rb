# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentioner, class_name: 'ReportMention', dependent: :destroy
  has_many :mentioning_reports, through: :report_mentioner, source: :mentioned_report
  has_many :report_mentionee, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: 'mentioned_report'
  has_many :mentioned_reports, through: :report_mentionee, source: :report

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
      succeeded = save
      succeeded = save_mentions(id) if succeeded
      raise ActiveRecord::Rollback unless succeeded
      true
    end
  end

  def save_mentions(report_id)
    report_mentioner.destroy_all
    mentioned_ids = content.to_s.scan(REPORT_URL).flatten.uniq
    return true if mentioned_ids.empty?

    mentioned_ids.each do |id|
      ReportMention.create(report_id:, mentioned_report_id: id)
    end
    true
  end
end
