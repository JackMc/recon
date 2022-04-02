class CreateScanSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :scan_schedules do |t|
      t.belongs_to :target
      t.string :title
      t.string :initial_job_type
      t.json :job_parameters

      t.timestamps
    end
  end
end
