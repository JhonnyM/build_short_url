Rails.application.routes.draw do
  root 'urls#new'
  get 'urls/top'
  get "shorty/:id", to: "urls#shorty", as: :shorty
  get "/:short_url", to: "urls#show"
  resources :urls, only: [:create, :show]

  #for the API
  
  namespace :api do 
    namespace :v1 do
      resources :urls, except: :destroy do
        member do
          get :redirect
        end
      end
      get 'top', to: 'urls#top'
      post 'bot', to: 'urls#bot'
    end
  end
end
