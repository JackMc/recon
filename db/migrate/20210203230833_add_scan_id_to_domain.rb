# frozen_string_literal: true
class AddScanIdToDomain < ActiveRecord::Migration[6.1]
  def change
    change_table(:domains) do |t|
      t.belongs_to(:source_scan)
    end
  end
end
