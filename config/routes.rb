Rails.application.routes.draw do
  root 'urls#new'
  get 'urls/top'
  get "shorty/:id", to: "urls#shorty", as: :shorty
  get 'urls/top'
  resources :urls, only: [:create, :show]

  #for the API
  
  namespace :api do 
    namespace :v1 do
      resources :urls, except: :destroy
    end
  end
end
