class ScanSchedulesController < ApplicationController
  before_action :load_target
  before_action :load_scan_schedule, only: [:show, :update, :edit]

  def index
    @scan_schedules = ScanSchedule.where(target: @target)
  end

  def edit
  end

  def update
    @scan_schedule.update!(
      target: @target,
      active: scan_schedule_params[:active],
      title: scan_schedule_params[:title],
      enumerate_domains: scan_schedule_params[:enumerate_domains],
      domain_pattern: scan_schedule_params[:domain_pattern],
      http_probe: scan_schedule_params[:http_probe],
      screenshot: scan_schedule_params[:screenshot],
      response_diff: scan_schedule_params[:response_diff],
      photo_diff: scan_schedule_params[:photo_diff],
    )

    redirect_to(target_scan_schedule_url(@target, @scan_schedule))
  end

  def new
    @scan_schedule = ScanSchedule.new
  end

  def create
    @scan_schedule = ScanSchedule.create!(
      target: @target,
      active: scan_schedule_params[:active],
      title: scan_schedule_params[:title],
      enumerate_domains: scan_schedule_params[:enumerate_domains],
      domain_pattern: scan_schedule_params[:domain_pattern],
      http_probe: scan_schedule_params[:http_probe],
      screenshot: scan_schedule_params[:screenshot],
      response_diff: scan_schedule_params[:response_diff],
      photo_diff: scan_schedule_params[:photo_diff],
    )

    redirect_to(target_scan_schedule_url(@target, @scan_schedule))
  end

  def load_target
    @target ||= Target.find(params[:target_id])
  end

  def load_scan_schedule
    @scan_schedule ||= ScanSchedule.find(params[:id])
  end

  private

  def scan_schedule_params
    params.require(:scan_schedule).permit(:id, :title, :active, :enumerate_domains, :domain_pattern, :http_probe, :screenshot, :response_diff, :photo_diff)
  end
end
