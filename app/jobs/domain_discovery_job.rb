# frozen_string_literal: true
class DomainDiscoveryJob < ApplicationJob
  queue_as :default

  BACKENDS = [CrtSh]

  def perform(domain_id:)
    seed_domain = Domain.find(domain_id)
    manual_domain_fqdns = Domain.where(source: 'manual').pluck(:fqdn)
    fqdn = seed_domain.fqdn
    target = seed_domain.target
    domain_objects_for_insert = BACKENDS.map do |backend|
      start_time = Time.now
      subdomains = backend.subdomains(fqdn)
      time_elapsed = Time.now - start_time

      scan = DomainEnumerationScan.create!(
        seed: seed_domain,
        target: seed_domain.target,
        description: "#{backend.name} subdomain enumeration scan for #{fqdn}",
        metadata: {
          scan_type: 'subdomain_enumeration',
          seed_domain: fqdn,
          scan_time: time_elapsed,
          scan_source: backend.name,
        }
      )

      subdomains.map do |subdomain|
        cleaned_subdomain = subdomain.gsub(/\*\./, '')
        next if manual_domain_fqdns.include?(cleaned_subdomain)

        {
          fqdn: cleaned_subdomain,
          target_id: target.id,
          source: backend.name,
          source_scan_id: scan.id,
          wildcard: subdomain.start_with?('*'),
          created_at: Time.now,
          updated_at: Time.now,
        }
      end
    end.compact.flatten.uniq

    Domain.upsert_all(domain_objects_for_insert)
  end
end
