class AddTargetToScans < ActiveRecord::Migration[6.1]
  def change
    change_table :scans do |t|
      t.bigint :target_id
    end
  end
end
