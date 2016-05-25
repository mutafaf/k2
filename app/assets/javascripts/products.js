
function getProducts(element){
  var category_permalink = $(element).attr("id")
   $.ajax({
     url: '/products',
     data: {"category_permalink" : category_permalink},
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
  var permalink = color_value = $(element).attr("id");
   $.ajax({
     url: '/product/'+permalink,
     data: {color: true},
     method: 'get',
     success: function(data) {
       $("#product_display").html(data);
     }
   });
}

$(function() {
  $( "#slider-range" ).slider({
    range: true,
    min: 100,
    max: 5000,
    step: 50,
    values: [ 100, 2000 ],
    slide: function( event, ui ) {
      $( "#amount" ).val( "Rs " + ui.values[ 0 ] + " - Rs " + ui.values[ 1 ] );
    }
  });
  $( "#amount" ).val( "Rs " + $( "#slider-range" ).slider( "values", 0 ) +
    " - Rs" + $( "#slider-range" ).slider( "values", 1 ) );
});

function filterProducts() {
  var min_price = $( "#slider-range" ).slider( "values", 0 );
  var max_price = $( "#slider-range" ).slider( "values", 1 );
  var price = $( "#slider-range-min" ).slider( "value" );
   $.ajax({
     url: '/products',
     data: {"min_price" : min_price, "max_price": max_price},
     method: 'GET',
     success: function(data) {
       // alert("success!")
     }
   });
}
