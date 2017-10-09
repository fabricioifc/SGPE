Rails.application.routes.draw do
  resources :offers do
    collection do
      patch :load_grid
      # patch :load_grid_disciplines
      patch :teachers
    end
    resources :offer_disciplines
  end
  resources :offer_steps

  resource :wizard do
     get :step1
     get :step2
     get :step3
     get :step4

     post :validate_step
   end

  resources :grid_disciplines
  resources :grids, except: [:destroy] do
    resources :grid_disciplines
  end
  resources :turmas
  resources :course_offers
  resources :courses
  resources :course_modalities
  resources :course_formats
  resources :tests
  resources :disciplines, path: 'disciplinas'
  resources :posts
  resources :permissao_telas
  resources :permissaos
  resources :perfils
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
