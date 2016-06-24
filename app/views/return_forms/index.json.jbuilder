json.array!(@return_forms) do |return_form|
  json.extract! return_form, :id, :order_number, :serial_number, :item_number, :description, :return_quantity, :reason, :action_detail
  json.url return_form_url(return_form, format: :json)
end
