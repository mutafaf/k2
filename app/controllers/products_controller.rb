class ProductsController < ApplicationController

  before_action :find_products, only: [:index]

  def index
    @product_categories_without_parent = Shoppe::ProductCategory.without_parent.custom_ordered
    # @products = @products.group_by(&:product_category)

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

    unless @product.present?
      render "layouts/not_found"
      return
    end

    if @product.has_variants? and @product.default_variant.present?
      # If Main Product then
      @product = @product.default_variant # get default variant here
    end

    @sizes = @product.get_available_sizes
    @variants = @product.get_available_variants

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
        set_delivery_charges(current_order) # Set Delivery Charges
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


  def find_products
    session[:category_permalink] = params[:category_permalink] if params[:category_permalink].present?
    heading = ""
    if params[:new_arrivals].present?
      heading = Shoppe::Product::NEW_ARRIVALS
      products = Shoppe::Product.new_arrivals

    elsif params[:hot_selling].present?
      heading = Shoppe::Product::HOT_SELLING
      products = Shoppe::Product.hot_selling

    elsif params[:category_permalink].present?
      category = Shoppe::Product.find_category(session[:category_permalink])
      products = Shoppe::Product.find_by_category_and_descendants(category) if category

    elsif params[:category_name].present?
      category = Shoppe::ProductCategory.search_home_category(params[:category_name])
      products = category.products if category

    elsif params[:color_name].present?
      heading = params[:color_name]
      products = Shoppe::Product.find_by_color_name(params[:color_name], session[:category_permalink])

    elsif params[:brand].present?
      heading = params[:brand]
      products = Shoppe::Product.find_by_brands(params[:brand])

    elsif params[:size_id].present?
      heading = Shoppe::Size.find(params[:size_id]).try(:name)
      products = Shoppe::Product.find_by_size_id(params[:size_id], session[:category_permalink])
    elsif params[:min_price].present? and params[:max_price].present?
      heading = Shoppe::Product::PRICE_RANGE
      products = Shoppe::Product.find_by_price(params[:min_price], params[:max_price], session[:category_permalink])
      products = products.order("price") if products
    else
      products = Shoppe::Product.root #.ordered.includes(:product_categories, :variants)
    end

    products = products.active.page(params[:page]).per(Shoppe::Product::PER_PAGE) if products

    @heading = heading
    @category= category
    @products = products
  end

end
