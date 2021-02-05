# frozen_string_literal: true
class Domain < ApplicationRecord
  belongs_to :target
  belongs_to :source_scan, class_name: 'Scan', optional: true
  has_many :child_scans, foreign_key: :seed_id, class_name: 'Scan', inverse_of: :seed
  has_many :http_probes

  def enqueue_domain_discovery_job
    return unless source == 'manual'

    DomainDiscoveryJob.perform_later(domain_id: id)
  end
end
