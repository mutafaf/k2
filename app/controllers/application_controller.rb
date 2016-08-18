class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :set_header, :set_footer
  helper_method :resource, :resource_name, :devise_mapping
  before_filter :set_default_url_options

  def not_found
    respond_to do |format|
      format.html { render template: 'layouts/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def set_delivery_charges(order)
    order = Shoppe::Order.find(order.id)
    if order.products_total >= Shoppe::Order::ORDER_AMOUNT || order.products_total == 0
      order.delivery_charges = 0
      order.save
    else
      order.delivery_charges = Shoppe::Order::DELIVERY_CHARGES
      order.save
    end
  end

  private

  def set_header
    @men = Shoppe::ProductCategory.search_category("Men")
    @women = Shoppe::ProductCategory.search_category("Women")

    @belts = Shoppe::ProductCategory.search_category("Belts")
    @cufflinks = Shoppe::ProductCategory.search_category("Cufflinks")

    @shoulder = Shoppe::ProductCategory.search_category("Shoulder")
    @clutch = Shoppe::ProductCategory.search_category("Clutch")

    @earrings = Shoppe::ProductCategory.search_category("Earrings")
    @bracelets = Shoppe::ProductCategory.search_category("Bracelets")

    @bags = Shoppe::ProductCategory.search_category("Bags")
    @assessories = Shoppe::ProductCategory.search_category("Assessories")
  end

  def set_footer
    @footer_brands = Shoppe::Brand.order("position ASC").all.limit(4)
    @policies = Shoppe::Policy.order("position ASC").all
  end

  def current_order
    @current_order ||= begin
      if has_order?
        @current_order
      else
        order = Shoppe::Order.create(:ip_address => request.ip)
        session[:order_id] = order.id
        order
      end
    end
  end

  def has_order?
    !!(
      session[:order_id] &&
        @current_order = Shoppe::Order.includes(:order_items => :ordered_item).find_by_id(session[:order_id])
    )
  end

  def set_default_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end
  
  helper_method :current_order, :has_order?
end
