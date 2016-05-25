class ProductsController < ApplicationController
  def index

    @category, @products = Shoppe::Product.active.find_products(params)

    @product_categories_without_parent = Shoppe::ProductCategory.without_parent.custom_ordered
    # @products = @products.group_by(&:product_category)
    @pagination = params[:pagination]

    @brands = Shoppe::Product.collect_brands
    @color_names = Shoppe::Product.collect_color_names
    @sizes = Shoppe::Product.collect_sizes

    respond_to do |format|
      format.js{}
      format.html{}
    end
  end

  def show
    @product = Shoppe::Product.active.find_by_permalink(params[:permalink])

    if @product.default
      # For Main Product
      @product = @product.parent # get default variant here
    end

    @sizes = @product.get_available_sizes
    @variants = @product.get_variants

    if request.xhr?
      if params[:color].present?
        render :partial => "product_display"
      else
        render :partial => "product_detail_popup"
      end
    end

  end

  def buy
    @product = Shoppe::Product.active.find_by_permalink!(params[:permalink])
    quantity = params[:quantity] ? params[:quantity].to_i : 1
    if @product.has_variants? and @product.default_variant.present?
      # For Main Product
      @product = @product.default_variant # get default variant here
    end

    if params[:size].blank? and @product.try(:has_sizes?)
    redirect_to product_path(@product.permalink), :alert => "Please select any Size."
    else
      begin
        current_order.order_items.add_item(@product, quantity, params[:size])
        redirect_to product_path(@product.permalink), :notice => "Product has been added successfuly!"
      rescue Shoppe::Errors::NotEnoughStock
        flash[:error] = "Not enough stock available for this product."
        redirect_to product_path(@product.permalink)
      rescue Shoppe::Errors::UnorderableItem
        flash[:error] = "Sorry, This product can not be ordered."
        redirect_to product_path(@product.permalink)
      end
    end
  end

end
