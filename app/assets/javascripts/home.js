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
  if (!navigator.geolocation){
     toastr.error("Geolocation is not supported by your browser.")
     return;
   }

  navigator.geolocation.getCurrentPosition(success, error);
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

function error(error) {
  setTimeout(function(){ placeMarker(myCenter, "Borjan"); }, 500);
  // toastr.error("Unable to retrieve your location")
 
    console.log('Error occurred. Error code: ' + error.code);
      if (error.code == 0){toastr.error("unknown error has occured");}
      else if (error.code == 1) {toastr.error("permission not granted");}
      else if (error.code == 2) {toastr.error("position unavailable (error response from location provider)");}
      else if (error.code == 3) {toastr.error("timed out");}
  
};

function show_other_field(element){
  if ($(element).val() == "Other") {
  $('#other_institute').removeClass("hidden");
  } else {
    $('#other_institute').addClass('hidden');
  }
}



// function getLocation() {
 
//   navigator.geolocation.getCurrentPosition(success, error);

// var startPos;
//   var geoOptions = {
//     enableHighAccuracy: true
//   }

//   var geoSuccess = function(position) {
//     startPos = position;
//     document.getElementById('startLat').innerHTML = startPos.coords.latitude;
//     document.getElementById('startLon').innerHTML = startPos.coords.longitude;
//   };
  // var geoError = function(error) {
  //   console.log('Error occurred. Error code: ' + error.code);
  //     if (error.code == 0){toastr.error("unknown error has occured");}
  //     else if (error.code == 1) {toastr.error("permission not granted");}
  //     else if (error.code == 2) {toastr.error("position unavailable (error response from location provider)");}
  //     else if (error.code == 3) {toastr.error("timed out");}
  // };

//   navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
// ?key=AIzaSyD2R0Pkt_QnbBv05OiorFFe4N46kt9KrLA

// }
