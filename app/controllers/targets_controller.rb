# frozen_string_literal: true
class TargetsController < ApplicationController
  before_action :load_target, only: [:show, :update, :edit, :http_liveliness_scan]

  def index
    @targets = Target.all
  end

  def new
    @target = Target.new
  end

  def create
    @target = Target.create!(target_params)
    redirect_to(target_path(@target))
  end

  def show
  end

  def update
    @target.update!(target_params)
    redirect_to(target_path(@target))
  end

  def edit
  end

  def http_liveliness_scan
    HttpLivelinessScanJob.perform_later(target_id: @target.id)
    redirect_to(target_path(@target))
  end

  private

  def load_target
    @target = Target.find(params[:id])
  end

  def target_params
    params.require(:target).permit(:id, :description, :name)
  end
end
