Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'projects/create'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'projects/read'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'projects/update'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'projects/destroy'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'tasks/create'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'tasks/read'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'tasks/update'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'tasks/destroy'
    end
  end

  apipie
  mount_devise_token_auth_for 'User', at: 'api/auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
