# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validate :avatar_type

  private

  def avatar_type
    unless avatar.blob.content_type.in?(%w[images/jpg images/png images/gif])
      avatar.purge
      errors.add(:avatar, I18n.t('errors.messages.used_unusable_image_type'))
    end
  end
end
