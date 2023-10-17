# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.order(:id).page(params[:page])
  end

  def show; end

  def edit
    redirect_to users_path unless current_user.id == @user.id
  end

  def update
    if @user.update(user_params)
      redirect_to user_url(@user), notice: t('controllers.common.notice_update', name: User.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :post, :address, :self_introduction)
  end
end
