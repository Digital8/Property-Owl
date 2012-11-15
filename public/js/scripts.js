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
	
	updateTimer = function(){
	  var diff, days, hours, minutes, seconds;
	
  	//diff = moment.utc().startOf('day').day(3).hours(2).diff(moment.utc(), 'seconds');
  	timespan = moment.utc().startOf('day').day(3).hours(2);
	
  	if (diff < 0){
  	  //diff += 604800;
  	  timespan = timespan.hours(24*7);
  	}
	
  	//days = Math.floor(diff/86400);
  	//diff -= days*86400;
	
  	//hours = Math.floor(diff/3600);
  	//diff -= hours*3600;
	
  	//minutes = Math.floor(diff/60);
  	//diff -= minutes*60;
  	//seconds = diff;
  	
  	//$("#day-timer-mins").html(minutes);
  	//$("#day-timer-hours").html(hours);
  	//$("#day-timer-days").html(days);
  	
  	$("#day-timer-mins").html(timespan.minutes());
  	$("#day-timer-hours").html(timespan.hours());
  	$("#day-timer-days").html(timespan.days());
  	
  }
  
  updateTimer();
  setInterval(updateTimer, 5000);
	
});