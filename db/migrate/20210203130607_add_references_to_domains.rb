# frozen_string_literal: true
class AddReferencesToDomains < ActiveRecord::Migration[6.1]
  def change
    change_table(:domains) do |t|
      t.belongs_to(:target)
    end
  end
end
