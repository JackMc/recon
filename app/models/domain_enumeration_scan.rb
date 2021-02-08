# frozen_string_literal: true
class DomainEnumerationScan < Scan
  has_many :domains, foreign_key: :source_scan_id
  belongs_to :target
end
