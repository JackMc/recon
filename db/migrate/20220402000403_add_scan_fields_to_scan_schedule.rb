class AddScanFieldsToScanSchedule < ActiveRecord::Migration[7.0]
  def up
    remove_column :scan_schedules, :title
    remove_column :scan_schedules, :initial_job_type
    remove_column :scan_schedules, :job_parameters

    change_table :scan_schedules do |t|
      t.string :title
      t.boolean :enumerate_domains
      t.string :domain_pattern

      t.boolean :http_probe
      t.boolean :screenshot
      t.boolean :response_diff
      t.boolean :photo_diff
    end
  end
end
