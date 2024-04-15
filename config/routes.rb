Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :tradelines do
    resources :deposits, only: [:create, :index, :show]
  end
end
