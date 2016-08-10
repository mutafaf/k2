class OrdersController < ApplicationController
  
  def show
    
  end

  def destroy
    current_order.destroy
    session[:order_id] = nil
    redirect_to root_path, :notice => "Cart emptied successfully."
  end

  def checkout
    if current_order.total_items == 0
      redirect_to basket_path, :alert=> "Please add any Item(s) to Cart."
    else
      redirect_to checkout_details_path if user_signed_in?
    end
  end

  def details
    if params[:user].present?
      login_user(params)
    end

      @order = Shoppe::Order.find(current_order.id)
      if request.patch?
        for_separate_delivery_address(params)
        if @order.proceed_to_confirm(safe_params)
          redirect_to checkout_confirmation_path
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
    if current_order.payment_method == "Credit/Debit Card"
        @transaction_id = ipg_payment(@order)
    else
      if request.post?
          current_order.confirm!
          session[:order_id] = nil
          redirect_to root_path, :notice => "Order has been placed successfully!"
      end
    end
  end

  def confirmation_page
    session[:transaction_id] = params[:TransactionID]
    result = query_transaction()
    result = JSON.parse(result)
    card_token = result["QueryTransactionResult"]["Payer"]["CardToken"]
    @order = Shoppe::Order.find(current_order.id)

    if card_token.present?
      if Shoppe::Payment.last_month.where(card_token: card_token).count < 5
        flash[:notice] = "Your Card has been verified. Please complete your order now."
        return
      else
        redirect_to root_path, :alert =>"Your have reached maximum limit (5 times in a month) of shopping using Credit/Debit Card. Please contact Borjan for details."
      end
    else
      redirect_to root_path, :alert => "Your Card verification Failed !"
    end
    
  end

  def finalize
    result = finalize_payment
    result = JSON.parse(result)
    confirm_payment(result)
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

    set_delivery_charges(order)

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

  def track
    if params[:order_id].present?
      @order = Shoppe::Order.find_by_id(params[:order_id])
    end
  end


  private

  def query_transaction
    transaction_id = session[:transaction_id]
    customer = "Demo Merchant"
    path = "lib/"
    `php -f #{ path + 'IPG_Query.php "' + customer + '" ' + transaction_id}`
  end

  def ipg_payment(order)
    customer = "Demo Merchant"
    amount = order.total.to_s
    order_id = order.id.to_s
    order_info = order_info(order)
    order_name = "141850"
    returnpath = "#{request.base_url}/checkout/confirmation_page"
    path = "lib/"
    `php -f #{ path + 'IPG_Registration.php "' + customer + '" ' + amount + ' '+ order_id + ' "' + order_info + '" '+ order_name + ' '+ returnpath }`
  end

  def finalize_payment
    transaction_id = session[:transaction_id]
    customer = "Demo Merchant"
    path = "lib/"
    `php -f #{ path + 'IPG_Finalise.php "' + customer + '" ' + transaction_id}`
  end

  def confirm_payment(result)
    if result["FinalizeResult"]["ResponseCode"] == 0
      confirmed = true
      current_order.confirm!
      session[:order_id] = nil
      Shoppe::Payment.create(:order_id => current_order.id,
        :method => current_order.payment_method,
        :confirmed => confirmed,
        :response_code => result["FinalizeResult"]["ResponseCode"],
        :response_description => result["FinalizeResult"]["ResponseDescription"],
        :uniqueId => result["FinalizeResult"]["UniqueID"],
        :version => result["FinalizeResult"]["version"],
        :amount => result["FinalizeResult"]["Amount"],
        :account => result["FinalizeResult"]["Account"],
        :approval_code => result["FinalizeResult"]["ApprovalCode"],
        :balance => result["FinalizeResult"]["Balance"],
        :card_brand => result["FinalizeResult"]["CardBrand"],
        :card_number => result["FinalizeResult"]["CardNumber"],
        :card_token => result["FinalizeResult"]["CardToken"],
        :fees => result["FinalizeResult"]["Fees"],
        :orderID => result["FinalizeResult"]["OrderID"])

      redirect_to "/", :notice => result["FinalizeResult"]["ResponseDescription"]
    else
      redirect_to "/", :alert => result["FinalizeResult"]["ResponseDescription"]
    end
  end

  def order_info(order)
    s = " "
      for item in order.order_items
        s = s + "#{item.quantity} x #{item.ordered_item.full_name} " 
      end
    return s
  end

  def safe_params
    params[:order].permit(:first_name, :last_name, :billing_address1, :billing_city, :billing_country_id, :delivery_address1, :delivery_city, :delivery_country_id, :order_notes, :email_address, :phone_number, :separate_delivery_address, :delivery_name, :payment_method, :terms_of_service)
  end

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
