# frozen_string_literal: true
class CreateDomainTable < ActiveRecord::Migration[6.1]
  def change
    create_table(:domains) do |t|
      t.text(:fqdn)
      t.string(:source)

      t.timestamps
    end
  end
end
