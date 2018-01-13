class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  resource_description do
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not found'
    formats ['json']
  end

  def_param_group :task do
    param :task, Hash do
      param :project_id, :number, desc: "Project id", required: true
      param :name, String, desc: "Text of task", required: true
      param :deadline, DateTime, desc: "Deadline", allow_nil: true
      param :completed, [true, false], desc: "Task is completed?"
    end
  end

  api :GET, '/api/v1/projects/:project_id/tasks/', 'Show tasks from project'
  param :project_id, :number, desc: "Project id", required: true
  def index
    render json: @tasks
  end

  api :POST, '/api/v1/projects/:project_id/tasks/', 'Show tasks from project'
  param_group :task
  def create
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:id', 'Show task by id'
  param :id, :number, desc: "Task id", required: true
  param :project_id, :number, desc: "Project id", required: true
  def show
    render json: @task
  end

  api :PUT, '/api/v1/projects/:project_id/tasks/:id', 'Update task by id'
  param :id, :number, desc: "Task id", required: true
  param_group :task
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/api/v1/projects/:project_id/tasks/:id', 'Delete task by id'
  param :id, :number, desc: "Task id", required: true
  param :project_id, :number, desc: "Project id", required: true
  def destroy
    @task.destroy
    render json: {}, status: :no_content
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:id/up', 'Increase task priority'
  param :id, :number, desc: "Task id", required: true
  param :project_id, :number, desc: "Project id", required: true
  def up
    @task.move_higher
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:id/down', 'Decrease task priority'
  param :id, :number, desc: "Task id", required: true
  param :project_id, :number, desc: "Project id", required: true
  def down
    @task.move_lower
  end

  api :GET, '/api/v1/projects/:project_id/tasks/:id/toggle_completed', 'Toggle task status'
  param :id, :number, desc: "Task id", required: true
  param :project_id, :number, desc: "Project id", required: true
  def toggle_completed
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

    def task_params
      params.require(:task).permit( :name, :deadline, :completed )
    end
end
