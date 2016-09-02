class Shoppe::DynamicOptionsController < Shoppe::ApplicationController
  before_filter { @active_nav = :dynamic_options }
  before_filter { params[:id] && @dynamic_option = Shoppe::DynamicOption.find(params[:id]) }

  def index
    @query = Shoppe::DynamicOption.ordered.page(params[:page]).search(params[:q])
    @dynamic_options = @query.result
  end

  def new
    @dynamic_option = Shoppe::DynamicOption.new
  end

  def show
  end

  def create
    @dynamic_option = Shoppe::DynamicOption.new(safe_params)
    if @dynamic_option.save
      redirect_to :dynamic_options, flash: { notice: t('shoppe.dynamic_options.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @dynamic_option.update(safe_params)
      redirect_to [:edit, @dynamic_option], flash: { notice: t('shoppe.dynamic_options.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @dynamic_option.destroy
    redirect_to dynamic_options_path, flash: { notice: t('shoppe.dynamic_options.deleted_successfully') }
  end

  def import
    if request.post?
      if params[:import].nil?
        redirect_to import_dynamic_options_path, flash: { alert: t('shoppe.imports.errors.no_file') }
      else
        Shoppe::DynamicOption.import(params[:import][:import_file])
        redirect_to dynamic_options_path, flash: { notice: t('shoppe.dynamic_options.imports.success') }
      end
    end
  end

  private

  def safe_params
    params[:dynamic_option][:name] = params[:dynamic_option][:title].squish if params[:dynamic_option][:title]
    params[:dynamic_option].permit(:title, :options_for)
  end
end
