class DomainEnumerationScan < Scan
  has_many :domains, foreign_key: :source_scan_id
end