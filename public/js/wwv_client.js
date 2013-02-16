/**
 * WWVClient v1: Web Walk Video embed script
 *
 * WWVClient is (c) 2010 :
 * 
 *
 */
 	/**
	 * ...
	 * @author Nidin.P.Vinayak
	 */
	 
var replay_width;
var replay_height;
var replay_x;
var replay_y;
var replay_align;

var player_width;
var player_height;
var player_x;
var player_y;
var player_align;

var play_once;

var currentWidth;
var currentHeight;

var currentState;
var cID;
/** Initialize wwv Client **/
function attachWebWalkVideo(client_id){
	//alert(window.location.protocol);
	if (window.location.protocol == 'https:') {
	
		baseURL = "https://webwalk.com.au";  
	}
	else
	{
		baseURL = "http://webwalk.com.au";  
	}

    
	wwv_client_id = client_id;
	connectBridge();
	cID = client_id;
}
/** 
 * Connect ajax bridge 
 http://webwalkvideo.com.au
 **/
function connectBridge(){
	//alert('bridge started');
  
	var bridge_div = document.createElement('div');
		bridge_div.setAttribute('id','swf_bridge');
		bridge_div.style.width 	  = "1px";
		bridge_div.style.height   = "1px";
		bridge_div.style.position = "absolute";
	
  document.body.appendChild(bridge_div);
  
	var bdg = new SWFObject(baseURL+'/flash/bridge.swf?gateway='+baseURL+'/client_data.aspx?cid='+wwv_client_id, "Bridge","1", "1", "9");
		bdg.addParam("wmode", "transparent");
		bdg.addParam("AllowScriptAccess", "always");
		bdg.write("swf_bridge");
}
/** 
 * Load xml string in to DOM element 
 **/
function loadXMLString(txt)
{
	//alert('loadXMLString');
	if (window.DOMParser){
	  parser=new DOMParser();
	  _xmlDoc=parser.parseFromString(txt,"text/xml");
	}
	else{ 
	// Internet Explorer
	  _xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
	  _xmlDoc.async="false";
	  _xmlDoc.loadXML(txt);
	}
	return _xmlDoc;
}
/** 
 * Load client data 
 **/
function loadRemoteData(xmlString){
	//xmlDoc	=	loadXMLDoc('client_data.xml');
	xmlDoc		=	loadXMLString(xmlString);
	xmlObj		=	xmlDoc.documentElement;
	
	play_once 	=	"true";//xmlObj.getElementsByTagName("playonce")[0].childNodes[0].nodeValue;
	
	replay_width 	=	xmlObj.getElementsByTagName("replay_window")[0].getAttribute("width");
	replay_height	=	xmlObj.getElementsByTagName("replay_window")[0].getAttribute("height");	
	replay_x		=	"20px";//xmlObj.getElementsByTagName("replay_window")[0].getAttribute("x");	
	replay_y		=	"50px";//xmlObj.getElementsByTagName("replay_window")[0].getAttribute("y");	
	replay_align	=	xmlObj.getElementsByTagName("replay_window")[0].getAttribute("align");
	
	player_width 	=	xmlObj.getElementsByTagName("player_window")[0].getAttribute("width");
	player_height 	=	xmlObj.getElementsByTagName("player_window")[0].getAttribute("height");
	player_x 		=	xmlObj.getElementsByTagName("player_window")[0].getAttribute("x");
	player_y 		=	"300px";//xmlObj.getElementsByTagName("player_window")[0].getAttribute("y");
	player_align 	=	xmlObj.getElementsByTagName("player_window")[0].getAttribute("align");	
	
	
	addVideo();
};
/** 
 * Create Video element
 **/
function addVideo(){

	getWindowSize();
  
	/** Flash client container **/
	var wwv_div = document.createElement('div');
	wwv_div.setAttribute('id','webwalkvideo_div');
	wwv_div.style.zIndex	= 2147483647;
	wwv_div.style.width 	= "0";
	wwv_div.style.height 	= "0";
	wwv_div.style.left 	 	= "0";
	wwv_div.style.top 	 	= "0";
	wwv_div.style.position 	= "absolute";
	// wwv_div.style.background = "#CCCCCC";
	// wwv_div.style.border = "1px solid #000000";

	document.body.appendChild(wwv_div);
	
		isSameUser = checkCookie();
		if(isSameUser==true && play_once=='true'){
			StopVideo(wwv_client_id);
		}else{
			StartVideo(wwv_client_id);
		}
};
/** 
 * callback method for flash and
 * add flv player element
 **/
function StartVideo(cid){
	currentState = "player";
	//alert(cid);
	var vd = new SWFObject(baseURL+'/flash/wwv_client.swf?type=player&gateway='+baseURL+'/config.asp&cid='+cid, "FLVplayer","100%", "100%", "9");
	    vd.addParam("wmode", "transparent");
	    vd.addParam("AllowScriptAccess", "always");
	    vd.write("webwalkvideo_div");
	
	alignElements();
};

/** 
 * callback method for flash and
 * add play video element
 **/
function StopVideo(cid){
	currentState = "replay";
	//alert(cid);
	var vd = new SWFObject(baseURL+'/flash/wwv_client.swf?type=replay&gateway='+baseURL+'/config.asp&cid='+cid, "replay", "100%", "100%", "9");
		vd.addParam("wmode", "transparent");
		vd.addParam("AllowScriptAccess", "always");
		vd.write("webwalkvideo_div");
		
	alignElements();
};
/**
 * Window resize 
 */
 window.onresize = alignElements;
 
 function alignElements(){
 
	getWindowSize();

	var element = document.getElementById ('webwalkvideo_div');
		element.style.marginLeft  	= "0";
		element.style.marginTop  	= "0";
		element.left 				= "100";
		element.right 				= "0";
		element.top  				= "0";
		element.bottom 				= "0";
		
	var sizeObj ={};
	
	if(currentState == "replay"){
	
		element.style.display 	=	"block";
		element.style.position 	=	"fixed";
		element.style.width 	=	replay_width;
		element.style.height 	=	replay_height;
		
		sizeObj._align 	= replay_align;
		sizeObj._x		= replay_x;
		sizeObj._y		= replay_y;
		sizeObj._width	= replay_width;
		sizeObj._height	= replay_height;
		
	}else if(currentState == "player"){
	
		element.style.position 	=	"absolute";
		element.style.width 	=	player_width;
		element.style.height 	=	player_height;
		
		sizeObj._align 	= player_align;
		sizeObj._x		= player_x;
		sizeObj._y		= player_y;
		sizeObj._width	= player_width;
		sizeObj._height	= player_height;
	}

	//sizeObj._align = 'none';
	switch(sizeObj._align){
			case "none":
			case "top-left":
			{
				element.style.left 		 =	sizeObj._x;
				element.style.top 		 =	sizeObj._y;
				break;
			}
			case "top-right":
			{
				element.style.marginLeft  = (currentWidth - parseInt(sizeObj._width.split("px")[0]) - parseInt(sizeObj._x.split("px")[0])) + "px";
				element.style.top 		  =	sizeObj._y;
				break;
			}
			case "bottom-left":
			{
				element.style.left 		=	sizeObj._x;
				element.style.marginTop  = (currentHeight - parseInt(sizeObj._height.split("px")[0]) - parseInt(sizeObj._y.split("px")[0])) + "px";
				break;
			}
			case "bottom-right":
			{
				element.style.marginLeft  = (currentWidth - parseInt(sizeObj._width.split("px")[0]) - parseInt(sizeObj._x.split("px")[0])) + "px";
				element.style.marginTop  = (currentHeight - parseInt(sizeObj._height.split("px")[0]) - parseInt(sizeObj._y.split("px")[0])) + "px";
				break;
			}
			case "center":
			{

				if(sizeObj._x.split("px")[0] == 0){
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2)) + "px";
				}else{
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2) + parseInt(sizeObj._x.split("px")[0])) + "px";
				}
				if(sizeObj._y.split("px")[0] == 0){
					element.style.marginTop  = (currentHeight/2 - parseInt(sizeObj._height.split("px")[0] / 2)) + "px";
				}else{
					element.style.marginTop  = (currentHeight/2 - parseInt(sizeObj._height.split("px")[0] / 2) + parseInt(sizeObj._y.split("px")[0])) + "px";
				}
				break;
			}
			case "center-center":
			{

				element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2) + parseInt(sizeObj._x.split("px")[0])) + "px";
				element.style.marginTop  = (currentHeight/2 - parseInt(sizeObj._height.split("px")[0] / 2) + parseInt(sizeObj._y.split("px")[0])) + "px";
				
				break;
			}			
			case "center-top":
			{

				if(sizeObj._x.split("px")[0] == 0){
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2)) + "px";
				}else{
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2) + parseInt(sizeObj._x.split("px")[0])) + "px";
				}
				
				element.style.marginTop  = sizeObj._y;
				
				break;
			}			
			case "center-bottom":
			{

				if(sizeObj._x.split("px")[0] == 0){
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2)) + "px";
				}else{
					element.style.marginLeft  = (currentWidth/2 - parseInt(sizeObj._width.split("px")[0] / 2) + parseInt(sizeObj._x.split("px")[0])) + "px";
				}
				if(sizeObj._y.split("px")[0] == 0){
					element.style.marginTop  = (currentHeight - parseInt(sizeObj._height.split("px")[0])) + "px";
				}else{
					element.style.marginTop  = (currentHeight - parseInt(sizeObj._height.split("px")[0]) - parseInt(sizeObj._y.split("px")[0])) + "px";
				}
				break;
			}
		}
	
 }
/** 
 * get current width and height of site
 **/
 function getWindowSize(){
 
	if (self.innerHeight) // all except Explorer
	{
		currentWidth = self.innerWidth - 20;
		currentHeight = self.innerHeight - 5;
	}
	else if (document.documentElement && document.documentElement.clientHeight)// Explorer 6 Strict Mode
	{
		currentWidth = document.documentElement.clientWidth - 5;
		currentHeight = document.documentElement.clientHeight - 20;
	}
	else if (document.body) // other Explorers
	{
		currentWidth = document.body.clientWidth;
		currentHeight = document.body.clientHeight;
	}
 }
/** 
 * check cookies
 **/
function setCookie(c_name,value,expiredays){
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value)+
	((expiredays==null) ? "" : ";expires="+exdate.toUTCString());
}
function getCookie(c_name){
	if (document.cookie.length>0)
	  {
	  c_start=document.cookie.indexOf(c_name + "=");
	  if (c_start!=-1)
		{
		c_start=c_start + c_name.length+1;
		c_end=document.cookie.indexOf(";",c_start);
		if (c_end==-1) c_end=document.cookie.length;
		return unescape(document.cookie.substring(c_start,c_end));
		}
	  }
	return "";
}
function checkCookie(){
    userid = getCookie(cID + 'userid');
	if (userid!=null && userid!="")
	  {
	  //alert('Welcome again!');
	  return true;
	  }
	else
	  {
		//alert('New user');
	      setCookie(cID + 'userid', 'wwv_user', 10);
		return false;
	  }
}