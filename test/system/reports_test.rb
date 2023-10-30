# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user)
    @report = FactoryBot.create(:report)
    @user_has_report = @report.user
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on 'ログイン'
  end

  test 'ログイン後、日報を書く' do
    login(@user)
    click_on '日報'
    click_on '日報の新規作成'
    fill_in 'report[title]', with: 'テストタイトル'
    fill_in 'report[content]', with: 'テスト内容'
    click_on '登録する'
    assert_text '日報が作成されました。'
  end

  test 'ログイン後、編集' do
    login(@user_has_report)
    visit report_url(@report)
    click_on 'この日報を編集'
    fill_in 'report[content]', with: '変更したよ'
    click_on '更新する'
    assert_text '日報が更新されました'
  end
end
