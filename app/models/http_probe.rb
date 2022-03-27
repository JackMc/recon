# frozen_string_literal: true
class HttpProbe < ApplicationRecord
  belongs_to :domain
  belongs_to :scan, optional: true
  has_one_attached :screenshot

  def state
    failed ? "DOWN" : "UP"
  end
end
