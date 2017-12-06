require 'sidekiq/web'

Rails.application.routes.draw do
  resources :offers do
    collection do
      patch :load_grid
      # get '/course_plans/:user_id', to: 'plans#course_plans'
      # patch :load_grid_disciplines
    end
    resources :offer_disciplines do
      resources :plans do
        member do
          get 'copy'
          post 'aprovar'
        end
      end
    end
  end

  get 'planos/:course_id', to: 'plans#planos_curso', as: 'planos_curso'
  get 'planos', to: 'plans#planos_professor', as: 'planos_professor'
  # put 'update_perfils/:users', to: 'user#update_perfils', as: 'update_perfils_users'
  get 'aprovacao', to: 'plans#get_planos_aprovar', as: 'get_planos_aprovar'
  # put 'aprovacao/:plan', to: 'plans#aprovar', as: 'aprovar_plano'

  # Área pública para planos
  get 'plans/public/index', to: 'plans#public_index', as: 'public_index'
  post 'plans/public/index', to: 'plans#public_index_course', as: 'public_index_course'

  get 'plans/public/:course_id/disciplinas', to: 'plans#public_disciplinas', as: 'public_disciplinas'
  post 'plans/public/:course_id/disciplinas', to: 'plans#public_disciplina_planos', as: 'public_disciplina_planos'

  get 'plans/public/:course_id/:discipline_id/planos', to: 'plans#public_curso_disciplina_planos', as: 'public_curso_disciplina_planos'
  # post 'plans/public/:course_id/:discipline_id/planos', to: 'plans#public_curso_disciplina_planos', as: 'public_curso_disciplina_planos'

  get 'plans/publico/index', to: 'plans#publico_index', as: 'publico_index'
  post 'plans/publico/index', to: 'plans#publico_index_planos', as: 'publico_index_planos'

  resources :grid_disciplines
  resources :grids, except: [:destroy] do
    collection do
      get :importar
      post  :importar
    end
    resources :grid_disciplines
  end
  resources :turmas
  resources :course_offers
  resources :courses
  resources :course_modalities
  resources :course_formats
  resources :disciplines, path: 'disciplinas'
  resources :permissao_telas
  resources :permissaos
  resources :perfils
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'visitors#index'
  devise_for :users
  resources :users do
    collection do
      put 'update_perfils'
    end
  end


  # Interface para acessar as tarefas em background através do sidekiq
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
