module Shoppe
  class VariantsController < ApplicationController
    before_filter { @active_nav = :products }
    before_filter { @product = Shoppe::Product.find(params[:product_id]) }
    before_filter { params[:id] && @variant = @product.variants.find(params[:id]) }

    def index
      @variants = @product.variants.ordered
    end

    def new
      @variant = @product.variants.build
      render action: 'form'
    end

    def create
      @variant = @product.variants.build(safe_params)
      if @variant.save
        redirect_to [@product, :variants], notice: t('shoppe.variants.create_notice')
      else
        render action: 'form'
      end
    end

    def edit
      render action: 'form'
    end

    def update
      if @variant.update(safe_params)
        redirect_to edit_product_variant_path(@product, @variant), notice: t('shoppe.variants.update_notice')
      else
        render action: 'form'
      end
    end

    def destroy
      @variant.destroy
      redirect_to [@product, :variants], notice: t('shoppe.variants.destroy_notice')
    end

    private

    def safe_params
      params[:product][:color_name] = params[:product][:name] if params[:product][:name].present?
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name, :color, :color_name, :permalink, :sku, :price, :old_price, :tax_rate_id, :weight, :stock_control, :active, :default, size_ids: [], attachments: [default_image: file_params, extra: file_params])
    end
  end
end
