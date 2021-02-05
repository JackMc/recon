class CreateHttpLivelinessScans < ActiveRecord::Migration[6.1]
  def change
    create_table :http_liveliness_scans do |t|

      t.timestamps
    end
  end
end
