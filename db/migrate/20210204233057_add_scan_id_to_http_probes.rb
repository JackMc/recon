# frozen_string_literal: true
class AddScanIdToHttpProbes < ActiveRecord::Migration[6.1]
  def change
    change_table(:http_probes) do |t|
      t.bigint(:scan_id)
    end
  end
end
