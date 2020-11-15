Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      scope :sessions, controller: 'sessions' do
        post 'signup', to: "sessions#signup"
        post 'signin', to: "sessions#signin"
        delete 'signout', to: "sessions#signout"
      end
      resources :users, only:[] do
        
      end
    end
  end
end
