class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :task
  load_and_authorize_resource :comment, through: :task

  def_param_group :nested_ids do
    param :task_id, :number, desc: "Task id", required: true
    param :project_id, :number, desc: "Project id", required: true
  end

  def_param_group :comment do
    param :comment, Hash, action_aware: true do
      param :text, String, desc: "Text of comment"
    end
    param_group :nested_ids
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:task_id/comments/', 'Show comments from task'
  param_group :nested_ids
  def index
    render json: @comments
  end

  api :POST, '/api/v1/projects/:project_id/tasks/:task_id/comments/', 'Add comment to task'
  param_group :comment
  def create
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/api/v1/projects/:project_id/tasks/:task_id/comments/:id', 'Delete comment by id'
  param :id, :number, desc: "Comment id", required: true
  param_group :nested_ids
  def destroy
    @comment.destroy
    render json: {}, status: :no_content
  end

  private

    def comment_params
      params.require(:comment).permit( :text, :image )
    end
end
