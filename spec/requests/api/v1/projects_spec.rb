require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:valid_project) { attributes_for(:project) }
  let(:invalid_project) { attributes_for(:project, name: ' ') }

  describe 'GET /projects' do
    let!(:projects) { create_list(:project, 5, user: user) }

    it 'returns list of projects' do
      get api_v1_projects_path, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('projects')
      expect(response.parsed_body.size).to eq(projects.size)
    end
  end

  describe 'POST /projects' do
    it 'creates new project' do
      post api_v1_projects_path, headers: headers, params: { project: valid_project }

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('project')
      expect(response.parsed_body['name']).to eq(valid_project[:name])
    end

    it "doesn't create invalid project" do
      post api_v1_projects_path, headers: headers, params: { project: invalid_project }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /projects/{id}' do
    it 'returns needed project' do
      get api_v1_project_path(project.id), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('project')
      expect(response.parsed_body['name']).to eq(project[:name])
    end
  end

  describe 'PATCH /projects/{id}' do
    it 'update project with valid data' do
      patch api_v1_project_path(project.id), headers: headers, params: { project: valid_project }

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('project')
      expect(response.parsed_body['name']).to eq(valid_project[:name])
    end

    it "doesn't update project with invalid data" do
      patch api_v1_project_path(project.id), headers: headers, params: { project: invalid_project }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /projects/{id}' do
    it 'can delete project' do
      project
      expect do
        delete api_v1_project_path(project.id), headers: headers
      end.to change(Project, :count).by(-1)
    end
  end
end
