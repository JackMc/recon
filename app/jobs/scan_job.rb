class ScanJob < ApplicationJob
  def perform(**kwargs)
    return unless kwargs[:next_scan]

    kwargs[:next_scan].perform_later(**kwargs[:next_scan_arguments])
  end
end
