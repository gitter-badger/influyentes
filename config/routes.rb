Rails.application.routes.draw do
  # Session
  get  "login",  controller: "user_sessions", action: "new"
  post "login",  controller: "user_sessions", action: "create"
  get  "logout", controller: "user_sessions", action: "destroy"

  # User
  resources :users, only: [:show, :edit, :update] do
    collection do
      get  "password", controller: "users", action: "password"
      post "password", controller: "users", action: "password"
      get   "password/reset", controller: "users", action: "password_reset"
      patch "password/reset", controller: "users", action: "password_reset"
    end
  end
  get  "signup", controller: "users", action: "new"
  post "signup", controller: "users", action: "create"

  # Posts
  resources :posts do
    collection do
      get :my
      get :review
      get :published
      get :unpublished
      get :trash
    end

    member do
      get :submit
      get :publish
      get :unpublish
    end
  end

  # Root
  root "home#index"

  # Administration
  namespace :admin do
    resources :posts
    resources :users

    root to: "posts#index"
  end

  # Debug emails
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
