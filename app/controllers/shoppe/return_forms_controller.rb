class Shoppe::ReturnFormsController < Shoppe::ApplicationController
  before_filter { @active_nav = :return_forms }
  before_filter { params[:id] && @return_form = ReturnForm.find(params[:id]) }

  def index
    @query = ReturnForm.all.page(params[:page]).search(params[:q])
    @return_forms = @query.result
  end

  def new
    @return_form = ReturnForm.new
  end

  def show
  end

  def create
    @return_form = ReturnForm.new(safe_params)
    if @return_form.save
      redirect_to :return_forms, flash: { notice: t('shoppe.return_forms.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @return_form.update(safe_params)
      redirect_to [:edit, @return_form], flash: { notice: t('shoppe.return_forms.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @return_form.destroy
    redirect_to return_forms_path, flash: { notice: t('shoppe.return_forms.deleted_successfully') }
  end

  private

  def safe_params
    params[:return_form].permit(:name, :email, :order_number, :serial_number, :item_number, :description, :return_quantity, :reason, :action_detail, :comment)
  end
end
