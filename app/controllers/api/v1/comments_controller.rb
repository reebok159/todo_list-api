class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :task
  load_and_authorize_resource :comment, through: :task

  api :GET, '/api/v1/projects/:project_id/tasks/:task_id/comments/', 'Show comments from task'
  param :task_id, Fixnum, desc: "Task id", required: true
  param :project_id, Fixnum, desc: "Project id", required: true
  def index
    render json: @comments
  end

  api :POST, '/api/v1/projects/:project_id/tasks/:task_id/comments/', 'Add comment to task'
  param :task_id, Fixnum, desc: "Task id", required: true
  param :project_id, Fixnum, desc: "Project id", required: true
  def create
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:task_id/comments/:id', 'Show comment by id'
  param :id, Fixnum, desc: "Comment id", required: true
  param :task_id, Fixnum, desc: "Task id", required: true
  param :project_id, Fixnum, desc: "Project id", required: true
  def show
    render json: @comment
  end

  api :PUT, '/api/v1/projects/:project_id/tasks/:task_id/comments/:id', 'Update comment by id'
  param :id, Fixnum, desc: "Comment id", required: true
  param :task_id, Fixnum, desc: "Task id", required: true
  param :project_id, Fixnum, desc: "Project id", required: true
  param :text, String, desc: "Text of comment", required: true
  def update
    if @comment.update(task_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/api/v1/projects/:project_id/tasks/:task_id/comments/:id', 'Delete comment by id'
  param :id, Fixnum, desc: "Comment id", required: true
  param :task_id, Fixnum, desc: "Task id", required: true
  param :project_id, Fixnum, desc: "Project id", required: true
  def destroy
    @comment.destroy
    render json: {}, status: :no_content
  end

  private

    def comment_params
      params.require(:comment).permit( :text )
    end
end
