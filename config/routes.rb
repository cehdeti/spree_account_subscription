Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :account_subscriptions

    resources :products

    resources :users do
      member do
        get :account_subscriptions
      end
    end
  end

  resources :subscriptions do
    resources :seats
  end


  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :account_subscriptions, only: :show, param: :user_id
      resources :users do
        member do
          get :account_subscriptions
        end
      end
    end
  end

end
