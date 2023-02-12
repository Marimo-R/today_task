Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions'
  }
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  get 'users/my_page' => 'users#show'
  get 'users/information/edit' => 'users#edit'
  patch 'users/information' => 'users#update'
  get 'users/unsubscribe' => 'users#unsubscribe'
  patch 'users/withdrawal' => 'users#withdrawal'
  root to: 'homes#top'
  resources :categories, only: [:index, :create, :edit, :update, :destroy]
  get 'users/:user_id/main_tasks/calendar' => 'main_tasks#calendar', as: 'calendar'
  resources :users, except: [:index, :show, :create, :new, :edit, :update, :destroy] do
  resources :main_tasks, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  end
  patch 'users/:user_id/main_tasks/:id/add_today' => 'main_tasks#add_today', as: 'add_today'
  patch 'users/:user_id/main_tasks/:id/remove_today' => 'main_tasks#remove_today', as: 'remove_today'
  patch 'users/:user_id/main_tasks/:id/task_status_to_incomplete' => 'main_tasks#task_status_to_incomplete', as: 'task_status_to_incomplete'
  patch 'users/:user_id/main_tasks/:id/task_status_to_done' => 'main_tasks#task_status_to_done', as: 'task_status_to_done'
  resources :sub_tasks, only: [:new, :create, :edit, :update, :show, :destroy]
  patch 'sub_tasks/:id/add_today' => 'sub_tasks#add_today', as: 'sub_add_today'
  patch 'sub_tasks/:id/remove_today' => 'sub_tasks#remove_today', as: 'sub_remove_today'
  patch 'sub_tasks/:id/task_status_to_incomplete' => 'sub_tasks#task_status_to_incomplete', as: 'sub_task_status_to_incomplete'
  patch 'sub_tasks/:id/task_status_to_done' => 'sub_tasks#task_status_to_done', as: 'sub_task_status_to_done'
  get 'users/:user_id/relationships' => 'relationships#index', as: 'relationships'
  post 'relationships' => 'relationships#follow_request', as: 'relationships_request'
  delete 'relationships/:id' => 'relationships#unfollow', as: 'relationships_unfollow'
  patch 'relationships/:id' => 'relationships#accept', as: 'relationships_accept'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    root "toppages#top"
  end
end
