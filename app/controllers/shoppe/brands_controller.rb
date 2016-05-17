class Shoppe::BrandsController < Shoppe::ApplicationController
  before_filter { @active_nav = :brands }
  before_filter :find_brand, only: [:edit, :update, :destroy]

  def index
    @query = Shoppe::Brand.all.page(params[:page]).search(params[:q])
    @brands = @query.result
  end

  def new
    @brand = Shoppe::Brand.new
  end

  def create
    @brand = Shoppe::Brand.new(brand_params)
    if @brand.save
      redirect_to :brands, flash: { notice: t('shoppe.brands.created_successfully') }
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      redirect_to [:edit, @brand], flash: { notice: t('shoppe.brands.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @brand.destroy
    redirect_to brands_path, flash: { notice: t('shoppe.sizes.deleted_successfully') }
  end

  private

  def brand_params
    file_params = [:file, :parent_id, :role, :parent_type, file: []]
    params[:brand].permit(:name, :description, :permalink, :position, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
  end

  def find_brand
    @brand = Shoppe::Brand.find(params[:id])
  end

end
