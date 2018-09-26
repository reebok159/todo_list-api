require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:valid_comment) { attributes_for(:comment) }
  let(:invalid_comment) { attributes_for(:comment, text: ' ') }

  before(:each) do
    request.headers.merge!(user.create_new_auth_token)
  end

  describe 'GET #index' do
    it 'shows all comments from task' do
      get :index, params: { project_id: project.id, task_id: comment.task_id }
      check_http_success_and_json(response)
      hash_body = JSON.parse(response.body)
      expect(hash_body.length).to eq(task.comments.length)
      expect(response).to match_response_schema('comments')
    end
  end

  describe 'POST #create' do
    it 'creates valid comment' do
      post :create, params: {
        project_id: project.id,
        task_id: comment.task.id,
        comment: valid_comment
      }

      check_http_success_and_json(response)
      expect(body_as_json[:text]).to eq(valid_comment[:text])
      expect(response).to match_response_schema('comment')
    end

    it 'doesn\'t create invalid comment' do
      post :create, params: {
        project_id: project.id,
        task_id: comment.task.id,
        comment: invalid_comment
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, task: task) }

    it 'deletes comment from task' do
      expect do
        delete :destroy, params: { id: comment.id, task_id: comment.task_id, project_id: project.id }
      end.to change(Comment, :count).by(-1)
    end
  end
end
