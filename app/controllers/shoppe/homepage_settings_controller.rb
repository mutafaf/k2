class Shoppe::HomepageSettingsController < Shoppe::ApplicationController
  before_filter { @active_nav = :homepage_settings }
  before_filter { params[:id] && @homepage_setting = Shoppe::HomepageSetting.find(params[:id]) }

  def index
    @homepage_settings = Shoppe::HomepageSetting.slider_records.page(params[:page])
    @logo = Shoppe::HomepageSetting.find_by_setting_for("Logo")
  end

  def new
    @homepage_setting = Shoppe::HomepageSetting.new
  end

  def show
  end

  def create
    @homepage_setting = Shoppe::HomepageSetting.new(safe_params)
    if @homepage_setting.save
      redirect_to :homepage_settings, flash: { notice: t('shoppe.homepage_settings.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @homepage_setting.update(safe_params)
      redirect_to [:edit, @homepage_setting], flash: { notice: t('shoppe.homepage_settings.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @homepage_setting.destroy
    redirect_to homepage_settings_path, flash: { notice: t('shoppe.homepage_settings.deleted_successfully') }
  end

  private

  def safe_params
    file_params = [:file, :parent_id, :role, :parent_type, file: []]
    params[:homepage_setting].permit(:setting_for, :category_permalink, :position, attachments: [image: file_params, extra: file_params, logo_image: file_params])
  end
end
