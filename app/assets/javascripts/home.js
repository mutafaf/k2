$(".wrapper").click(function(){
     $(this).next(".hidden").addClass("show");
     $(".wrapper").addClass("blurry");
     $("body").css("overflow","hidden");
 }); 

 $(".close").click(function(){
     $(".hidden").removeClass("show");
     $(".wrapper").removeClass("blurry");
     $("body").css("overflow","auto");
 });

$(window).load(function(){
 $('.flexslider').flexslider({
   animation: "slide",
   animationLoop: false,
   itemWidth: 248,
   itemMargin: 21,
  
   start: function(slider){
     $('body').removeClass('loading');
   }
 });
});

function placeMarker(location, address) {
  marker = new google.maps.Marker({
    position: location,
    title: 'Borjan',
    map: map,
  });
  infowindow = new google.maps.InfoWindow({
    // content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
    content: address

  });
  infowindow.open(map,marker);
}

function find_nearest_stores(lat, lng){
  $.ajax({
    url: '/find_nearest_stores',
    data: {"lat" : lat, "lng" : lng },
    method: 'get',
    format: 'js',
    success: function(data) {
      // alert("success")
    }
  });
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(success, error);
    }
}

function success(position) {
  var latitude  = position.coords.latitude;
  var longitude = position.coords.longitude;

   current_location = new google.maps.LatLng(latitude, longitude);
   if (current_location) {
    find_nearest_stores(current_location.lat(), current_location.lng());
    map.panTo(current_location);
     
   }
};

function error() {
  setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 500);
  toastr.error("Unable to retrieve your location")
};

function show_other_field(element){
  if ($(element).val() == "Other") {
  $('#other_institute').removeClass("hidden");
  } else {
    $('#other_institute').addClass('hidden');
  }
}
