# frozen_string_literal: true
class AddStatusToScans < ActiveRecord::Migration[6.1]
  def change
    change_table(:scans) do |t|
      t.string(:status)
    end
  end
end
