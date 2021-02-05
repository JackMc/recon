class AddHttpRequestToHttpProbe < ActiveRecord::Migration[6.1]
  def change
    change_table :http_probes do |t|
      t.text :http_request
    end
  end
end
