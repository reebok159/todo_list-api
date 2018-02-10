require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:valid_project) { attributes_for(:project) }
  let(:invalid_project) { attributes_for(:project, name: ' ') }

  before(:each) do
    request.headers.merge!(user.create_new_auth_token)
  end

  describe "GET #index" do
    let!(:projects) { create_list(:project, 5, user: user) }

    it "returns projects" do
      get :index
      check_http_success_and_json(response)
      hash_body = JSON.parse(response.body)
      expect(hash_body.length).to eq(projects.length)
      expect(response).to match_response_schema("projects")
    end
  end

  describe "GET #create" do
    it "creates valid project" do
      post :create, params: { project: valid_project }
      check_http_success_and_json(response)
      expect(body_as_json[:name]).to eq(valid_project[:name])
    end

    it "doesn't create invalid project" do
      post :create, params: { project: invalid_project }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #show" do
    it "returns correct project" do
      get :show, params: { id: project.id }
      check_http_success_and_json(response)
      expect(body_as_json[:name]).to eq(project[:name])
      expect(response).to match_response_schema("project")
    end
  end

  describe "PUT #update" do
    it 'save valid data' do
      put :update, params: { id: project.id, project: valid_project }
      check_http_success_and_json(response)
      expect(body_as_json[:name]).to eq(valid_project[:name])
    end

    it 'doesn\'t save invalid data' do
      put :update, params: { id: project.id, project: invalid_project }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it 'can delete project' do
      project
      expect do
        delete :destroy, params: { id: project.id }
      end.to change(Project, :count).by(-1)
    end
  end
end
