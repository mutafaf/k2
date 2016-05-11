// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery-1.12.3.min.js
//= require custom-js.js
//= require modernizr.js
//= require js/jquery.flexslider.js
//= require parallax.js
//= require parallax.min.js
//= require jquery-ui.js
//= require bootstrap.min.js
//= require bootstrap-hover-dropdown.min.js
//= require SmoothScroll.js
//= require jquery.dragtable.js
//= require jquery.card.js
//= require owl.carousel.min.js
//= require twitterFetcher_min.js
//= require jquery.mb.YTPlayer.min.js
//= require custom.js
//= require products.js
//= require orders.js
//= require home.js
//= require js/easyzoom.js
//= require jquery.infinite-pages


function set_toastr_options() {
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-top-right",
        "onclick": null,
        "showDuration": "1000",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }
}
// Footer image
$('.parallax-window').parallax({imageSrc: '/assets/footer-img.jpg'});
