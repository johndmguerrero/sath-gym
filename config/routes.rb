Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :chats do
    resources :messages, only: [:create]
  end
  resources :models, only: [:index, :show] do
    collection do
      post :refresh
    end
  end
  devise_for :users

  resources :notifications, only: [] do
    member do
      patch :mark_as_read
    end

    collection do
      post :mark_all_as_read
    end
  end

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

  resources :equipments, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :equipment_categories, only: [:index, :new, :create, :edit, :update]
  resources :members, only: [:index, :new, :edit, :create] do
    post "on_subscription_change", on: :collection
  end

  resources :social_media do
    collection do
      post :generate
    end

    member do
      patch :publish
      patch :archive
    end
  end

  get "members/:id", to: "members#show", defaults: { format: :json }, constraints: { format: :json }, as: :member_json
  post "members/update_face_scan", to: "members#update_face_scan", defaults: { format: :json }, constraints: { format: :json }
  resources :attendances, only: [:index, :create]
  resources :products, except: :show do
    patch "toggle_status", to: "products#toggle_status", on: :member, as: :toggle_status
  end
  resources :transactions, only: [:index, :new, :create, :edit] do
    get "checkout/:customer_number", to: "transactions#checkout", on: :collection, as: :checkout
    post "checkout/:customer_number", to: "transactions#create", on: :collection
    get "renewal/:customer_number", to: "transactions#renewal", on: :collection, as: :renewal
    post "renewal/:customer_number", to: "transactions#create", on: :collection
  end
end
