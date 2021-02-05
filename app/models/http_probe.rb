class HttpProbe < ApplicationRecord
  belongs_to :domain
  belongs_to :scan, optional: true

  def up_status
    failed ? "DOWN" : "UP"
  end
end
