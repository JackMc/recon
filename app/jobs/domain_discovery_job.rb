# frozen_string_literal: true
class DomainDiscoveryJob < ScanJob
  queue_as :default

  BACKENDS = [CrtSh]

  def perform(pattern:, target_id:, description:, post_to_slack: false, extra_metadata: {}, seed: nil, schedule: nil, **kwargs)
    target = Target.find(target_id)
    description = "Domain enumeration scan for #{pattern}" if description.nil? || description.empty?
    schedule_id = schedule&.id

    scan = DomainEnumerationScan.create!(
      seed: seed,
      target: target,
      description: description,
      metadata: {
        seed_pattern: pattern,
        scan_type: 'subdomain_enumeration',
      },
      scan_schedule_id: schedule_id,
    )

    domain_objects_for_insert  = BACKENDS.map do |backend|
      subdomains = backend.query(pattern)

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

    Domain.insert_all(domain_objects_for_insert) unless domain_objects_for_insert.empty?

    send_results_to_slack(scan) if post_to_slack

    super
  end

  def send_results_to_slack(scan)
    return if scan.domains.empty?

    SlackClient.client.chat_postMessage(channel: '#domains', text: <<~MESSAGE)
New domains discovered for #{scan.metadata["seed_pattern"]}:
#{scan.domains.map { |domain| "- #{domain.fqdn}"}.join("\n")}
MESSAGE
  end
end
