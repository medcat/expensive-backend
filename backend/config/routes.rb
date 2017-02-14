Rails.application.routes.draw do
  scope :api do
    resources :users, only:[:create]
    resource :session, only: [:create, :destroy] do
      get :test unless Rails.env.production?
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
