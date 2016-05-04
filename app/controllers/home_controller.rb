class HomeController < ApplicationController
  def index
    @featured_categories = Shoppe::ProductCategory.get_featured_categories
    @new_arrivals = Shoppe::Product.new_arrivals
    @hot_selling = Shoppe::Product.hot_selling
  end

  def add_subscriber
    @subscriber = Shoppe::Subscriber.new(safe_params)
    if @subscriber.save
      flash[:notice] = t('shoppe.subscribers.subbscribed_successfully')
    else
      flash[:notice] = @subscriber.errors.full_messages.join()
    end
  end

  def contact
    Shoppe::UserMailer.delay.contact_us(params)
    flash[:notice] = "Thank you for your message."
    redirect_to "/"
  end

  private

  def safe_params
    params.permit(:email, :contact_no)
  end

end
