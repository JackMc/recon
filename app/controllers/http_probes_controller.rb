# frozen_string_literal: true
class HttpProbesController < ApplicationController
  before_action :load_target
  before_action :load_http_probe, only: [:show, :update, :edit, :destroy, :screenshot]

  def index
    @http_probes = HttpProbe.all
  end

  def new
    @http_probe = HttpProbe.new
  end

  def create
    @http_probe = HttpProbe.create!(target: @target, **http_probe_params)
    redirect_to(target_path(@http_probe.target))
  end

  def show
  end

  def update
    @http_probe.update!(target: @target, **http_probe_params)
    redirect_to(target_path(@http_probe.target))
  end

  def edit
  end

  def destroy
    @http_probe.destroy!
    redirect_to(target_path(@http_probe.target))
  end

  def screenshot
    ScreenshotJob.perform_later(http_probe_id: @http_probe.id)
    redirect_to(target_http_probe_path(@target, @http_probe))
  end

  private

  def load_http_probe
    @http_probe = @target.http_probes.find(params[:id])
  end

  def load_target
    @target = Target.find(params[:target_id])
  end

  def http_probe_params
    params.require(:http_probe).permit(:id, :description)
  end
end
