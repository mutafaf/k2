class OrdersController < ApplicationController

  def show
    
  end

  def destroy
    current_order.destroy
    session[:order_id] = nil
    redirect_to root_path, :notice => "Basket emptied successfully."
  end

  def checkout
  end

  def details
      @order = Shoppe::Order.find(current_order.id)
      if request.patch?
        if @order.proceed_to_confirm(params[:order].permit(:first_name, :last_name, :billing_address1, :city, :order_notes, :billing_country_id, :billing_postcode, :email_address, :phone_number))
          # redirect_to checkout_payment_path
          redirect_to checkout_confirmation_path
        end
      end
  end

  # def payment
  #   if request.post?
  #     redirect_to checkout_confirmation_path
  #   end
  # end

  def confirmation
    @order = Shoppe::Order.find(current_order.id)
    if request.post?
      current_order.confirm!
      session[:order_id] = nil
      redirect_to root_path, :notice => "Order has been placed successfully!"
    end
  end

  def update_order_items
    order = Shoppe::Order.find(current_order.id)
    order_item = order.order_items.find(params[:item_id].to_i)
    if params[:remove_row].present? and params[:remove_row] == "true"
      order_item.remove
    else
      if order_item
        order_item.size = params[:item_size]
        order_item.quantity = params[:item_quantity]
        # Here params[:item_color_id] is the id of selected variant 
        order_item.ordered_item_id = params[:item_color_id].to_i
        order_item.save
      end
    end
    @current_order = order
    # render :nothing => true
    # redirect_to basket_path
    render :partial => "cart_page"
  end

end
