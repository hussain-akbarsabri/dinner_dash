Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root to: "home#index"

  devise_for :users

  resources :products, :categories, :orders

  get 'home/index'
  get 'carts/show'

  get 'cart' => 'carts#show', as: 'cart'
  delete 'cart' => 'carts#destroy', as: 'cart_delete'
  
  post 'line_items/:id/add' => 'line_items#add_quantity', as: 'line_item_add'
  post 'line_items/:id/reduce' => 'line_items#reduce_quantity', as: 'line_item_reduce'
  post 'line_items' => 'line_items#create'
  get 'line_items/:id' => 'line_items#show', as: 'line_item'
  delete 'line_items/:id' => 'line_items#destroy'

  post 'filter_products', to: 'products#filter', as: 'filter_products'

  get 'categories/:category_id/products', to: 'products#category_products', as: 'category_products'

  get 'retire_product/:id', to: 'products#retire_product', as: 'retire_product'
  get 'resume_product/:id', to: 'products#resume_product', as: 'resume_product'

  get 'orders_dashboard', to: 'orders#orders_dashboard', as: 'orders_dashboard'

  namespace :api, defaults: {format: :json} do
    resources :products, only: [:index, :show, :update, :destroy]
  end

  devise_scope :user do
    post 'api/sign_up', to: 'api/registrations#create', defaults: { format: :json }
    post 'api/sign_in', to: 'api/sessions#create', defaults: { format: :json }
    delete 'api/sign_out', to: 'api/sessions#destroy', defaults: { format: :json }
  end
end
