
function updateOrderItem(element){
   var removeRow;
   if ($(element).hasClass('removerow')) {
      removeRow = true
   };
   var OrderItemRow = $(element).closest(".order-item");
   var OrderItemSize = OrderItemRow.find("#size").val();
   var OrderItemColorId = OrderItemRow.find("#color").val();
   var OrderItemQuantity = OrderItemRow.find("#quantity").val();
   var OrderItem = OrderItemRow.find("#item_id").val();

   $.ajax({
     url: '/update_order_items',
     data: {"item_id" : OrderItem,
            "item_size": OrderItemSize, 
            "item_color_id": OrderItemColorId, 
            "item_quantity": OrderItemQuantity,
            "remove_row": removeRow},
     method: 'post',
     format: 'js',
     success: function(data) {
       // $("#cart_page").html(data);
     }
   });
}
