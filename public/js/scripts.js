$(window).load(function() {
	
	// scroll to top on mobile devices
	if ($(".row").width() <= 320){
    	$('html, body').animate({scrollTop:0}, 100);
    }
	
});

$(function(){
	
	// reveal deal list
	var dealsHeight = 0;
	
	$(".deal h2").on("click", function(){
		var deals = $(this).closest(".deal"),
			dealsList = $("ul", deals);
		
		if (dealsHeight <= 0){
			dealsList.hide().css("height","auto");
			dealsHeight = dealsList.height();
			dealsList.css("height","0").show();
		}
		else {
			dealsHeight = 0;
		}
		
		dealsList.animate({
            height: dealsHeight
       }, 150, function(){
           deals.toggleClass("display");
           
           if (dealsHeight > 0){
               dealsList.css("height","auto");
           }
       });
	});
	
	// more information list
	var infoHeight = 0;
	
	$(".more-info h2").on("click", function(){ 
	  console.log('sdfsdf');
		var infoitems = $(this).closest(".more-info"),
			infoList = $("ul", infoitems);
		
		if (infoHeight <= 0){
			infoList.hide().css("height","auto");
			infoHeight = infoList.height();
			infoList.css("height","0").show();
		}
		else {
			infoHeight = 0;
		}
		
		infoList.animate({
            height: infoHeight
       }, 150, function(){
           infoitems.toggleClass("display");
           
           if (infoHeight > 0){
               infoList.css("height","auto");
           }
       });
	});

});

$(function(){
	
	
	// show modal
	/*var modal = $(".modal-overlay");
	
	$(".show-modal, .close-modal").on("click", function(){
		modal.fadeToggle(150);
		
		return false;
	});*/
	
	$(".overlay .modal").on("click", function(event){
	  event.stopPropagation();
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
		loginModal.hide(50);
		registerModal.fadeToggle(150);
		return false;
	});
	
	// show login form
	var loginModal = $(".login-overlay");
	
	$(".show-login, .close-login").on("click", function(event){
		event.preventDefault();
		registerModal.hide(50);
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
    $('body').append('<div class="quick-view-modal" id="register" onclick="javascript: window.location=\'/owls/top\';" style=""><div class="modal"><a href="#" class="modal-close"></a></div></div>');
  });*/
  
  // Login
	var login = function(email, pass, callback){
	  $.ajax({
	    url: '/ajax/login',
	    type: 'post',
	    data: 'e=' + email + '&p=' + pass
	  }).done(function(d){
	    callback(d.status == 200);
	  });
	  //return false;
	}
	
	$(".login-button").on("click", function(event){
	  event.preventDefault();
	  var email = $(".login-email").val();
	  var pass = $(".login-password").val();
	  var error = $(".login-error");
	  
	  login(email, pass, function(success){
	    if (success){
	      window.location.replace("/");
	    }
	    else {
	      error.html("Login Failed, Please try again.");
	      error.stop().fadeOut(100).fadeIn(350).fadeOut(350).fadeIn(350).fadeOut(350).fadeIn(350);
	    }
	  });
	  
	  return false;
	});
	
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
  
  $('.register').click(function(){
  	var type = $(this).data('type');
  	var id = $(this).data('id');

    $.ajax({
      url: '/ajax/addRegistration',
      method: 'GET',
      data: 'id='+id+'&type='+type
    }).done(function(d){
      console.log(d);
      if(d.status == 200) alert('You have registered for this property')
  	});
  });	
});