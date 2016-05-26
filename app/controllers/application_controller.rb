class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :set_header, :brands
  helper_method :resource, :resource_name, :devise_mapping

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

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

  private

  def brands
    @footer_brands = Shoppe::Brand.order("position ASC").all.limit(4)
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

  helper_method :current_order, :has_order?
end
