Rails.application.routes.draw do
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
