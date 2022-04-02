class RunScheduledScanJob < ApplicationJob
  queue_as :default

  def perform(scan_schedule)
    return unless scan_schedule.active?

    if scan_schedule.enumerate_domains?
      DomainDiscoveryJob.perform_later(
        pattern: scan_schedule.domain_pattern,
        target_id: scan_schedule.target.id,
        description: "Scheduled Domain Enumeration Scan of #{scan_schedule.domain_pattern}",
        post_to_slack: true,
        schedule: scan_schedule,
        next_scan: HttpLivelinessScanJob,
        next_scan_arguments: {
          target_id: scan_schedule.target.id,
          path: '/', #TODO: User specific paths
          only_new_domains: false,
          screenshot_up_urls: true,
        }
      )
    end
  end
end
