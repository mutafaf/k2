
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
