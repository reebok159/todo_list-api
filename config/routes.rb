Rails.application.routes.draw do
  apipie

  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  root 'apipie/apipies#index'

  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          resources :comments, only: %i[index create destroy]
          member do
            get :up
            get :down
          end
        end
      end
    end
  end
end
