# frozen_string_literal: true
require 'sidekiq/web'

# frozen_string_literal: true
Rails.application.routes.draw do
  root 'targets#index'

  resources :targets do
    member do
      post :http_liveliness_scan
    end

    resources :scans do
      member do
        get :screenshot_browser_view
      end
    end

    resources :scan_schedules

    resources :http_probes do
      member do
        post :screenshot, method: :post
      end
    end

    resources :domains do
      member do
        post :enumerate_subdomains
        post :mark_as_favourite
      end
    end
  end

  mount Sidekiq::Web => "/sidekiq"
end
