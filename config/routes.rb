Rails.application.routes.draw do
  root 'logos#index'
  resources :logos do
    collection do
      post :create_companies
      post :destroy_all
      post :generate_logos
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
