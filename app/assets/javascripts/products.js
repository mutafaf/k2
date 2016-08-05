
function getProducts(element){
  // if (window.location.search.indexOf('category_permalink') > -1) {
  //   // Remove the params in URL to cancel the effect of Double calls due to using background image
  //   window.history.pushState("object or string", "Title", "/products");
  //      // alert('category_permalink present');
  // }

  var category_permalink = $(element).attr("id");
   $.ajax({
     cache: false,
     url: '/products',
     data: {"category_permalink" : category_permalink},
     method: 'GET',
     success: function(data) {

      window.history.pushState("object","Title","/products?category_permalink="+category_permalink+"&date="+new Date());
      // window.location.reload(true) 
       // alert("success!")
     }
   });
}
$(document).ready(function(){
    window.localStorage.removeItem("selectedSize");
    // $.ajaxSetup({ cache: false });
});
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

// $(function() {
//   return $('.infinite-table').infinitePages({
//     loading: function() {
//       return $(this).text('Loading next page...');
//     },
//     error: function() {
//       return $(this).button('There was an error, please try again');
//     }
//   });
// });

function updateProductDisplay(element){
  var permalink = color_value = $(element).attr("id");
   $.ajax({
     url: '/product/'+permalink,
     data: {color: true},
     method: 'get',
     success: function(data) {
       $("#product_display").html(data);
       setAlreadySeletedSize();

     }
   });
}

function setAlreadySeletedSize(){
  var selectedSize = localStorage.getItem("selectedSize");
  if (selectedSize) {
   var currentProductSize = $("#size_block").find(".size-list:contains("+selectedSize+")")
     // Set the already seleted size to current Variant size if available
     if (currentProductSize.length > 0) {
       $(".size-list").css("border", "solid 1px #ddd");
       currentProductSize.css("border", "solid 3px #ddd");
      $("#size").val(selectedSize);
     } else if(document.getElementById("size_block")) {
       toastr.error("Size: "+ selectedSize +" is not available for this Product.");
     }
  };
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
    " - Rs " + $( "#slider-range" ).slider( "values", 1 ) );
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

/*------------------------------
  PRODUCT SIZE
------------------------------*/

function selectSize(element){
  $("#size").val($(element).text());
  $(".size-list").css("border", "solid 1px #ddd");
  $(element).css("border", "solid 3px #ddd");
  localStorage.setItem("selectedSize", $(element).text());


}
