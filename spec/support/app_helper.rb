module AppHelper
  def body_as_json
    json_str_to_hash(response.body)
  end

  def json_str_to_hash(str)
    JSON.parse(str).with_indifferent_access
  end

  def check_http_success_and_json(response)
    expect(response).to have_http_status(:success)
    expect(response.body).to look_like_json
  end
end
