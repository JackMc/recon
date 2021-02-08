# frozen_string_literal: true
class AddMetadataToScans < ActiveRecord::Migration[6.1]
  def change
    change_table(:scans) do |t|
      t.json(:metadata)
    end
  end
end
