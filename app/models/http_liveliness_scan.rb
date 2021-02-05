class HttpLivelinessScan < Scan
  has_many :http_probes, foreign_key: :scan_id
end
