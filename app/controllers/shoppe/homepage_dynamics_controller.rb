class Shoppe::HomepageDynamicsController < Shoppe::ApplicationController
  before_filter { @active_nav = :homepage_dynamics }
  before_filter { params[:id] && @homepage_dynamic = Shoppe::HomepageDynamic.find(params[:id]) }

  def index
    @query = Shoppe::HomepageDynamic.all.page(params[:page]).search(params[:q])
    @homepage_dynamics = @query.result
  end

  def new
    @homepage_dynamic = Shoppe::HomepageDynamic.new
  end

  def show
  end

  def create
    @homepage_dynamic = Shoppe::HomepageDynamic.new(safe_params)
    byebug
    if @homepage_dynamic.save
      redirect_to :homepage_dynamics, flash: { notice: t('shoppe.homepage_dynamics.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @homepage_dynamic.update(safe_params)
      redirect_to [:edit, @homepage_dynamic], flash: { notice: t('shoppe.homepage_dynamics.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @homepage_dynamic.destroy
    redirect_to homepage_dynamics_path, flash: { notice: t('shoppe.homepage_dynamics.deleted_successfully') }
  end

  private

  def safe_params
    file_params = [:file, :parent_id, :role, :parent_type, file: []]
    params[:homepage_dynamic].permit(attachments: [default_image: file_params, extra: file_params, logo_image: file_params])
  end
end
