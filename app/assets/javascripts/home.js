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
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    }
}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            alert("User denied the request for Geolocation.")
            setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 1000);
            break;
        case error.POSITION_UNAVAILABLE:
            alert("Location information is unavailable.")
            setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 1000);
            break;
        case error.TIMEOUT:
            alert("The request to get user location timed out.")
            setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 1000);
            break;
        case error.UNKNOWN_ERROR:
            alert("An unknown error occurred.")
            setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 1000);
            break;
    }
}

function showPosition (position) {

   var current_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    if (current_location) {
      map.panTo(current_location);
      find_nearest_stores(current_location.lat(), current_location.lng());
    }
}

function show_other_field(element){
  if ($(element).val() == "Other") {
  $('#other_institute').removeClass("hidden");
  } else {
    $('#other_institute').addClass('hidden');
  }
}
