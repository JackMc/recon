class SeededDomainDiscoveryJob < ApplicationJob
  queue_as :default

  def perform(domain_id:, **options)
    seed_domain = Domain.find(domain_id)
    target = seed_domain.target

    DomainDiscoveryJob.perform_later(
      pattern: "%.#{seed_domain.fqdn}",
      target_id: target.id,
      description: "Subdomain enumeration scan for #{seed_domain.fqdn}",
      **options
    )
  end
end
