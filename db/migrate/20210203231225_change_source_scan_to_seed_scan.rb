# frozen_string_literal: true
class ChangeSourceScanToSeedScan < ActiveRecord::Migration[6.1]
  def change
    rename_column(:scans, :scan_source_id, :seed_id)
    rename_column(:scans, :scan_source_type, :seed_type)
  end
end
