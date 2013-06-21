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
  
  $('.forgot-password').click(function(){
    window.location = '/account/recover';
  });

  $(".deal h2").on("click", function(){

    if (!$.isAuthed) return $.showRegister();

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
    if (!$.isAuthed) return $.showRegister();
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
  
  $('.details-button').on('click', function(event){
    if (!$.isAuthed) {
      var href = $(this).attr('href');
      if ((href.indexOf('research') != -1) || (href.indexOf('news') != -1)) {
        event.preventDefault();
        return $.showRegister();
      }
    }
  });
  
  // show login form
  var loginModal = $(".login-overlay");
  
  $(".show-login, .close-login").on("click", function(event){
    event.preventDefault();
    registerModal.hide();
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) )
    {
      window.location = '/login';
    }
    else
    {
      loginModal.fadeToggle(150);
    } 
    return false;
  });
  
  // // show modal
  // var modal = $(".modal-overlay");
  // //var modalCallback = null;
  // $(".show-modal, .close-modal").on("click", function(event){
  //   event.preventDefault();
  //   modal.fadeToggle(150);
  //   /*if(typeof(modalCallback)=="function"){
  //     modalCallback();
  //     modalCallback = null;
  //   }*/
  //   return false;
  // });

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
        var errors = Object.keys(d.errors);
        
        $("#generic-modal, #generic-modal .modal.main").removeClass('success');
        $('#generic-modal-title').html('Please fix the following');
        $('#generic-modal-content').html('<br /><ul>');
        for(i=0; i<errors.length;i++)
        {
           $('#generic-modal-content').append('<li><b>' + d.errors[errors[i]].msg + '</b></li>');
        }
        $('#generic-modal-content').append('</ul>');
        
        $('#generic-modal').fadeToggle(150);
      }
    });
    return false;
  });
  
  $(".register-first-name, .register-last-name, .register-email, .register-postcode, .register-password, .register-password2").on("keypress", function(event){
    if(event.keyCode == 13){
      $(".register-button").click();
    }
  });

$("#close-errors").on("click", function(){
  var errorList = $(this).closest("ul");
  errorList.fadeOut(150);
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
  
  $('.register').click(function(e){
    e.preventDefault();
    doInterest($(this));
  });

  $('.registration').change(function(){
    var id = $(this).data('id');
    var val = $(this).val();
    $.ajax({
      url: '/ajax/registerStatus',
      type: 'post',
      data: 'id='+id+'&val='+val
    }).done(function(d){
      if (d.status == 200)
      {
        alert("Status Updated!");
      }
      else
      {
        alert('An error occured changing the status');
      }
    });
  });
});