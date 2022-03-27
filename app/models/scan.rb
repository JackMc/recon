# frozen_string_literal: true
class Scan < ApplicationRecord
  belongs_to :seed, polymorphic: true, optional: true
  belongs_to :target
end
