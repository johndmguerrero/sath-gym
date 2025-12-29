Rails.application.routes.draw do
  resources :chats do
    resources :messages, only: [:create]
  end
  resources :models, only: [:index, :show] do
    collection do
      post :refresh
    end
  end
  devise_for :users
  get "dashboard/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  resources :equipments, only: [:index, :new, :create, :edit, :destroy]
  resources :members, only: [:index, :new, :edit, :create] do
    post "on_subscription_change", on: :collection
  end

  get "members/:id", to: "members#show", defaults: { format: :json }, constraints: { format: :json }, as: :member_json
  resources :attendances, only: [:index, :create]
  resources :products, except: :show do
    patch "toggle_status", to: "products#toggle_status", on: :member, as: :toggle_status
  end
  resources :transactions, only: [:index, :edit] do
    get "checkout/:customer_number", to: "transactions#checkout", on: :collection, as: :checkout
  end
end
