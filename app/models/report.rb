# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mention_reports, dependent: :destroy
  has_many :mentioning_reports, through: :mention_reports, source: :mentioned_report
  has_many :swapping_id_mention_reports, class_name: 'MentionReport', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: 'mentioned_report'
  has_many :mentioned_reports, through: :swapping_id_mention_reports, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
