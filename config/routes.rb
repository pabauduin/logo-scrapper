Rails.application.routes.draw do
  root 'logos#index'
  resources :logos do
    collection do
      post :create_companies
      post :download
      post :saving
      post :delete_all
    end
  end
  resources :saves  do
    collection do
      post :generating
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
