Rails.application.routes.draw do


  # Routes that doesn't need user authentication

  resources :choices do
    member do
      get 'select'
    end
  end

  resources :responses do
    collection do
      get 'create_success'
      get 'paused'
      post 'destroy_bulk'
      post 'export'
    end
  end

  mount StripeEvent::Engine, at: '/webhook'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Customize devise controller for user registrations
  devise_for :users, controllers: { registrations: 'users/registrations' }

  authenticated :user do
    root 'surveys#index', as: :authenticated_root
  end
  root 'welcome#index'

  # Routes that needs user authentication
  authenticate :user do
    resources :surveys do
      member do
        get 'create_success'
        get 'pause'
        get 'resume'
        get 'delete'
      end
    end

    resources :landing_pages, only: [:show] do
      collection do
        get 'preview'
      end
    end

    resources :subscriptions, only: [:new, :create, :update] do
      member do
        get 'cancel'
        post 'update_card'
      end
    end

    get '/settings', to: 'devise/registrations#edit', as: 'account_settings'
    get '/account/cancel', to: 'account#cancel', as: 'account_cancel'
    get '/account/cancel_popup', to: 'account#cancel_popup', as: 'account_cancel_popup'
    get '/account/update_card', to: 'account#update_card', as: 'account_update_card'
    get '/account/change_plan', to: 'account#change_plan', as: 'account_change_plan'
    get '/plans', to:'account#billing', as: 'account_billing'
    get '/integrations', to:'account#integrations', as: 'account_integrations'
    post '/webhook', to: 'subscriptions#webhook'
    post '/landing_page/preview', to: 'landing_pages#preview', as: 'landing_page_preview'

  end

  get '/google2cb28f06c5aee4fe.html',
        to: proc { |env| [200, {}, ["google-site-verification: google2cb28f06c5aee4fe.html"]] }
end

