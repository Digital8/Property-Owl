$(window).load(function() {
	
	// scroll to top on mobile devices
	if ($(".row").width() <= 320){
    	$('html, body').animate({scrollTop:0}, 100);
    }
	
});

$(function(){
	
	
	// show modal
	/*var modal = $(".modal-overlay");
	
	$(".show-modal, .close-modal").on("click", function(){
		modal.fadeToggle(150);
		
		return false;
	});*/
	
	$(".overlay .modal").on("click", function(event){
	  event.stopPropogation();
	  event.preventDefault();
	  return false;
	});
	
	$(".overlay").on("click", function(event){
	  event.preventDefault();
	  $(this).fadeToggle(150);
	  return false;
	});
	
	// show register form
	var registerModal = $(".register-overlay");
	
	$(".show-register, .close-register").on("click", function(event){
		event.preventDefault();
		registerModal.fadeToggle(150);
		return false;
	});
	
	// show login form
	var loginModal = $(".login-overlay");
	
	$(".show-login, .close-login").on("click", function(event){
		event.preventDefault();
		loginModal.fadeToggle(150);
		return false;
	});
	
	// show modal
	var modal = $(".modal-overlay");
	
	$(".show-modal, .close-modal").on("click", function(event){
	  event.preventDefault();
		modal.fadeToggle(150);
		return false;
	});

  // find deals form (mobile breakpoint)
  $(".find-deals h2").on("click", function(){
    var findDeals = $(this).closest(".find-deals");
    findDeals.toggleClass("display");
  });

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
	  var that = this;
	  $.ajax({
	    url: '/ajax/removedeal',
	    type: 'post',
	    data: 'id=' + $(this).data('property')
	  }).done(function(d){
	    if (d.status == true) {
	      $("#property-" + $(that).data('property').toString()).remove();
	    }
	    else {
	      alert('uh oh! spaghettio!');
	    }
	  });
	  return false;
	});
	
  /*$(".secure-button").on("click", function(){
    $('body').append('<div class="quick-view-modal" id="register" onclick="javascript: window.location=\'/best-deal\';" style=""><div class="modal"><a href="#" class="modal-close"></a></div></div>');
  });*/
	
	updateTimer = function(){
	  var timeNow = moment.utc();
	  var newDealTime = moment.utc().startOf('day').day(3).hours(2);
	  var diff = newDealTime.diff(timeNow, 'seconds');
	
  	if (diff < 0) {
  	  newDealTime = newDealTime.hours(24*7);
	  }
  	
  	$("#day-timer-mins").html(newDealTime.diff(timeNow, 'minutes') % 60);
  	$("#day-timer-hours").html(newDealTime.diff(timeNow, 'hours') % 24);
  	$("#day-timer-days").html(newDealTime.diff(timeNow, 'days'));  	
  }
  
  updateTimer();
  setInterval(updateTimer, 5000);
	
});