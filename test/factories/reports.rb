# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'テスト日報タイトル' }
    content { 'テスト日報内容' }
    user
  end
end
