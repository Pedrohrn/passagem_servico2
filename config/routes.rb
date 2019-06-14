Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'passagem_servicos#index'

  resources :passagem_servicos, 	only: [:index, :show, :create, :destroy, :update]
  resources :perfis, 							only: [:index, :show, :create, :update, :destroy]
  resources :categorias, 					only: [:index, :show, :create, :destroy, :update]
end
