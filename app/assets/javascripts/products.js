
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

function updateProductDisplay(element){
  var permalink = color_value = $(element).find('input').val();
   $.ajax({
     url: '/product/'+permalink,
     data: {color: true},
     method: 'get',
     success: function(data) {
       $("#product_display").html(data);
     }
   });
}
