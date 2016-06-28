module ApplicationHelper

  def show_delivery_charges(order)
    if order.delivery_charges > 0
      return number_to_currency order.delivery_charges
    else
      return "Free"
    end
  end

end
