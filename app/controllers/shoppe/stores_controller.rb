class Shoppe::StoresController < Shoppe::ApplicationController
  before_filter { @active_nav = :stores }
  before_filter { params[:id] && @store = Shoppe::Store.find(params[:id]) }

  def index
    @query = Shoppe::Store.order("store_no").page(params[:page]).search(params[:q])
    @stores = @query.result
  end

  def new
    @store = Shoppe::Store.new
  end

  def show
  end

  def create
    @store = Shoppe::Store.new(safe_params)
    if @store.save
      redirect_to :stores, flash: { notice: t('shoppe.stores.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @store.update(safe_params)
      redirect_to [:edit, @store], flash: { notice: t('shoppe.stores.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @store.destroy
    redirect_to stores_path, flash: { notice: t('shoppe.stores.deleted_successfully') }
  end

  def import
    if request.post?
      if params[:import].nil?
        redirect_to import_stores_path, flash: { alert: t('shoppe.imports.errors.no_file') }
      else
        Shoppe::Store.import(params[:import][:import_file])
        redirect_to stores_path, flash: { notice: t('shoppe.stores.imports.success') }
      end
    end
  end

  private

  def safe_params
    params[:store].permit(:store_no, :name, :city, :phone_number)
  end
end
