require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:valid_comment) { attributes_for(:comment) }
  let(:invalid_comment) { attributes_for(:comment, text: ' ') }

  describe 'GET /projects/{project_id}/tasks/{task_id}/comments' do
    let!(:comments) { create_list(:comment, 5, task: task) }

    it 'shows all comments from task' do
      get api_v1_project_task_comments_path(project_id: project.id, task_id: task.id), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response).to match_response_schema('comments')
      expect(response.parsed_body.size).to eq(comments.size)
    end
  end

  describe 'POST /projects/{project_id}/tasks/{task_id}/comments' do
    it 'creates valid comment' do
      post api_v1_project_task_comments_path(project_id: project.id, task_id: task.id),
           headers: headers,
           params: { comment: valid_comment }

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('comment')
      expect(response.parsed_body['text']).to eq(valid_comment[:text])
    end

    it 'creates comment with image' do
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/com.png'), 'image/png')
      post api_v1_project_task_comments_path(project_id: project.id, task_id: task.id),
           headers: headers,
           params: { comment: valid_comment.merge(image: file) }

      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema('comment')
      expect(response.parsed_body['image'].fetch('url', nil)).not_to be_nil
    end

    it "doesn't create invalid comment" do
      post api_v1_project_task_comments_path(project_id: project.id, task_id: task.id),
           headers: headers,
           params: { comment: invalid_comment }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /projects/{project_id}/tasks/{task_id}/comments/{id}' do
    it 'deletes comment from task' do
      comment
      expect do
        delete api_v1_project_task_comment_path(project_id: project.id, task_id: task.id, id: comment.id),
               headers: headers
      end.to change(Comment, :count).by(-1)
    end
  end
end
