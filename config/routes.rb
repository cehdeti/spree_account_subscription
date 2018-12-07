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
    post :renew, on: :member
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get 'account_subscriptions(/:user_id)', to: 'account_subscriptions#show', as: 'account_subscription'
      resources :users do
        member do
          get :account_subscriptions
        end
      end
    end
  end
end
