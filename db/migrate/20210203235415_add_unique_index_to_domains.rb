# frozen_string_literal: true
class AddUniqueIndexToDomains < ActiveRecord::Migration[6.1]
  def change
    add_index(:domains, [:target_id, :fqdn], length: { fqdn: 256 }, unique: true)
  end
end
