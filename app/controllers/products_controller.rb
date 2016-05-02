class ProductsController < ApplicationController
  def index
    if params[:category_id].present?
      @products = Shoppe::ProductCategory.find(params[:category_id]).products
    else
      @products = Shoppe::Product.root.active#.ordered.includes(:product_categories, :variants)
    end
    @product_categories_without_parent = Shoppe::ProductCategory.without_parent.ordered
    # @products = @products.group_by(&:product_category)
  end

  def show
    @product = Shoppe::Product.active.find_by_permalink(params[:permalink])

    if @product.default
      # For Main Product
      @product = @product.parent # get default variant here
    end

    @sizes = @product.get_sizes
    @variants = @product.get_variants
  end

  def buy
    @product = Shoppe::Product.active.find_by_permalink!(params[:permalink])
    quantity = params[:quantity] ? params[:quantity].to_i : 1

    if @product.has_variants?
      # For Main Product
      @product = @product.default_variant # get default variant here
    end

    if params[:size].blank?
    redirect_to product_path(@product.permalink), :notice => "Please select any size of the Product"
    else
      current_order.order_items.add_item(@product, quantity, params[:size])
      redirect_to basket_path, :notice => "Product has been added successfuly!"
    end
  end
end
