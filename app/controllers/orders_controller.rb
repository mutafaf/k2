class OrdersController < ApplicationController

  def show
    
  end

  def destroy
    current_order.destroy
    session[:order_id] = nil
    redirect_to root_path, :notice => "Cart emptied successfully."
  end

  def checkout
    redirect_to checkout_details_path if user_signed_in?
  end

  def details
    if params[:user].present?
      login_user(params)
    end

      @order = Shoppe::Order.find(current_order.id)
      if request.patch?
        for_separate_delivery_address(params)
        if @order.proceed_to_confirm(params[:order].permit(:first_name, :last_name, :billing_address1, :billing_city, :billing_country_id, :delivery_address1, :delivery_city, :delivery_country_id, :order_notes, :email_address, :phone_number, :separate_delivery_address, :delivery_name))
          redirect_to checkout_payment_path
          # redirect_to checkout_confirmation_path
        end
      end
  end

  def payment
    if request.post?
      redirect_to checkout_confirmation_path
    end
  end

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
        order_item.size = params[:item_size] if params[:item_size]
        order_item.quantity = params[:item_quantity] if params[:item_quantity]
        # Here params[:item_color_id] is the id of selected variant 
        order_item.ordered_item_id = params[:item_color_id].to_i if params[:item_color_id]
        order_item.save
        @errors = order_item.errors.full_messages.join()
      end
    end
    @current_order = order

    if request.xhr?
      respond_to do |format|
        format.js {}
      end
    end
  end

  def get_order_address
    if user_signed_in?
      customer_id = current_user.try(:customer).try(:id)
      @address = Shoppe::Address.find_address(customer_id, params[:address_type])
    end
  end


  private

  def login_user(params)
    user = User.find_by_email(params[:user][:email])
    if user.present?
       if user.valid_password?(params[:user][:password])
        sign_in(:user, user)
        redirect_to checkout_details_path, :notice => "Signed in successfully."
        return
       end
    end
      redirect_to checkout_path, :alert => "Email or Password is invalid."
  end

  def for_separate_delivery_address(params)
    if params[:order][:separate_delivery_address].present? and user_signed_in?
      customer_id = current_user.try(:customer).try(:id)
      address = Shoppe::Address.find_address(customer_id, "permanent")
      if address.present?
        params[:order][:billing_address1] = address.address1
        params[:order][:billing_city] = address.city
        params[:order][:billing_country_id] = address.country_id
      end
    end
  end

end
