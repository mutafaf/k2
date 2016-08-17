class Shoppe::PoliciesController < Shoppe::ApplicationController
  before_filter { @active_nav = :policies }
  before_filter :find_policy, only: [:edit, :update, :destroy]

  def index
    @query = Shoppe::Policy.all.page(params[:page]).search(params[:q])
    @policies = @query.result
  end

  def new
    @policy = Shoppe::Policy.new
  end

  def create
    @policy = Shoppe::Policy.new(policy_params)
    if @policy.save
      redirect_to :policies, flash: { notice: t('shoppe.policies.created_successfully') }
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @policy.update(policy_params)
      redirect_to [:edit, @policy], flash: { notice: t('shoppe.policies.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @policy.destroy
    redirect_to policies_path, flash: { notice: t('shoppe.sizes.deleted_successfully') }
  end

  private

  def policy_params
    params[:policy].permit(:title, :description, :permalink, :position)
  end

  def find_policy
    @policy = Shoppe::Policy.find(params[:id])
  end

end
