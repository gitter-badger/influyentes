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

  # Root
  root "home#index"

  # Debug emails
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
