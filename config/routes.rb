Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_resource
      delete :vote_cancel
    end
  end

  resources :questions do
    concerns :votable
    patch 'mark_best', on: :member
    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns :votable
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  get 'rewards/index'
end
