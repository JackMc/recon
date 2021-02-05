class DeleteTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :http_liveliness_scans
    drop_table :domain_enumeration_scans
  end
end
