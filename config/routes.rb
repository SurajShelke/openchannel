Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'apps' => 'app#list', as: 'app_list'
  get 'apps/create' => 'app#create', as: 'app_create'
  get 'apps/update/:appId/:version' => 'app#update'

  root 'home#index'
  get 'home/filter_apps' => 'home#filter_apps'
  get 'details/:app_id/:version' => 'app#details', as: 'app_details_with_version'
  get 'details/:app_safe_name' => 'app#details', as: 'app_details'

  # get '*path' => redirect('/')
  resources :app do
    post :install
    post :uninstall
  end
  namespace :api do
    post 'app/list'
    post 'app/create'
    post 'app/update'
    post 'app/delete'
    post 'app/publish'
    post 'app/status'
    post 'upload' => 'app#upload'
  end
end
