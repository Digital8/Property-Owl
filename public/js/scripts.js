$(window).load(function() {
	
	// scroll to top on mobile devices
	if ($(".row").width() <= 320){
    	$('html, body').animate({scrollTop:0}, 100);
    }
	
});

$(function(){

  $(".savebuttons").on("click", function(){
	  $.ajax({
	    url: '/ajax/savedeal',
	    type: 'post',
	    data: 'id=' + $(this).data('property')
	  }).done(function(d){
	    if (d.status == true) {
	      alert('Property Saved!');
	    }
	    else {
	      alert('uh oh! spaghettio!');
	    }
	  });
	  return false;
	});
	
	$(".removebuttons").on("click", function(){
	  $.ajax({
	    url: '/ajax/removedeal',
	    type: 'post',
	    data: 'id=' + $(this).data('property')
	  }).done(function(d){
	    if (d.status == true) {
	      alert('Property Removed!');
	      console.log($(this).data('property').toString());
	      $("#property-" + $(this).data('property').toString()).remove();
	    }
	    else {
	      alert('uh oh! spaghettio!');
	    }
	  });
	  return false;
	});
    	
});