# frozen_string_literal: true
class HttpLivelinessScanJob < ApplicationJob
  queue_as :default

  def perform(target_id:, path: '/', only_new_domains: false, screenshot_up_urls: false, domain_scan_source: nil)
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
        screenshot_up_urls: screenshot_up_urls,
        path: path,
      }
    )

    domains = if domain_scan_source
                domain_scan_source.domains
              else
                target.domains
              end

    domains = domains.filter { |domain| domain.http_probes.count == 0 } if only_new_domains

    domains.each do |domain|
      HttpLivelinessProbeJob.perform_later(domain_id: domain.id, scan_id: scan.id, path: path, screenshot: screenshot_up_urls)
    end
  end
end
