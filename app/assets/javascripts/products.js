
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
  $( "#slider-range-min" ).slider({
    range: "min",
    value: 500,
    step: 50,
    min: 100,
    max: 7000,
    slide: function( event, ui ) {
      $( "#amount" ).val( "Rs " + ui.value );
    }
  });
  $( "#amount" ).val( "Rs " + $( "#slider-range-min" ).slider( "value" ) );
});


function filterProducts() {
  var price = $( "#slider-range-min" ).slider( "value" );
   $.ajax({
     url: '/products',
     data: {"price" : price},
     method: 'GET',
     success: function(data) {
       // alert("success!")
     }
   });
}
