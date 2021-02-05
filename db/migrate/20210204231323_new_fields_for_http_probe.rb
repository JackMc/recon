class NewFieldsForHttpProbe < ActiveRecord::Migration[6.1]
  def change
    change_table :http_probes do |t|
      t.rename :domains_id, :domain_id
      t.integer :status_code
      t.string :status_name
      t.boolean :https
      t.text :body
      t.json :headers
    end
  end
end
