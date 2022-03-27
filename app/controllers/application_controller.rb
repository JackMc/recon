# frozen_string_literal: true
class ApplicationController < ActionController::Base
  http_basic_authenticate_with(name: "jackmc", password: ENV["HTTP_PASSWORD"]) if Rails.env.production?
end
