class AddBelongsToScanScheduleToScan < ActiveRecord::Migration[7.0]
  def change
    change_table :scans do |t|
      t.belongs_to :scan_schedule
    end
  end
end
