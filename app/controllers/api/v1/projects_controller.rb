class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource through: :current_user

  def index
    render json: @projects
  end

  def create
    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @project
  end

  def update
    if @project.update(project_params)
      render json: @project, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    render json: {}, status: :no_content
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end
end
