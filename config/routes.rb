Rails.application.routes.draw do
  root 'urls#new'
  get 'urls/top'
  get "shorty/:short_url", to: "urls#shorty", as: :shorty
  get 'urls/top'
  resources :urls, only: [:create, :show]
end
