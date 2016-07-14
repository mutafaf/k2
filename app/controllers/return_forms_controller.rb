class ReturnFormsController < ApplicationController

  # GET /return_forms/new
  def new
    @return_form = ReturnForm.new
  end

  # POST /return_forms
  # POST /return_forms.json
  def create
    @return_form = ReturnForm.new(return_form_params)

    respond_to do |format|
      if @return_form.save
        format.html { redirect_to root_url, notice: 'Return Merchandise form was successfully submitted and processed.' }
        format.json { render :show, status: :created, location: @return_form }
      else
        format.html { render :new }
        format.json { render json: @return_form.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_form_params
      params.require(:return_form).permit(:name, :email, :order_number, :serial_number, :item_number, :description, :return_quantity, :reason, :action_detail, :comment)
    end
end
