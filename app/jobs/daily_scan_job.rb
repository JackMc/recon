class DailyScanJob < ApplicationJob
  queue_as :default

  def perform
    Target.all.each do |target|
      HttpLivelinessScanJob.perform_later(target_id: target.id, screenshot_up_urls: true)
      target.domains.where(source: 'manual').each do |domain|
        DomainDiscoveryJob.perform_later(domain_id: domain.id)
      end
    end
  end
end
