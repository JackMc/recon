# frozen_string_literal: true
class HttpLivelinessScan < Scan
  has_many :http_probes, foreign_key: :scan_id
  belongs_to :target
end
