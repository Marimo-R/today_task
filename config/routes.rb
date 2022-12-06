Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions'
  }

  get 'users/my_page' => 'users#show'
  get 'users/information/edit' => 'users#edit'
  patch 'users/information' => 'users#update'
  get 'users/unsubscribe' => 'users#unsubscribe'
  patch 'users/withdrawal' => 'users#withdrawal'
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :categories, only: [:index, :create, :edit, :update, :destroy]
  resources :users, except: [:index, :show, :create, :new, :edit, :update, :destroy] do
  resources :main_tasks, only: [:show, :index, :new, :create, :edit, :update]
  end
  patch 'users/:user_id/main_tasks/:id/today_task_flag_update' => 'main_tasks#today_task_flag_update', as: 'today_task_flag_update'
  patch 'users/:user_id/main_tasks/:id/task_status_to_done' => 'main_tasks#task_status_to_done', as: 'task_status_to_done'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
