Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  resources :users do
    member do
      delete 'remove/:project_id', :controller => 'projects', :action => 'remove', :as => 'remove_project'
    end
  end

  resources :projects
  get 'new_user' => "persons#new"
  post 'new_user' => "persons#create"

  resources :projects do
    resources :tasks
    get '/tagged' => 'projects#tagged', :as => 'tagged'
  end
  
  root 'projects#index'
end
