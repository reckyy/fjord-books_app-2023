# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = FactoryBot.create(:report)
    @user = @report.user
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'ログイン後、日報を書く' do
    login(@user)
    click_on '日報'
    click_on '日報の新規作成'
    fill_in 'report[title]', with: 'テストタイトル'
    fill_in 'report[content]', with: 'テスト内容'
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text 'テストタイトル'
    assert_text 'テスト内容'
  end

  test 'ログイン後、編集' do
    login(@user)
    visit report_url(@report)
    click_on 'この日報を編集'
    fill_in 'report[title]', with: 'タイトルを変更'
    fill_in 'report[content]', with: '内容も変更したよ'
    click_on '更新する'
    assert_text '日報が更新されました。'
    assert_text 'タイトルを変更'
    assert_text '内容も変更したよ'
  end

  test 'ログイン後、日報削除' do
    login(@user)
    visit report_url(@report)
    click_on 'この日報を削除'
    assert_text '日報が削除されました。'
    assert reports_path, page.current_path
  end
end
