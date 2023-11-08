# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user, name: nil)
  end

  test '名前有のユーザーなら名前が返る' do
    @user.name = 'Alice'
    assert_equal @user.name_or_email, 'Alice'
  end

  test '名前無のユーザーならemailが返る' do
    assert_equal @user.name_or_email, @user.email
  end
end
