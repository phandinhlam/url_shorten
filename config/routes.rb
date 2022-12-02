Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resource :url_shorten, only: [], path: '' do
      post :encode
      post :decode
    end
  end
end
