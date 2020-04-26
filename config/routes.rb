Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :tweeets do
    member do
      post 'like'
      delete 'dislike'
      post 'retweeet'
    end
  end
  get 'trending_feed', :to => 'tweeets#trending_feed'
  resources :relationships, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "tweeets#index"
end
