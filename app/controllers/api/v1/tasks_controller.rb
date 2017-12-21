class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  def index
    render json: @tasks
  end

  def create
    if @task.save(task_params)
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @task
  end

  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    render json: {}, status: :no_content
  end

  def up
    @task.increment_position
  end

  def down
    @task.decrement_position
  end

  private

    def task_params
      params.require(:task).permit( :name, :deadline )
    end
end
