class AddRawBodyToHttpProbe < ActiveRecord::Migration[6.1]
  def change
    change_table :http_probes do |t|
      t.text :raw_body
    end
  end
end
