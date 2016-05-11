
function getProducts(element){
  categoryId = $(element).attr("id")
   $.ajax({
     url: '/products',
     data: {"category_id" : categoryId},
     method: 'GET',
     success: function(data) {
       // alert("success!")
     }
   });
}

function getProductDetail(element) {
 var permalink = $(element).find('input').val();
  $.ajax({
      url: '/product/'+permalink,
      method: 'GET',
      success: function (data) {
         $("#product-quickview2").html(data);
         $('#product_detail_popup').modal('show');
      }
  });
}

$('#modal-qty-plus').click(function(e) {
 var temp = $('#modal-qty').val();
   if (temp == null || temp == "") {
     $('#modal-qty').prop("value", 1);
   } else {
     $('#modal-qty').prop("value",parseInt(temp) + 1);
   }
});

$('#modal-qty-minus').click(function(e) {
 var temp = $('#modal-qty').val();
 if(parseInt(temp) > 1) {
   $('#modal-qty').prop("value",parseInt(temp) - 1);
 }
});


$(function() {
  return $('.infinite-table').infinitePages({
    loading: function() {
      return $(this).text('Loading next page...');
    },
    error: function() {
      return $(this).button('There was an error, please try again');
    }
  });
});
