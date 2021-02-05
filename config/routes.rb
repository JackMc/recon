require 'sidekiq/web'

# frozen_string_literal: true
Rails.application.routes.draw do
  resources :targets do
    member do
      post :http_liveliness_scan
    end

    resources :scans

    resources :http_probes

    resources :domains do
      member do
        post :enumerate_subdomains
      end
    end
  end

  mount Sidekiq::Web => "/sidekiq"
end
