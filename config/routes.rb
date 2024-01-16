Rails.application.routes.draw do
  root 'urls#new'
  get 'urls/top'
  resources :urls, only: [:create, :show]
end
