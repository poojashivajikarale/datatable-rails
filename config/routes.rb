Rails.application.routes.draw do
  resources :customers
  #get 'home/index'
  root 'home#index'
  get 'home/sankey_diagram'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
