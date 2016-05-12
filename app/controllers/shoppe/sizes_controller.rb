class Shoppe::SizesController < Shoppe::ApplicationController
  before_filter { @active_nav = :sizes }
  before_filter { params[:id] && @size = Shoppe::Size.find(params[:id]) }

  def index
    @query = Shoppe::Size.all.page(params[:page]).search(params[:q])
    @sizes = @query.result
  end

  def new
    @size = Shoppe::Size.new
  end

  def show
  end

  def create
    @size = Shoppe::Size.new(safe_params)
    if @size.save
      redirect_to :sizes, flash: { notice: t('shoppe.sizes.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @size.update(safe_params)
      redirect_to [:edit, @size], flash: { notice: t('shoppe.sizes.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @size.destroy
    redirect_to sizes_path, flash: { notice: t('shoppe.sizes.deleted_successfully') }
  end

  private

  def safe_params
    params[:size][:name] = params[:size][:name].squish if params[:size][:name]
    params[:size].permit(:name)
  end
end
