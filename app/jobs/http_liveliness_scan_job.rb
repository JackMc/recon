class HttpLivelinessScanJob < ApplicationJob
  queue_as :default

  def perform(target_id:, path: '/', only_new_domains: false)
    target = Target.find(target_id)
    
    scan = HttpLivelinessScan.create!(
      seed: target,
      target: target,
      description: "HTTP liveliness scan for all domains on #{target.name}",
      metadata: {
        scan_type: 'http_liveliness',
        target_id: target_id,
        scan_source: target.name,
        only_new_domains: only_new_domains,
        path: path
      }
    )

    domains = target.domains

    domains = domains.filter { |domain| domain.http_probes.count == 0 } if only_new_domains

    domains.each do |domain|
      HttpLivelinessProbeJob.perform_later(domain_id: domain.id, scan_id: scan.id, path: path)
    end
  end
end
