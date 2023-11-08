# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @report = FactoryBot.create(:report)
    @user_has_report = @report.user
  end

  test '日報作成者なら編集できる' do
    assert @report.editable?(@user_has_report)
  end

  test '日報作成者以外なら編集できない' do
    assert_not @report.editable?(@user)
  end

  test 'Dateクラスに変換できているか' do
    assert_equal @report.created_on, Time.zone.now.to_date
  end
end
