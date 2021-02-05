class HttpProbeFieldsToLongText < ActiveRecord::Migration[6.1]
  def change
    change_column :http_probes, :http_request, :longtext
    change_column :http_probes, :http_response, :longtext
    change_column :http_probes, :raw_body, :longtext
    change_column :http_probes, :body, :longtext
  end
end
