class AddScanTable < ActiveRecord::Migration[6.1]
  def change
    create_table :scans do |t|
      t.belongs_to(:scan_source, polymorphic: true)
      t.string(:description)
    end
  end
end
