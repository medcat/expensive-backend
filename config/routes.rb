Rails.application.routes.draw do
  resources :reports
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:create, :show]
    resource :session, only: [:create, :destroy] do
      get :renew
    end

    resources :expenses, except: [:new, :edit]

    get :dashboard, to: "dashboard#index"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
