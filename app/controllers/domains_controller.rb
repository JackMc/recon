class DomainsController < ApplicationController
  before_action :load_target
  before_action :load_domain, only: [:show, :update, :edit, :enumerate_subdomains, :destroy]

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
    DomainDiscoveryJob.perform_later(domain_id: @domain.id)
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
end
