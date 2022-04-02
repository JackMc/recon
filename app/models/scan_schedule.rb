class ScanSchedule < ApplicationRecord
  belongs_to :target
  has_many :scans

  scope :active, -> { where(active: true) }
end
