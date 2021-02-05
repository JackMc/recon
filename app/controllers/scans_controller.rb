class ScansController < ApplicationController
  before_action :load_target
  before_action :load_scan, only: [:show, :update, :edit, :destroy]

  def index
    @scans = @target.scans
  end

  def new
    @scan = Scan.new
  end

  def create
    @scan = Scan.create!(target: @target, **scan_params)
    redirect_to(target_path(@scan.target))
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
    params.require(:scan).permit(:id, :description)
  end
end
