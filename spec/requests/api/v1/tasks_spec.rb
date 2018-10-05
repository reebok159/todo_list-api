require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project) }
  let!(:task2) { create(:task, project: project) }
  let!(:task3) { create(:task, project: project) }
  let(:valid_task) { attributes_for(:task) }
  let(:invalid_task) { attributes_for(:task, name: ' ') }

  describe 'GET /projects/{project_id}/taks' do
    it 'shows tasks from project' do
      get api_v1_project_tasks_path(project_id: project.id), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('tasks')
      expect(response.parsed_body.size).to eq(project.tasks.size)
    end
  end

  describe 'POST /projects/{project_id}/tasks' do
    it 'creates task with valid data' do
      post api_v1_project_tasks_path(project_id: project.id), headers: headers, params: { task: valid_task }

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('task')
      expect(response.parsed_body).to include(
        'name' => valid_task[:name],
        'completed' => valid_task[:completed],
        'deadline' => valid_task[:deadline],
        'project_id' => project.id
      )
    end

    it "doesn't create task with invalid data" do
      post api_v1_project_tasks_path(project_id: project.id), headers: headers, params: { task: invalid_task }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /projects/{project_id}/tasks/{id}' do
    it 'shows task by id' do
      get api_v1_project_task_path(project_id: project.id, id: task.id), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('task')
      expect(response.parsed_body['name']).to eq(task[:name])
    end
  end

  describe 'PATCH /projects/{project_id}/tasks/{id}' do
    it 'updates task with valid data' do
      patch api_v1_project_task_path(project_id: project.id, id: task.id),
            headers: headers,
            params: { task: valid_task }

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('task')
      expect(response.parsed_body).to include(
        'name' => valid_task[:name],
        'completed' => valid_task[:completed],
        'deadline' => valid_task[:deadline],
        'project_id' => project.id
      )
    end

    it "doesn't update task with invalid data" do
      patch api_v1_project_task_path(project_id: project.id, id: task.id),
            headers: headers,
            params: { task: invalid_task }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    describe 'changing priority' do
      it 'up priority' do
        patch api_v1_project_task_path(project_id: project.id, id: task2.id),
              headers: headers,
              params: { task: { priority: :up } }

        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema('task')
        expect(response.parsed_body['position']).to eq(task2.position - 1)
      end

      it 'down priority' do
        patch api_v1_project_task_path(project_id: project.id, id: task2.id),
              headers: headers,
              params: { task: { priority: :down } }

        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema('task')
        expect(response.parsed_body['position']).to eq(task2.position + 1)
      end

      it "doesn't up priority if has max priority" do
        patch api_v1_project_task_path(project_id: project.id, id: task.id),
              headers: headers,
              params: { task: { priority: :up } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't down priority if has min priority" do
        patch api_v1_project_task_path(project_id: project.id, id: task3.id),
              headers: headers,
              params: { task: { priority: :down } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /projects/{project_id}/tasks/{id}' do
    it 'deletes task from project' do
      expect do
        delete api_v1_project_task_path(project_id: project.id, id: task.id), headers: headers
      end.to change(Task, :count).by(-1)
    end
  end
end
