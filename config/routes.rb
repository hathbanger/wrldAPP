Rails.application.routes.draw do
  resources :places
  
  # match "/places/:id/" => "places#show", via: [:get, :post]


  root 'places#index'
end
