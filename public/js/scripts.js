$(window).load(function() {
	
	// scroll to top on mobile devices
	if ($(".row").width() <= 320){
    	$('html, body').animate({scrollTop:0}, 100);
    }
	
});

$(document).ready(function(){
  	$("div.clickable").click(
	function()
	{
	    window.location = $(this).attr("url");
	    return false;
	});
	
	
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
	  //console.log('sdfsdf');
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
	
	$(".terms-checkbox").on("click", function(event){
	  event.stopPropagation();
	})
	
	$(".overlay").on("click", function(event){
	  event.preventDefault();
	  $(this).fadeToggle(150);
	  /*if($(this).hasClass('modal-overlay')){
	    if(typeof(modalCallback)=='function'){
	      modalCallback();
	      modalCallback = null;
	    }
	  }*/
	  return false;
	});
	
	// show register form
	var registerModal = $(".register-overlay");
	
	$(".show-register, .close-register").on("click", function(event){
		event.preventDefault();
		loginModal.hide();
		registerModal.fadeToggle(150);
		return false;
	});
	
	// show secure deal form
	var secureDealModal = $(".secure-deal-overlay");
	
	$(".show-secure-deal, .close-secure-deal").on("click", function(event){
		event.preventDefault();
		secureDealModal.fadeToggle(150);
		return false;
	});
	
	// show refer friend form
	var referFriendModal = $(".refer-friend-overlay");
	
	$(".show-refer-friend, .close-refer-friend").on("click", function(event){
		event.preventDefault();
		referFriendModal.fadeToggle(150);
		return false;
	});
	
	// show login form
	var loginModal = $(".login-overlay");
	
	$(".show-login, .close-login").on("click", function(event){
		event.preventDefault();
		registerModal.hide();
		loginModal.fadeToggle(150);
		return false;
	});
	
	// show modal
	var modal = $(".modal-overlay");
	//var modalCallback = null;
	$(".show-modal, .close-modal").on("click", function(event){
	  event.preventDefault();
		modal.fadeToggle(150);
		/*if(typeof(modalCallback)=="function"){
		  modalCallback();
		  modalCallback = null;
		}*/
		return false;
	});

  // find deals form (mobile breakpoint)
  $(".find-deals h2").on("click", function(){
    var findDeals = $(this).closest(".find-deals");
    findDeals.toggleClass("display");
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
  
  // Login
	var login = function(email, pass, callback){
	  $.ajax({
	    url: '/ajax/login',
	    type: 'post',
	    data: 'e=' + email + '&p=' + pass + '&r=' + $("#remember").attr('checked')
	  }).done(function(d){
	    callback(d.status == 200);
	  });
	  //return false;
	}
	
	// Sign up
	$(".register-button").on("click", function(event){
	  var firstName = $(".register-first-name").val();
	  var lastName = $(".register-last-name").val();
	  var email = $(".register-email").val();
	  var postcode = $(".register-postcode").val();
	  var password = $(".register-password").val();
	  var password2 = $(".register-password2").val();
	  var terms = $("#terms").attr("checked");
	  
	  $.ajax({
	    url: '/ajax/register',
	    type: 'post',
	    data: 'e=' + email + '&p=' + password + '&p2=' + password2 + '&f=' + firstName + '&l=' + lastName + '&c=' + postcode + '&t=' + terms
	  }).done(function(d){
	    if (d.status == 200) {
	      //showPayment();
	      //success();
	      window.location.replace('/');
	    }
	    else {
	      //console.log('fix this plz');
	      console.log(d);
	      var errors = Object.keys(d.errors);
  	    
  	    $("#generic-modal, #generic-modal .modal.main").removeClass('success').addClass('error');
	      $('#generic-modal-title').html('Please fix the following');
	      $('#generic-modal-content').html('<br /><ul>');
	      for(i=0; i<errors.length;i++)
	      {
	         $('#generic-modal-content').append('<li><b>' + d.errors[errors[i]].msg + '</b></li>');
	      }
        $('#generic-modal-content').append('</ul>');
        
	      $('#generic-modal').fadeToggle(150);
	      //modalCallback = function(){console.log('penis')};
	    }
	  });
	  return false;
	});
	
	$(".register-first-name, .register-last-name, .register-email, .register-postcode, .register-password, .register-password2").on("keypress", function(event){
	  if(event.keyCode == 13){
	    $(".register-button").click();
	  }
	});
	
	// Secure Deal
	$(".secure-deal-button").on("click", function(event){
	  var firstName = $(".secure-deal-first-name").val();
	  var lastName = $(".secure-deal-last-name").val();
	  var email = $(".secure-deal-email").val();
	  var mobile = $(".secure-deal-phone").val();
	  var comment = $(".secure-deal-comment").val();
	  
	  $.ajax({
	    url: '/ajax/securedeal',
	    type: 'post',
	    data: 'e=' + email + '&m=' + mobile + '&f=' + firstName + '&l=' + lastName + '&c=' + comment
	  }).done(function(d){
	    if (d.status == 200) {
	      //showPayment();
	      //success();
	      //window.location.replace('/');
	      secureDealModal.fadeToggle(150);
	      $("#generic-modal, #generic-modal .modal.main").removeClass('error').addClass('success')
	      $('#generic-modal-title').html('Thanks for registering!');
	      $('#generic-modal-content').html('<br /><br /><center>You should recieve an email shortly</center>');
	      $('#generic-modal').fadeToggle(150);
	    }
	    else {
	      var errors = Object.keys(d.errors);
  	    
  	    $("#generic-modal, #generic-modal .modal.main").removeClass('success').addClass('error')
	      $('#generic-modal-title').html('Please fix the following');
	      $('#generic-modal-content').html('<br /><ul>');
	      for(i=0; i<errors.length;i++)
	      {
	         $('#generic-modal-content').append('<li><b>' + d.errors[errors[i]].msg + '</b></li>');
	      }
        $('#generic-modal-content').append('</ul>');
        
	      $('#generic-modal').fadeToggle(150);
	      //modalCallback = function(){console.log('penis')};
	    }
	  });
	  return false;
	});
	
	$(".secure-deal-first-name, .secure-deal-last-name, .secure-deal-email, .secure-deal-phone, .secure-deal-comment").on("keypress", function(event){
	  if(event.keyCode == 13){
	    $(".secure-deal-button").click();
	  }
	});
	
	
	// Refer Friend
	$(".refer-friend-button").on("click", function(event){
	  var firstName = $(".refer-friend-first-name").val();
	  var lastName = $(".refer-friend-last-name").val();
	  var email = $(".refer-friend-email").val();
	  var mobile = $(".refer-friend-phone").val();
	  var comment = $(".refer-friend-comment").val();
	  
	  $.ajax({
	    url: '/ajax/referfriend',
	    type: 'post',
	    data: 'e=' + email + '&m=' + mobile + '&f=' + firstName + '&l=' + lastName + '&c=' + comment
	  }).done(function(d){
	    if (d.status == 200) {
	      //showPayment();
	      //success();
	      //window.location.replace('/');
	      referFriendModal.fadeToggle(150);
	      $("#generic-modal, #generic-modal .modal.main").removeClass('error').addClass('success')
	      $('#generic-modal-title').html('Thanks for referring a friend!');
	      $('#generic-modal-content').html('<br /><br /><center>Your friend should recieve an email shortly</center>');
	      $('#generic-modal').fadeToggle(150);
	    }
	    else {
	      var errors = Object.keys(d.errors);
  	    
  	    $("#generic-modal, #generic-modal .modal.main").removeClass('success').addClass('error')
	      $('#generic-modal-title').html('Please fix the following');
	      $('#generic-modal-content').html('<br /><ul>');
	      for(i=0; i<errors.length;i++)
	      {
	         $('#generic-modal-content').append('<li><b>' + d.errors[errors[i]].msg + '</b></li>');
	      }
        $('#generic-modal-content').append('</ul>');
        
	      $('#generic-modal').fadeToggle(150);
	      //modalCallback = function(){console.log('penis')};
	    }
	  });
	  return false;
	});
	
	$(".refer-friend-first-name, .refer-friend-last-name, .refer-friend-email, .refer-friend-phone, .refer-friend-comment").on("keypress", function(event){
	  if(event.keyCode == 13){
	    $(".refer-friend-button").click();
	  }
	});
	
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
	
	$(".login-email, .login-password").on("keypress", function(event){
	  if(event.keyCode == 13){
	    $(".login-button").click();
	  }
	});
  
  $('.register').click(function(){
  	var type = $(this).data('type');
  	var id = $(this).data('id');

    $.ajax({
      url: '/ajax/addRegistration',
      method: 'GET',
      data: 'id='+id+'&type='+type
    }).done(function(d){
      //console.log(d);
      //if(d.status == 200) alert('You have registered for this property')
  	});
  });	
});