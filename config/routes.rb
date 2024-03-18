Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  post 'sign_up', to: 'users#create'
  post 'verification', to: 'users#update'
  post 'sign_in', to: 'sessions#create'

  resources :customers, only: %i[index]
  resources :products, only: %i[index]
  resources :orders, only: %i[index create]
  match '/orders/create' => 'posts#create', :as => :post, via: :post
end
