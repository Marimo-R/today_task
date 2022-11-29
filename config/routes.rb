Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions'
  }
  #devise_for :users
  root to: 'homes#top'
  get 'about' => 'homes#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
