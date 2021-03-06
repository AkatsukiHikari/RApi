Rails.application.routes.draw do
  namespace :api do
    namespace :spec do
      post 'excel/upload_csv'
    end
    namespace :v1 do
        resources :users do
          post :login, on: :collection
        end
      end
    end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
