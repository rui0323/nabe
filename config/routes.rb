Rails.application.routes.draw do

  root to: "homes#top"
  devise_for :customers

  resources :posts, only: [:new, :create, :index, :show, :destroy] do
  resources :post_comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
  end
  resources :customers, only: [:show, :edit, :update, :index]
  get 'homes/top'
  get 'homes/about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
