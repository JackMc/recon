class HttpLivelinessScanJob < ApplicationJob
  queue_as :default

  def perform(target_id:)
    target = Target.find(target_id)
    
    scan = HttpLivelinessScan.create!(
      seed: target,
      target: target,
      description: "HTTP liveliness scan for all domains on #{target.name}",
      metadata: {
        scan_type: 'http_liveliness',
        target_id: target_id,
        scan_source: target.name
      }
    )

    target.domains.each do |domain|
      HttpLivelinessProbeJob.perform_later(domain_id: domain.id, scan_id: scan.id)
    end
  end
end
