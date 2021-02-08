# frozen_string_literal: true
class AddHttpProbesTable < ActiveRecord::Migration[6.1]
  def change
    create_table(:http_probes) do |t|
      t.belongs_to(:domains)
      t.text(:http_response)
      t.string(:url)
      t.timestamps
    end
  end
end
