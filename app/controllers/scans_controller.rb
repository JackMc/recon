# frozen_string_literal: true
class ScansController < ApplicationController
  before_action :load_target
  before_action :load_scan, only: [:show, :update, :edit, :destroy, :screenshot_browser_view]

  SCAN_TYPES = [HttpLivelinessScan, DomainEnumerationScan]

  def index
    @scans = @target.scans
  end

  def new
    @scan = if params[:duplicate_id]
              Scan.find(params[:duplicate_id])
            else
              Scan.new
            end
  end

  def create
    scan_type = scan_params[:type]
    # determine from the scan type which form fields to parse
    if scan_type == "HttpLivelinessScan"
      HttpLivelinessScanJob.perform_later(target_id: @target.id, path: scan_params[:path],
only_new_domains: scan_params[:only_new_domains] == '1', screenshot_up_urls: scan_params[:screenshot_up_urls] == '1')
    elsif scan_type == "DomainEnumerationScan"

    end
    redirect_to(target_scans_path(@target))
  end

  def screenshot_browser_view
    head(:not_found) unless @scan.type == "HttpLivelinessScan"
  end

  def show
  end

  def update
    @scan.update!(target: @target, **scan_params)
    redirect_to(target_path(@scan.target))
  end

  def edit
  end

  def destroy
    @scan.destroy!
    redirect_to(target_path(@scan.target))
  end

  private

  def load_scan
    @scan = @target.scans.find(params[:id])
  end

  def load_target
    @target = Target.find(params[:target_id])
  end

  def scan_params
    params.require(:scan).permit(:id, :description, :only_new_domains, :path, :type, :screenshot_up_urls)
  end
end
