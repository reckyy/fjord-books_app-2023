# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validates :avatar_content_type, inclusion: { in: %w[image/png image/jpeg image/gif] }

  private

  def avatar_content_type
    avatar.blob.content_type if avatar.attached?
  end
end
