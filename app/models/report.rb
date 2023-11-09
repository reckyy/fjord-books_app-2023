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
end
