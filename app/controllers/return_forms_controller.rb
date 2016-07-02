class ReturnFormsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_return_form, only: [:show, :edit, :update, :destroy]

  # GET /return_forms
  # GET /return_forms.json
  def index
    @return_forms = ReturnForm.all
  end

  # GET /return_forms/1
  # GET /return_forms/1.json
  def show
  end

  # GET /return_forms/new
  def new
    @return_form = ReturnForm.new
  end

  # GET /return_forms/1/edit
  def edit
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

  # PATCH/PUT /return_forms/1
  # PATCH/PUT /return_forms/1.json
  def update
    respond_to do |format|
      if @return_form.update(return_form_params)
        format.html { redirect_to @return_form, notice: 'Return form was successfully updated.' }
        format.json { render :show, status: :ok, location: @return_form }
      else
        format.html { render :edit }
        format.json { render json: @return_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_forms/1
  # DELETE /return_forms/1.json
  def destroy
    @return_form.destroy
    respond_to do |format|
      format.html { redirect_to return_forms_url, notice: 'Return form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_form
      @return_form = ReturnForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_form_params
      params.require(:return_form).permit(:name, :email, :order_number, :serial_number, :item_number, :description, :return_quantity, :reason, :action_detail, :comment)
    end
end
