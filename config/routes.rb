Rails.application.routes.draw do
  root 'logos#index' if Logo.all.count > 0
  root 'logos#new' if Logo.all.count == 0
  resources :logos do
    collection do
      post :create_companies
      post :destroy_all
      post :generate_logos
      post :destroy
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
