Chugalugdigest::Application.routes.draw do
  root :to => "home#index"

  resources :list_digests, only: [:create]
end
