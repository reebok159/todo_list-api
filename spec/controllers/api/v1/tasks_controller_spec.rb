require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project) }
  let!(:task2) { create(:task, project: project) }
  let!(:task3) { create(:task, project: project) }
  let(:valid_task) { attributes_for(:task) }
  let(:invalid_task) { attributes_for(:task, name: ' ') }

  before(:each) do
    request.headers.merge!(user.create_new_auth_token)
  end

  describe 'GET #index' do
    it 'shows tasks from project' do
      get :index, params: { project_id: project.id }
      check_http_success_and_json(response)
      hash_body = JSON.parse(response.body)
      expect(hash_body.length).to eq(project.tasks.length)
      expect(response).to match_response_schema("tasks")
    end
  end

  describe 'POST #create' do
    it 'creates valid task' do
      post :create, params: { project_id: project.id, task: valid_task }
      check_http_success_and_json(response)
      expect(body_as_json).to include({
        name: valid_task[:name],
        completed: valid_task[:completed],
        deadline: valid_task[:deadline],
        project_id: project.id
      })
    end

    it 'doesn\'t create invalid task' do
      post :create, params: { project_id: project.id, task: invalid_task }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #show' do
    it 'shows task by id' do
      get :show, params: { id: task.id, project_id: task.project_id }
      check_http_success_and_json(response)
      expect(body_as_json[:name]).to eq(task[:name])
      expect(response).to match_response_schema("task")
    end
  end

  describe 'PATCH #update' do
    it 'updates with valid data' do
      patch :update, params: build_update_hash(task, valid_task)
      check_http_success_and_json(response)
      expect(body_as_json).to include({
        id:  task.id,
        name: valid_task[:name],
        completed: valid_task[:completed],
        deadline: valid_task[:deadline]
      })
    end

    it 'doesn\'t update with invalid data' do
      patch :update, params: build_update_hash(task, invalid_task)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    describe 'changing priority' do
      it 'up priority' do
        patch :update, params: build_update_hash(task2, priority: :up)
        check_http_success_and_json(response)
        expect(body_as_json[:position]).to eq(task2.position - 1)
      end

      it 'down priority' do
        patch :update, params: build_update_hash(task2, priority: :down)
        check_http_success_and_json(response)
        expect(body_as_json[:position]).to eq(task2.position + 1)
      end
      it "doesn't up priority" do
        patch :update, params: build_update_hash(task, priority: :up)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't down priority" do
        patch :update, params: build_update_hash(task3, priority: :down)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes task from project' do
      expect do
        delete :destroy, params: { id: task.id, project_id: task.project_id }
      end.to change(Task, :count).by(-1)
    end
  end
end
