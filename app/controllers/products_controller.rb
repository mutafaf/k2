class ProductsController < ApplicationController
  def index
    if params[:category_id].present?
      @category = Shoppe::ProductCategory.find(params[:category_id])
      @products = @category.products.page(params[:page]).per(4)
    else
      @products = Shoppe::Product.root.active.page(params[:page]).per(4) #.ordered.includes(:product_categories, :variants)
    end
    @product_categories_without_parent = Shoppe::ProductCategory.without_parent.ordered
    # @products = @products.group_by(&:product_category)
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

    @sizes = @product.get_sizes
    @variants = @product.get_variants

    if request.xhr?
      render :partial => "product_detail_popup"
    end

  end

  def buy
    params[:permalink] = params[:color] if params[:color]
    @product = Shoppe::Product.active.find_by_permalink!(params[:permalink])
    quantity = params[:quantity] ? params[:quantity].to_i : 1

    if @product.has_variants?
      # For Main Product
      @product = @product.default_variant # get default variant here
    end
    if params[:size].blank?
    redirect_to product_path(@product.permalink), :alert => "Please select any size of the Product"
    else
      current_order.order_items.add_item(@product, quantity, params[:size])
      redirect_to basket_path, :notice => "Product has been added successfuly!"
    end
  end
end
