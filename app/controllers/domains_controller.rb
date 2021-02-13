# frozen_string_literal: true
class DomainsController < ApplicationController
  before_action :load_target
  before_action :load_domain, only: [:show, :update, :edit, :enumerate_subdomains, :destroy, :mark_as_favourite]

  def index
    @domains = @target.domains
  end

  def new
    @domain = Domain.new
  end

  def create
    @domain = Domain.create!(target: @target, **domain_params)
    redirect_to(target_path(@domain.target))
  end

  def show
  end

  def update
    @domain.update!(target: @target, **domain_params)
    redirect_to(target_path(@domain.target))
  end

  def edit
  end

  def destroy
    @domain.destroy!
    redirect_to(target_path(@domain.target))
  end

  def enumerate_subdomains
    DomainDiscoveryJob.perform_later(domain_id: @domain.id, post_to_slack: true)
  end

  def mark_as_favourite
    flash[:notice] = 'Domain favourited'
    add_tag_to_domain('Favourite')
  end

  def add_tag
    add_tag_to_domain(params[:tag])
  end

  private

  def load_domain
    @domain = @target.domains.find(params[:id])
  end

  def load_target
    @target = Target.find(params[:target_id])
  end

  def domain_params
    params.require(:domain).permit(:id, :fqdn).merge(source: 'manual')
  end

  def add_tag_to_domain(name)
    @tag = Tag.find_or_create_by(name: name)
    @domain.tags << @tag
  end
end
