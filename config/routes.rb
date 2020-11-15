Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      # Session control operations
      scope :sessions, controller: 'sessions' do
        post 'signup', to: "sessions#signup"
        post 'signin', to: "sessions#signin"
        delete 'signout', to: "sessions#signout"
      end
      # User Model Operations
      resources :users, only:[] do
        member do
          get 'followers', to: "users#followers"
          get 'followed', to: "users#followed"
        end
      end
      # Tweet Model Operations
      resources :tweets, only:[:create] do
        
      end
      # Follow Model Operations
      resources :follows, only:[:create] do

      end
    end
  end
end
