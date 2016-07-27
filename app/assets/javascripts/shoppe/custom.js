$(document).ready(function(){
	

			var k = $("#colorbox").val();

				if (k == "Multi") {
					$("#color-field").hide();
								
									} 
					else {
							$("#color-field").show()
						

						}
  $("#colorbox").keyup(function(){
       
			var n = $("#colorbox").val();	

				if (n == "Multi") {
							
							$("#color-field").hide();
									} 
				else {
							$("#color-field").show()
					}

    			});

   });
