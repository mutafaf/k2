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
   itemWidth: 250,
   itemMargin: 45,
  
   start: function(slider){
     $('body').removeClass('loading');
   }
 });
});