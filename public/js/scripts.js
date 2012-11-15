$(window).load(function() {
	
	// scroll to top on mobile devices
	if ($(".row").width() <= 320){
    	$('html, body').animate({scrollTop:0}, 100);
    }
	
});

$(function(){
  
  //we need to dynamically calculate the property deals id
  $("#savedeal").on("click", function(){
	  $.ajax({
	    url: '/ajax/savedeal',
	    type: 'post',
	    data: 'id=' + $("#deal_id").val()
	  }).done(function(d){
	    if (d.status == true) {
	      alert('ok sweet!');
	    }
	    else {
	      alert('uh oh! spaghettio!');
	    }
	  });
	  return false;
	});
    	
});