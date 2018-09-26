module Api
  module V1
    class ProjectsController < ApplicationController
      load_and_authorize_resource

      resource_description do
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        formats ['json']
      end

      def_param_group :project do
        param :project, Hash, action_aware: true do
          param :name, String, desc: 'Name of project', required: true
        end
      end

      api :GET, '/api/v1/projects', 'Show all user projects'
      def index
        render json: @projects
      end

      api :POST, '/api/v1/projects', 'Create new project'
      param_group :project
      def create
        if @project.save
          render json: @project, status: :created
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :GET, '/api/v1/projects/:id', 'Show user project by id'
      param :id, :number, desc: 'Project id', required: true
      def show
        render json: @project
      end

      api :PUT, '/api/v1/projects/:id', 'Update project by id'
      param :id, :number, desc: 'Project id', required: true
      param_group :project
      def update
        if @project.update(project_params)
          render json: @project, status: :ok
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/projects/:id', 'Delete project by id'
      param :id, :number, desc: 'Project id', required: true
      def destroy
        @project.destroy
      end

      private

      def project_params
        params.require(:project).permit(:name)
      end
    end
  end
end
