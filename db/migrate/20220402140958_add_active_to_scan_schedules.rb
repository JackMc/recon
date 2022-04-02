class AddActiveToScanSchedules < ActiveRecord::Migration[7.0]
  def change
    change_table :scan_schedules do |t|
      t.boolean :active
    end
  end
end
