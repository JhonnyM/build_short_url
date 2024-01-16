Rails.application.routes.draw do
  root 'urls#new'
  get 'urls/top'
  get "shorty/:short_url", to: "urls#shorty", as: :shorty
  resources :urls, only: [:create, :show]
end
