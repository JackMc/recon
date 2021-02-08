# frozen_string_literal: true
class CreateHttpLivelinessScans < ActiveRecord::Migration[6.1]
  def change
    create_table(:http_liveliness_scans, &:timestamps)
  end
end
