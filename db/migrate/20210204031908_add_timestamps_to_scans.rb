class AddTimestampsToScans < ActiveRecord::Migration[6.1]
  def change
    change_table :scans do |t|
      t.timestamps(null: true)
    end
  end
end
