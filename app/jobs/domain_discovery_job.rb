# frozen_string_literal: true
class DomainDiscoveryJob < ApplicationJob
  queue_as :default

  BACKENDS = [CrtSh]

  def perform(domain_id:, post_to_slack: false)
    seed_domain = Domain.find(domain_id)
    fqdn = seed_domain.fqdn
    target = seed_domain.target

    scan = DomainEnumerationScan.create!(
      seed: seed_domain,
      target: seed_domain.target,
      description: "Subdomain enumeration scan for #{fqdn}",
      metadata: {
        scan_type: 'subdomain_enumeration',
        seed_domain: fqdn,
      }
    )

    domain_objects_for_insert  = BACKENDS.map do |backend|
      subdomains = backend.subdomains(fqdn)

      subdomains.map do |subdomain|
        cleaned_subdomain = subdomain.gsub(/\*\./, '')

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

    Domain.insert_all(domain_objects_for_insert)

    send_results_to_slack(scan) if post_to_slack
  end

  def send_results_to_slack(scan)
    return if scan.domains.empty?

    SlackClient.client.chat_postMessage(channel: '#domains', text: <<~MESSAGE)
New domains discovered for #{scan.seed.fqdn}:
#{scan.domains.map { |domain| "- #{domain.fqdn}"}.join("\n")}
MESSAGE
  end
end
