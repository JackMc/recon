class Scan < ApplicationRecord
  belongs_to :seed, polymorphic: true
  belongs_to :target
end
