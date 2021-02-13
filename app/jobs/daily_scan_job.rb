class DailyScanJob < ApplicationJob
  queue_as :default

  def perform
    Target.all.each do |target|
      target.domains.where(source: 'manual').each do |domain|
        DomainDiscoveryJob.perform_later(domain_id: domain.id, post_to_slack: true)
      end
    end
  end
end
