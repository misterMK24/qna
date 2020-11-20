Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    patch 'mark_best', on: :member
    resources :answers, shallow: true, only: %i[create update destroy]
  end

  resources :attachments, only: %i[destroy]
end
