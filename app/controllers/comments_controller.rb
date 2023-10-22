# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    return unless @comment.user == current_user

    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    @commentable = if params[:book_id]
                     Book.find(params[:book_id])
                   elsif params[:report_id]
                     Report.find(params[:report_id])
                   end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
