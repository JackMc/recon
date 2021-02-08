# frozen_string_literal: true
class Target < ApplicationRecord
  has_many :domains
  has_many :scans
  has_many :http_probes, through: :domains

  def manually_entered_domains
    domains.where(source: 'manual')
  end

  def automated_domains
    domains.where.not(source: 'manual')
  end

  def favourite_domains
    tag = Tag.favourite

    domains.joins(:tagged_items).where(tagged_items: { tag_id: tag.id })
  end
end
