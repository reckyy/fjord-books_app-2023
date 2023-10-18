# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validates :avatar, inclusion: { in: %w[images/jpg images/png images/gif], message: 'はJPG, PNG, GIF形式のものを使用してください。' }
end
