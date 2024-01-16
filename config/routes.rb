Rails.application.routes.draw do
  root 'urls#index'
  get 'urls/top'
end
