Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'api/auth'

  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :tasks
      end
    end
  end
end
