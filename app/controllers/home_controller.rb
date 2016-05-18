class HomeController < ApplicationController
  def index
    @featured_categories = Shoppe::ProductCategory.get_featured_categories
    @new_arrivals = Shoppe::Product.new_arrivals
    @hot_selling = Shoppe::Product.hot_selling
  end

  def add_subscriber
    @subscriber = Shoppe::Subscriber.new(safe_params)
    @subscriber.save
    @errors = @subscriber.errors.full_messages.join()
  end

  def contact
    Shoppe::UserMailer.delay.contact_us(params)
    flash[:notice] = "Thank you for your message."
    redirect_to "/"
  end

  def store_location
  end

  def find_nearest_stores
    if params[:lat] and params[:lng]
      @stores = Shoppe::Store.near([params[:lat], params[:lng]], 5)
    end
  end

  def brand_page
    @brand = Shoppe::Brand.find_by_permalink(params[:permalink])
  end

  private

  def safe_params
    params.permit(:email, :contact_no)
  end

end
