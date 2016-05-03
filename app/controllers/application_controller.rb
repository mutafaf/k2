class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :set_header


  def set_header
    @men = Shoppe::ProductCategory.search_category("Men")
    @women = Shoppe::ProductCategory.search_category("Women")

    @belts = Shoppe::ProductCategory.search_category("Belts")
    @cufflinks = Shoppe::ProductCategory.search_category("Cufflinks")

    @shoulder = Shoppe::ProductCategory.search_category("Shoulder")
    @clutch = Shoppe::ProductCategory.search_category("Clutch")

    @earrings = Shoppe::ProductCategory.search_category("Earrings")
    @bracelets = Shoppe::ProductCategory.search_category("Bracelets")
  end

  private

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
