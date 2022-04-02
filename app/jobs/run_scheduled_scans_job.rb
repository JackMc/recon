# Runs every hour to hit all the schedules
class RunScheduledScansJob < ApplicationJob
  queue_as :default

  def perform
    @scan_schedules = ScanSchedule.active
    
    @scan_schedules.each do |scan_schedule|
      RunScheduledScanJob.perform_later(scan_schedule)
    end
  end
end
