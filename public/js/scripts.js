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
    window.location = '/recoveries';
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

  $(".cloud-thing").on("click", function(event){
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
  
  $('.details-button').on('click', function(event){
    if (!$.isAuthed) {
      var href = $(this).attr('href');
      if ((href.indexOf('research') != -1) || (href.indexOf('news') != -1)) {
        event.preventDefault();
        return $.showRegister();
      }
    }
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

$("#close-errors").on("click", function(){
  var errorList = $(this).closest("ul");
  errorList.fadeOut(150);
});

});