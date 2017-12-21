class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :task
  load_and_authorize_resource :comment, through: :task

  def create
    if @comment.save(comment_params)
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @comment
  end

  def update
    if @comment.update(task_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    render json: {}, status: :no_content
  end

  private

    def comment_params
      params.require(:comment).permit( :text )
    end
end
