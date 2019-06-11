Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'passagem_servicos#index'

  resources :passagem_servicos, only: [:index, :show]
  resources :perfis, only: [:index, :show]
  resources :categorias, only: [:index, :show]
end
