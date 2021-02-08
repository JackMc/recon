# frozen_string_literal: true
class Domain < ApplicationRecord
  belongs_to :target
  belongs_to :source_scan, class_name: 'Scan', optional: true
  has_many :child_scans, foreign_key: :seed_id, class_name: 'Scan', inverse_of: :seed
  has_many :http_probes
  has_many :tagged_items
  has_many :tags, through: :tagged_items
  has_and_belongs_to_many :tags, join_table: 'tagged_items'
end
