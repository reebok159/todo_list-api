require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, :with_tasks, user: user) }
  let(:valid_task) { { name: 'task_name', completed: false, deadline: DateTime.new } }
  let(:invalid_task) { { name: ' ' } }
  let(:task) { FactoryGirl.create(:task, project: project) }

  before(:each) do
    request.headers.merge!(user.create_new_auth_token)
  end

  describe 'GET #index' do
    it 'shows tasks from project' do
      get :index, params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      hash_body = JSON.parse(response.body)
      expect(hash_body.length).to eq(project.tasks.length)
      expect(response).to match_response_schema("tasks")
    end
  end

  describe 'POST #create' do
    it 'creates valid task' do
      post :create, params: { project_id: project.id, task: valid_task }
      expect(response).to have_http_status(:success)
      expect(response.body).to look_like_json
      expect(body_as_json).to match({
        id:  be_kind_of(Integer),
        position:  be_kind_of(Integer),
        created_at: be_kind_of(String),
        updated_at: be_kind_of(String),
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
      expect(response.body).to look_like_json
      expect(body_as_json[:name]).to eq(task[:name])
      expect(response).to match_response_schema("task")
    end
  end

  describe 'PUT #update' do
    it 'updates with valid data' do
      put :update, params: { id: task.id, project_id: task.project_id, task: valid_task }
      expect(response).to have_http_status(:success)
      expect(response.body).to look_like_json
      expect(body_as_json).to match({
        id:  task.id,
        position:  task.position,
        created_at: be_kind_of(String),
        updated_at: be_kind_of(String),
        name: valid_task[:name],
        completed: valid_task[:completed],
        deadline: valid_task[:deadline],
        project_id: task.project_id
      })
    end

    it 'doesn\'t update with invalid data' do
      put :update, params: {
        id: task.id,
        project_id: task.project_id,
        task: invalid_task
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { FactoryGirl.create(:task, project: project) }

    it 'deletes task from project' do
      expect do
        delete :destroy, params: { id: task.id, project_id: task.project_id }
      end.to change(Task, :count).by(-1)
    end
  end

  describe 'GET #up, #down' do
    context 'task with middle priority' do
      let(:ids) { { id: project.tasks[1].id,
                    project_id: project.tasks[1].project_id } }

      it 'up priority' do
        get :up, params: ids
        expect(response.body).to look_like_json
        expect(body_as_json[:position]).to eq(project.tasks[1].position - 1)
      end

      it 'down priority' do
        get :down, params: ids
        expect(response.body).to look_like_json
        expect(body_as_json[:position]).to eq(project.tasks[1].position + 1)
      end
    end

    context 'task with highest priority' do
      let(:ids) { { id: project.tasks[0].id,
                    project_id: project.tasks[0].project_id } }

      it 'up priority' do
        get :up, params: ids
        expect(response).to have_http_status(:no_content)
      end

      it 'down priority' do
        get :down, params: ids
        expect(response.body).to look_like_json
        expect(body_as_json[:position]).to eq(project.tasks[0].position + 1)
      end
    end

    context 'task with lowest priority' do
      let(:ids) { { id: project.tasks[2].id,
                    project_id: project.tasks[2].project_id } }
      it 'up priority' do
        get :up, params: ids
        expect(response.body).to look_like_json
        expect(body_as_json[:position]).to eq(project.tasks[2].position - 1)
      end

      it 'down priority' do
        get :down, params: ids
        expect(response).to have_http_status(:no_content)
      end
    end
  end

end
