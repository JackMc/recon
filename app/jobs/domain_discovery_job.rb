class DomainDiscoveryJob < ApplicationJob
  queue_as :default

  BACKENDS = [CrtSh]

  def perform(domain_id:)
    seed_domain = Domain.find(domain_id)
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
          scan_source: backend.name
        }
      )
      
      subdomains.map do |subdomain|
        {
          fqdn: subdomain,
          target_id: target.id,
          source: backend.name,
          source_scan_id: scan.id,
          created_at: Time.now,
          updated_at: Time.now
        }
      end
    end.flatten.uniq

    Domain.upsert_all(domain_objects_for_insert)
  end
end
