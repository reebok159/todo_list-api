module TasksSpecHelper
  def build_update_hash(task, *args)
    { id: task.id, project_id: task.project_id, task: args[0] }
  end

  def check_http_success_and_json(response)
    expect(response).to have_http_status(:success)
    expect(response.body).to look_like_json
  end
end
