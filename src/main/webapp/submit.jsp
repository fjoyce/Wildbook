
<%@ page contentType="text/html; charset=utf-8"
		import="java.util.GregorianCalendar,
                 org.ecocean.servlet.ServletUtilities,
                 org.ecocean.*,
                 java.util.Properties,
                 java.util.List,
                 java.util.Locale" %>


<!-- Add reCAPTCHA -->


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="tools/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
	
<link type='text/css' rel='stylesheet' href='javascript/timepicker/jquery-ui-timepicker-addon.css' />


<jsp:include page="header.jsp" flush="true"/>

<!-- add recaptcha -->
<script src="https://www.google.com/recaptcha/api.js?render=explicit&onload=onloadCallback"></script>

<%
boolean isIE = request.getHeader("user-agent").contains("MSIE ");
String context="context0";
context=ServletUtilities.getContext(request);

String mapKey = CommonConfiguration.getGoogleMapsKey(context);

  GregorianCalendar cal = new GregorianCalendar();
  int nowYear = cal.get(1);
//setup our Properties object to hold all properties
  Properties props = new Properties();
  //String langCode = "en";
  String langCode=ServletUtilities.getLanguageCode(request);
    //set up the file input stream
    //props.load(getClass().getResourceAsStream("/bundles/" + langCode + "/submit.properties"));
    props = ShepherdProperties.getProperties("submit.properties", langCode, context);

    Properties recaptchaProps=ShepherdProperties.getProperties("recaptcha.properties", "", context);

    Properties socialProps = ShepherdProperties.getProperties("socialAuth.properties", "", context);

    long maxSizeMB = CommonConfiguration.getMaxMediaSizeInMegabytes(context);
    long maxSizeBytes = maxSizeMB * 1048576;
%>

<style type="text/css">
    .full_screen_map {
    position: absolute !important;
    top: 0px !important;
    left: 0px !important;
    z-index: 1 !imporant;
    width: 100% !important;
    height: 100% !important;
    margin-top: 0px !important;
    margin-bottom: 8px !important;


 .ui-timepicker-div .ui-widget-header { margin-bottom: 8px; }
.ui-timepicker-div dl { text-align: left; }
.ui-timepicker-div dl dt { float: left; clear:left; padding: 0 0 0 5px; }
.ui-timepicker-div dl dd { margin: 0 10px 10px 40%; }
.ui-timepicker-div td { font-size: 90%; }
.ui-tpicker-grid-label { background: none; border: none; margin: 0; padding: 0; }
.ui-timepicker-div .ui_tpicker_unit_hide{ display: none; }

.ui-timepicker-rtl{ direction: rtl; }
.ui-timepicker-rtl dl { text-align: right; padding: 0 5px 0 0; }
.ui-timepicker-rtl dl dt{ float: right; clear: right; }
.ui-timepicker-rtl dl dd { margin: 0 40% 10px 10px; }

/* Shortened version style */
.ui-timepicker-div.ui-timepicker-oneLine { padding-right: 2px; }
.ui-timepicker-div.ui-timepicker-oneLine .ui_tpicker_time,
.ui-timepicker-div.ui-timepicker-oneLine dt { display: none; }
.ui-timepicker-div.ui-timepicker-oneLine .ui_tpicker_time_label { display: block; padding-top: 2px; }
.ui-timepicker-div.ui-timepicker-oneLine dl { text-align: right; }
.ui-timepicker-div.ui-timepicker-oneLine dl dd,
.ui-timepicker-div.ui-timepicker-oneLine dl dd > div { display:inline-block; margin:0; }
.ui-timepicker-div.ui-timepicker-oneLine dl dd.ui_tpicker_minute:before,
.ui-timepicker-div.ui-timepicker-oneLine dl dd.ui_tpicker_second:before { content:':'; display:inline-block; }
.ui-timepicker-div.ui-timepicker-oneLine dl dd.ui_tpicker_millisec:before,
.ui-timepicker-div.ui-timepicker-oneLine dl dd.ui_tpicker_microsec:before { content:'.'; display:inline-block; }
.ui-timepicker-div.ui-timepicker-oneLine .ui_tpicker_unit_hide,
.ui-timepicker-div.ui-timepicker-oneLine .ui_tpicker_unit_hide:before{ display: none; }
    /*customizations*/
    .ui_tpicker_hour_label {margin-bottom:5px !important;}
    .ui_tpicker_minute_label {margin-bottom:5px !important;}
</style>

<script src="//maps.google.com/maps/api/js?key=<%=mapKey%>&language=<%=langCode%>"></script>

<script src="javascript/timepicker/jquery-ui-timepicker-addon.js"></script>
<script src="javascript/pages/submit.js"></script>

<script type="text/javascript" src="javascript/animatedcollapse.js"></script>
  <script type="text/javascript">
    animatedcollapse.addDiv('advancedInformation', 'fade=1');

    animatedcollapse.ontoggle = function($, divobj, state) { //fires each time a DIV is expanded/contracted
      //$: Access to jQuery
      //divobj: DOM reference to DIV being expanded/ collapsed. Use "divobj.id" to get its ID
      //state: "block" or "none", depending on state
    }
    animatedcollapse.init();
  </script>

 <%
 if(!langCode.equals("en")){
 %>

<script src="javascript/timepicker/datepicker-<%=langCode %>.js"></script>
<script src="javascript/timepicker/jquery-ui-timepicker-<%=langCode %>.js"></script>

 <%
 }
 %>

<script type="text/javascript">

/* As you may have surmised, this bit enables bootstrap tooltips. 
 * 
 */
$(document).ready(function(){
    if ($(window).width()>700) {
    	$('[data-toggle="tooltip"]').tooltip();
    }
});




function validate() {
    var requiredfields = "";

    if ($("#submitterName").val().length == 0) {
      /*
       * the value.length returns the length of the information entered
       * in the Submitter's Name field.
       */
      requiredfields += "\n   *  <%=props.getProperty("submit_name") %>";
    }

      /*
      if ((document.encounter_submission.submitterEmail.value.length == 0) ||
        (document.encounter_submission.submitterEmail.value.indexOf('@') == -1) ||
        (document.encounter_submission.submitterEmail.value.indexOf('.') == -1)) {

           requiredfields += "\n   *  valid Email address";
      }
      if ((document.encounter_submission.location.value.length == 0)) {
          requiredfields += "\n   *  valid sighting location";
      }
      */

    if (requiredfields != "") {
      requiredfields = "<%=props.getProperty("pleaseFillIn") %>\n" + requiredfields;
      wildbook.showAlert(requiredfields, null, "Validate Issue");
      return false;
    }

	//this is negated cuz we want to halt validation (submit action) if we are sending via background iframe --
	// it will do the submit via on('load')
	return !sendSocialPhotosBackground();
}


//returns true if we are sending stuff via iframe background magic
function sendSocialPhotosBackground() {
	$('#submit-button').prop('disabled', 'disabled').css('opacity', '0.3').after('<div class="throbbing" style="display: inline-block; width: 24px; vertical-align: top; margin-left: 10px; height: 24px;"></div>');
	var s = $('.social-photo-input');
	if (s.length < 1) return false;
	var iframeUrl = 'SocialGrabFiles?';
	s.each(function(i, el) {
		iframeUrl += '&fileUrl=' + escape($(el).val());
	});

	console.log('iframeUrl %o', iframeUrl);
	document.getElementById('social_files_iframe').src = iframeUrl;
	return true;
}
</script>

<script>
function isEmpty(str) {
    return (!str || 0 === str.length);
}
</script>

<script>


$(function() {
  function resetMap() {
      var ne_lat_element = document.getElementById('lat');
      var ne_long_element = document.getElementById('longitude');


      ne_lat_element.value = "";
      ne_long_element.value = "";

    }

    $(window).unload(resetMap);

    //
    // Call it now on page load.
    //
    resetMap();



    $( "#datepicker" ).datetimepicker({
      changeMonth: true,
      changeYear: true,
      dateFormat: 'yy-mm-dd',
      maxDate: '+0d',
      controlType: 'select',
      alwaysSetTime: false,
      showSecond:false,
      showMillisec:false,
      showMicrosec:false,
      showTimezone:false
    });
    $( "#datepicker" ).datetimepicker( $.timepicker.regional[ "<%=langCode %>" ] );

    $( "#releasedatepicker" ).datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'yy-mm-dd'
    });
    $( "#releasedatepicker" ).datepicker( $.datepicker.regional[ "<%=langCode %>" ] );
    $( "#releasedatepicker" ).datepicker( "option", "maxDate", "+1d" );
});
var gmapLat = 32.6104;
var gmapLon = -117.3712;
var center = new google.maps.LatLng(gmapLat,gmapLon);
var map;
var marker;
var newCenter;
var mapzoom;

function placeMarker(location) {
    if(marker!=null){marker.setMap(null);}
    marker = new google.maps.Marker({
          position: location,
          map: map
      });

      //map.setCenter(location);

        var ne_lat_element = document.getElementById('lat');
        var ne_long_element = document.getElementById('longitude');


        ne_lat_element.value = location.lat();
        ne_long_element.value = location.lng();
    }

  function initialize() {
    mapZoom = 6;
    if($("#map_canvas").hasClass("full_screen_map")){mapZoom=3;}


    if(marker!=null){
        center = new google.maps.LatLng(gmapLat,gmapLon);
    }

    map = new google.maps.Map(document.getElementById('map_canvas'), {
          zoom: mapZoom,
          center: center,
          mapTypeId: google.maps.MapTypeId.HYBRID
        });

    if(marker!=null){
        marker.setMap(map);
    }

      //adding the fullscreen control to exit fullscreen
      var fsControlDiv = document.createElement('DIV');
      addFullscreenButton(fsControlDiv, map);
      fsControlDiv.index = 1;
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(fsControlDiv);

      google.maps.event.addListener(map, 'click', function(event) {
            placeMarker(event.latLng);
      });
      
      
 	 google.maps.event.addListener(map, 'dragend', function() {
 		var idleListener = google.maps.event.addListener(map, 'idle', function() {
 			google.maps.event.removeListener(idleListener);
 			console.log("GetCenter : "+map.getCenter());
 			mapZoom = map.getZoom();
 			newCenter = map.getCenter();
 			center = newCenter;
 			map.setCenter(map.getCenter());
 		});
 		 
	 }); 	 
 	 
 	 google.maps.event.addDomListener(window, "resize", function() {	 
	    	console.log("Resize Center : "+center);
	    	google.maps.event.trigger(map, "resize");
	  	    console.log("Resize : "+newCenter);
	  	    map.setCenter(center);
	 });  
}

function fullScreen() {
    $("#map_canvas").addClass('full_screen_map');
    $('html, body').animate({scrollTop:0}, 'slow');
    initialize();

    //hide header
    $("#header_menu").hide();

    //if(overlaysSet){overlaysSet=false;setOverlays();}
}


function exitFullScreen() {
    $("#header_menu").show();
    $("#map_canvas").removeClass('full_screen_map');

    initialize();
    //if(overlaysSet){overlaysSet=false;setOverlays();}
}


//making the exit fullscreen button
function addFullscreenButton(controlDiv, map) {
    // Set CSS styles for the DIV containing the control
    // Setting padding to 5 px will offset the control
    // from the edge of the map
    controlDiv.style.padding = '5px';

    // Set CSS for the control border
    var controlUI = document.createElement('DIV');
    controlUI.style.backgroundColor = '#f8f8f8';
    controlUI.style.borderStyle = 'solid';
    controlUI.style.borderWidth = '1px';
    controlUI.style.borderColor = '#a9bbdf';;
    controlUI.style.boxShadow = '0 1px 3px rgba(0,0,0,0.5)';
    controlUI.style.cursor = 'pointer';
    controlUI.style.textAlign = 'center';
    controlUI.title = 'Toggle the fullscreen mode';
    controlDiv.appendChild(controlUI);

    // Set CSS for the control interior
    var controlText = document.createElement('DIV');
    controlText.style.fontSize = '12px';
    controlText.style.fontWeight = 'bold';
    controlText.style.color = '#000000';
    controlText.style.paddingLeft = '4px';
    controlText.style.paddingRight = '4px';
    controlText.style.paddingTop = '3px';
    controlText.style.paddingBottom = '2px';
    controlUI.appendChild(controlText);

    //toggle the text of the button
    if($("#map_canvas").hasClass("full_screen_map")){
        controlText.innerHTML = '<%=props.getProperty("exitFullscreen") %>';
    } else {
        controlText.innerHTML = '<%=props.getProperty("fullscreen") %>';
    }

    // Setup the click event listeners: toggle the full screen
    google.maps.event.addDomListener(controlUI, 'click', function() {
        if($("#map_canvas").hasClass("full_screen_map")) {
            exitFullScreen();
        } else {
            fullScreen();
        }
    });
}

google.maps.event.addDomListener(window, 'load', initialize);


// Here's a wee function to update the gps coordinates when input is detected

var liveLat;
var liveLon;
function gpsLiveUpdate() {

	if ($("#lat").val().length > 3 && $("#lat").val().slice(-1) != ".") {
		if	(!isNaN($("#lat").val())) {
			liveLat = $("#lat").val();			
			gmapLat = liveLat;
		}
	}
	if ($("#longitude").val().length > 3 && $("#longitude").val().slice(-1) != ".") {
		if	(!isNaN($("#longitude").val())) {
			liveLon = $("#longitude").val();			
			gmapLon = liveLon;
		}
	}
	if (liveLat.length > 3 && liveLon.length > 3 && !isNaN(liveLat) && !isNaN(liveLon)) {
		newCoords = new google.maps.LatLng(gmapLat,gmapLon);
	    if(marker!=null){marker.setMap(null);}
	    marker = new google.maps.Marker({
	          position: newCoords,
	          map: map
	    });		
		initialize();
	}
}

</script>

<div class="container-fluid page-content" role="main">

<div class="container maincontent">

  <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
      <div class="row">
      
        <div class="col-xs-12">
          <h1 class="intro"><%=props.getProperty("submit_report") %></h1>
          <p><%=props.getProperty("submit_overview") %></p>
          <p class="bg-danger text-danger">
            <%=props.getProperty("submit_note_red") %>
          </p>
        </div>

        <div class="col-xs-6 col-sm-6 col-md-12 col-lg-12">
          <img class="img-responsive" src="cust/mantamatcher/img/bass/katieDavisLeftFlank.jpg" />
          <p><label><%=props.getProperty("leftFlank") %></label></p>
        </div>

        <div class="col-xs-6 col-sm-6 col-md-12 col-lg-12">
          <img class="img-responsive" src="cust/mantamatcher/img/bass/MerryPassagePhilGarner_rightside.jpg" />
          <p><label><%=props.getProperty("rightFlank") %></label></p>
        </div>

      </div>
  </div>


  <div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
<iframe id="social_files_iframe" style="display: none;" ></iframe>
<form id="encounterForm"
	  action="spambot.jsp"
	  method="post"
	  enctype="multipart/form-data"
      name="encounter_submission"
      target="_self" dir="ltr"
      lang="en"
      onsubmit="return false;"
      class="form-horizontal" 
      accept-charset="UTF-8"
>

<div class="dz-message"></div>





<script>


$('#social_files_iframe').on('load', function(ev) {
	if (!ev || !ev.target) return;
	var doc = ev.target.contentDocument || ev.target.contentWindow.contentDocument;
	//console.warn('doc is %o', doc);
	if (doc === null) return;
	var x = $(doc).find('body').text();
	//console.log('body %o', x);
	var j = JSON.parse($(doc).find('body').text());
	console.log('iframe returned %o', j);
	console.log("social_files_id : "+j.id);
	$('#encounterForm').append('<input type="hidden" name="social_files_id" value="' + j.id + '" />');
	//now do actual submit
	submitForm();
});

//this is a simple wrapper to this, as it is called from 2 places (so far)
function submitForm() {
	document.forms['encounterForm'].submit();
}

var toRemove = [];
var fileListGlobal = [];
var fileNameListGlobal = [];
function updateList(inp) {
    //All this is getting reset onChange because the fileItem is immutable. 
    fileListGlobal = [];
    fileNameListGlobal = [];
    toRemove = [];
    //document.getElementById('input-file-list').innerHTML = "";
    document.getElementById('uploadList').innerHTML = "";
    var name = "";
    var fileListHTML = '';
    if (inp.files && inp.files.length) {
        //var all = [];
        for (var i = 0 ; i < inp.files.length ; i++) {
            if (inp.files[i].size > <%=maxSizeBytes%>) {
                fileListGlobal.push('<span class="error">' + inp.files[i].name + ' (' + Math.round(inp.files[i].size / (1024*1024)) + 'MB is too big, <%=maxSizeMB%>MB max)</span>');
            } else {
                name = String(inp.files[i].name);
                var eachFile = "<li class='fileLink' id=\"filenameListItem"+i+"\"><small>";
                eachFile += '<div>'+inp.files[i].name+' ('+Math.round(inp.files[i].size / 1024)+'k) <a onclick="removeFile(this.id)" id="filenameLink'+i+'">Remove</a></div>';
                eachFile += '<input type="hidden" id="filename'+i+'" value="'+name+'"></input>';
                eachFile += "</small></li>";
                fileListGlobal.push(eachFile);
                fileNameListGlobal.push(name);
            }
        }
        fileListHTML = '<b id="fileCounter">' + fileListGlobal.length + ' file' + ((fileListGlobal.length == 1) ? '' : 's:') + '</b> ' + fileListGlobal.join('');
    } else {
        fileListHTML = inp.value;
    }
    //document.getElementById('input-file-list').innerHTML = fileListHTML;
    document.getElementById('uploadList').innerHTML = fileListHTML;
    // For every file in the length of the final list, add an event listener based on it's index. This listener modifies the array of toRemove files on the backend. 
}

function showUploadBox() {
  $("#submitsocialmedia").addClass("hidden");
  $("#submitupload").removeClass("hidden");
}

function removeFile(id) {
  var num = id.substring("fileNameLink".length);
  var name = $("#filename"+num).val();
  $("#filenameListItem"+num).addClass("hidden");
  toRemove.push(name);
  var numFiles = (fileListGlobal.length - toRemove.length);
  var count = "";
  if (numFiles > 1) {
    count = String(numFiles) + " files:";
  } else if (numFiles===1) {
    count = String(numFiles) + " file:";
  } else {
    count = "";
  }
  $('#fileCounter').html(count);
  $("#toRemove").val(toRemove.join(";"));
}

</script>

<fieldset class="field-indent">
<h4><%=props.getProperty("submit_image")%></h4>
<p><%=props.getProperty("submit_pleaseadd")%></p>
	<div class="center-block">
        <ul id="social_image_buttons" class="list-inline text-center">
          <!--  This is the default active computer button for uploading images. If you want other uploads, this will need to have the hidden class removed. -->
          <li class="active hidden">
              <button class="zocial icon" data-toggle="tooltip" title="<%=props.getProperty("computerUploadTooltip")%>" onclick="showUploadBox()" style="background:url(images/computer.png);background-repeat: no-repeat;">
              </button>
          </li>
        </ul>
    </div>

    <div>
        <div id="submitupload" class="input-file-drop">
            <% if (isIE) { %>
            <div><%=props.getProperty("dragInstructionsIE")%></div>
            
              <input class="ie fileInput0" name="theFiles" type="file" accept=".jpg, .jpeg, .png, .bmp, .gif, .mov, .wmv, .avi, .mp4, .mpg" multiple size="30" onChange="updateList(this);" />
            
            <% } else { %>
            
             <input class="nonIE fileInput0" name="theFiles" type="file" accept=".jpg, .jpeg, .png, .bmp, .gif, .mov, .wmv, .avi, .mp4, .mpg" multiple size="30" onChange="updateList(this);" />
            
            <div><%=props.getProperty("dragInstructions")%></div>
            <% } %>
            <!-- <div style="display:none;" id="input-file-list"></div> -->
        </div>

        <div id="submitsocialmedia" class="container-fluid hidden" style="height:300px;">
            <div id="socialalbums" class="col-md-4" style="height:100%;overflow-y:auto;">
            </div>
            <div id="socialphotos" class="col-md-8" style="height:100%;overflow-y:auto;">
            </div>
        </div>
    </div>

    <div>
      <ul id="uploadList" style="list-style:none;"> 
      
      </ul>
      <label><%=props.getProperty("canAddOnce") %></label>
      <input type="hidden" id="toRemove" name="toRemove" value=""></input>
    </div>

</fieldset>
<hr/>
<fieldset class="field-indent">

  <div class="form-group">
    <div class="form-inline required col-xs-12 col-sm-12 col-md-6 col-lg-6">
      <h4><%=props.getProperty("dateAndLocation")%></h4>
      <p><label class="text-danger"><%=props.getProperty("submit_date") %></label></p>
      <input class="form-control" type="text" id="datepicker" name="datepicker" size="20" data-toggle="tooltip" placeholder="2017-07-13 14:30" title="<%=props.getProperty("dateTooltip")%>"/>
      <p><label><small><%=props.getProperty("submit_date_guide")%></small></label></p>
    </div>
    <%
    if(CommonConfiguration.showReleaseDate(context)){
    %>
      <div class="form-inline col-xs-12 col-sm-12 col-md-6 col-lg-6">
          <label class="text-danger"><%=props.getProperty("submit_releasedate") %></label>
          <input class="hasDatepicker form-control" type="text" style="position: relative; z-index: 101;" id="releasedatepicker" name="releaseDate" size="20">
      </div>
    <%
    }
    %>
  </div>

</fieldset>

<hr/>

<fieldset class="field-indent">

  <div class="form-group required">
    <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
      <h4><%=props.getProperty("submit_location")%></h4>
      <p><label class="text-danger"><%=props.getProperty("where") %></label></p>
      <input name="location" type="text" id="location" size="40" class="form-control" data-toggle="tooltip" title="<%=props.getProperty("locationTooltip")%>">
    </div>
  </div>

<%
//add locationID to fields selectable

if(CommonConfiguration.getIndexedPropertyValues("locationID", context).size()>0){
%>
    <div class="form-group required">
      <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
        <p><label class=""><%=props.getProperty("studySites") %></label></p>
        <select name="locationID" id="locationID" class="form-control" data-toggle="tooltip" title="<%=props.getProperty("studySiteTooltip")%>">
            <option value="" selected="selected"></option>
                  <%
                         boolean hasMoreLocationsIDs=true;
                         int locNum=0;

                         while(hasMoreLocationsIDs){
                               String currentLocationID = "locationID"+locNum;
                               if(CommonConfiguration.getProperty(currentLocationID,context)!=null){
                                   %>

                                     <option value="<%=CommonConfiguration.getProperty(currentLocationID,context)%>"><%=CommonConfiguration.getProperty(currentLocationID,context)%></option>
                                   <%
                                 locNum++;
                            }
                            else{
                               hasMoreLocationsIDs=false;
                            }

                       }

     %>
      </select>
      </div>
    </div>
<%
}

if(CommonConfiguration.showProperty("showCountry",context)){

%>
          <div class="form-group required">
      <div class="col-xs-6 col-sm-6 col-md-4 col-lg-4">
        <label><%=props.getProperty("country") %></label>
      </div>

      <div class="col-xs-6 col-sm-6 col-md-6 col-lg-8">
        <select name="locationID" id="locationID" class="form-control">
            <option value="" selected="selected"></option>
            <%
            String[] locales = Locale.getISOCountries();
			for (String countryCode : locales) {
				Locale obj = new Locale("", countryCode);
				String currentCountry = obj.getDisplayCountry();
                %>
			<option value="<%=currentCountry %>"><%=currentCountry%></option>
            <%
            }
			      %>
   		</select>
      </div>
    </div>

<%
}  //end if showCountry

%>

<div>
    <p id="map">
    <!--
      <p>Use the arrow and +/- keys to navigate to a portion of the globe,, then click
        a point to set the sighting location. You can also use the text boxes below the map to specify exact
        latitude and longitude.</p>
    -->
    <p class="help-block">
        <%=props.getProperty("mapExplanation") %></p>
	
    <p id="map_canvas" style="width: 578px; height: 383px; "></p>
    <p id="map_overlay_buttons"></p>
</div>

    <div id="gpsInputs">
      <div class="form-group form-inline">
        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
          <p><label class=""><%=props.getProperty("submit_gpslatitude") %>&nbsp;</label></p>
          <input class="form-control" name="lat" type="number" value="90.00000" step="any" id="lat" oninput="gpsLiveUpdate()" max="90.00000" min="-90.00000" data-toggle="tooltip" title="<%=props.getProperty("latitudeTooltip")%>">
        </div>

        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
          <p><label class=""><%=props.getProperty("submit_gpslongitude") %>&nbsp;</label></p>
          <input class="form-control" name="longitude" type="number" value="180.00000" step="any" id="longitude" oninput="gpsLiveUpdate()" max="180.00000" min="-180.00000" data-toggle="tooltip" title="<%=props.getProperty("longitudeTooltip")%>">
        </div>
      </div>

      <p class="help-block"><%=props.getProperty("gpsConverter") %></p>
    </div>

<%
if(CommonConfiguration.showProperty("maximumDepthInMeters",context)){
%>
  <div class="form-group form-inline">
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
      <p><label class=""><%=props.getProperty("submit_depth")%></label></p>
      <input id="submitDepth" class="form-control" name="depth" type="text" id="depth" data-toggle="tooltip" placeholder="Depth in feet" title="<%=props.getProperty("seaDepthTooltip")%>">
    </div>
  </div>
  <br/>
<%
}

if(CommonConfiguration.showProperty("maximumElevationInMeters",context)){
%>
  <div class="form-group form-inline">
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
      <p><label class=""><%=props.getProperty("submit_elevation")%></label></p>
      <input id="submitElevation" class="form-control" name="elevation" type="text" placeholder="Distance in Feet" id="elevation">
    </div>
  </div>
	<br/>	
<%
}
%>
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
      <p class="help-block"><%=props.getProperty("ftConverter") %></p>
    </div>
</fieldset>

<hr/>

    <%
    //let's pre-populate important info for logged in users
    String submitterName="";
    String submitterEmail="";
    String affiliation="";
    String project="";
    if(request.getRemoteUser()!=null){
        submitterName=request.getRemoteUser();
        Shepherd myShepherd=new Shepherd(context);
        myShepherd.setAction("submit.jsp1");
        myShepherd.beginDBTransaction();
        if(myShepherd.getUser(submitterName)!=null){
            User user=myShepherd.getUser(submitterName);
            if(user.getFullName()!=null){submitterName=user.getFullName();}
            if(user.getEmailAddress()!=null){submitterEmail=user.getEmailAddress();}
            if(user.getAffiliation()!=null){affiliation=user.getAffiliation();}
            if(user.getUserProject()!=null){project=user.getUserProject();}
        }
        myShepherd.rollbackDBTransaction();
        myShepherd.closeDBTransaction();
    }
    %>



  <fieldset class="field-indent">
    <div class="row">
      <div class="col-xs-12 col-lg-6">
	      <h4><%=props.getProperty("aboutYou") %></h4>
        <p class="help-block"><%=props.getProperty("submit_contactinfo") %></p>
        <div class="form-group form-inline">
          <div class="col-xs-6 col-md-4">
            <label class="text-danger control-label"><%=props.getProperty("submit_name") %></label>
          </div>
          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="submitterName" type="text" id="submitterName" size="24" value="<%=submitterName %>" data-toggle="tooltip" title="<%=props.getProperty("nameTooltip")%>">
          </div>
        </div>

        <div class="form-group form-inline">

          <div class="col-xs-6 col-md-4">
            <label class="text-danger control-label"><%=props.getProperty("submit_email") %></label>
          </div>
          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="submitterEmail" type="text" id="submitterEmail" size="24" value="<%=submitterEmail %>" data-toggle="tooltip" title="<%=props.getProperty("emailTooltip")%>">
          </div>
        </div>
      </div>

      <div class="col-xs-12 col-lg-6">
        <h4><%=props.getProperty("aboutPhotographer") %></br></h4>
 		    <p class="help-block"><%=props.getProperty("submit_ifyou")%></p>
        <div class="form-group form-inline">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("photographer_name") %></label>
          </div>
          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="photographerName" type="text" id="photographerName" size="24" data-toggle="tooltip" title="<%=props.getProperty("photographerNameTooltip")%>">
          </div>
        </div>

        <div class="form-group form-inline">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("photographer_email") %></label>
          </div>
          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="photographerEmail" type="text" id="photographerEmail" size="24" data-toggle="tooltip" title="<%=props.getProperty("photographerEmailTooltip")%>">
          </div>
        </div>
      </div>
    </div>
    
    <hr>
    <div class="form-group">
      <div class="col-xs-12 col-md-12 col-lg-12">
	    <h4><%=props.getProperty("commentsHeader") %></h4>
        <label class="control-label"><%=props.getProperty("submit_comments") %></label>
        <br>
      </div>
      <br>
      <div class="col-xs-12 col-lg-12 col-lg-12">
        <textarea class="form-control" name="comments" id="comments" rows="5" data-toggle="tooltip" title="<%=props.getProperty("commentsTooltip")%>"></textarea>
      </div>
    </div>
    
    
  </fieldset>

  <hr/>


  <h4 class="accordion center-labels">
    <a href="javascript:animatedcollapse.toggle('advancedInformation')" style="text-decoration:none" data-toggle="tooltip" title="<%=props.getProperty("advancedButtonTooltip")%>">
      <%=props.getProperty("advancedInformation") %><br>
      <span class="glyphicon glyphicon-menu-down glyphicon-white" aria-hidden="true" width="100%" height="10" border="0"></span>
    </a>
  </h4>

    <div id="advancedInformation" fade="1" style="display: none;">
  	    
      <h4><%=props.getProperty("aboutAnimal") %></h4>
        <hr>
        <fieldset class="field-indent">
<%

if(CommonConfiguration.showProperty("showTaxonomy",context)){

%>

      <div class="form-group hidden">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("species") %></label>
          </div>

          <div class="col-xs-6 col-lg-8">
            <select class="form-control" name="genusSpecies" id="genusSpecies">
             	<option value="" selected="selected"><%=props.getProperty("submit_unsure") %></option>
  <%

  					List<String> species=CommonConfiguration.getIndexedPropertyValues("genusSpecies", context);
  					int numGenusSpeciesProps=species.size();
  					String selected="";
  					if(numGenusSpeciesProps==1){selected="selected=\"selected\"";}

                     if(CommonConfiguration.showProperty("showTaxonomy",context)){

                    	for(int q=0;q<numGenusSpeciesProps;q++){
                           String currentGenuSpecies = "genusSpecies"+q;
                           if(CommonConfiguration.getProperty(currentGenuSpecies,context)!=null){
                               %>
                                 <option value="<%=CommonConfiguration.getProperty(currentGenuSpecies,context)%>" <%=selected %>><%=CommonConfiguration.getProperty(currentGenuSpecies,context).replaceAll("_"," ")%></option>
                               <%

                        }


                   }
                   }
 %>
  </select>
    </div>
        </div>

        <%
}

%>

  <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("status") %></label>
          </div>

          <div class="col-xs-6 col-lg-8">
            <select class="form-control" name="livingStatus" id="livingStatus" data-toggle="tooltip" title="<%=props.getProperty("statusTooltip")%>">
              <option value="alive" selected="selected"><%=props.getProperty("alive") %></option>
              <option value="dead"><%=props.getProperty("dead") %></option>
            </select>
          </div>
        </div>
        
<!-- This is just here in case they want to bring back alt ID at some point.  -->
<% 
	boolean alt = false;
	if (alt == true) {
	
%>
				<div class="form-group">
					<div class="col-xs-6 col-md-4">
						<label class="control-label"><%= props.getProperty("alternate_id") %></label>
					</div>

					<div class="col-xs-6 col-lg-8">
						<input class="form-control" name="alternateID" type="text" id="alternateID" size="75">
					</div>
				</div>
				
<% 
	}
%>

<!--  end bracket for hiding altID -->

        <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("submit_behavior") %></label>
            <p><small><%=props.getProperty("behaviorExplanation") %></small></p>
          </div>

          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="behavior" type="text" id="behavior" size="75" data-toggle="tooltip" title="<%=props.getProperty("behaviorTooltip")%>">
          </div>
        </div>


           <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("submit_scars") %></label>
            <p><small><%=props.getProperty("scarsExplanation") %></small></p>
          </div>

          <div class="col-xs-6 col-lg-8">
            <input class="form-control" name="scars" type="text" id="scars" size="75" data-toggle="tooltip" title="<%=props.getProperty("scarsTagsTooltip")%>">
          </div>
        </div>

<%

if(CommonConfiguration.showProperty("showLifestage",context)){

%>
<div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label class="control-label"><%=props.getProperty("lifeStage") %></label>
          </div>
          <div class="col-xs-6 col-lg-8">
  <select name="lifeStage" id="lifeStage" data-toggle="tooltip" title="<%=props.getProperty("lifeStageTooltip")%>">
      <option value="" selected="selected"></option>
  <%
                     boolean hasMoreStages=true;
                     int stageNum=0;

                     while(hasMoreStages){
                           String currentLifeStage = "lifeStage"+stageNum;
                           if(CommonConfiguration.getProperty(currentLifeStage,context)!=null){
                               %>

                                 <option value="<%=CommonConfiguration.getProperty(currentLifeStage,context)%>"><%=CommonConfiguration.getProperty(currentLifeStage,context)%></option>
                               <%
                             stageNum++;
                        }
                        else{
                          hasMoreStages=false;
                        }

                   }

 %>
  </select>
  </div>
        </div>


<%
}
%>



</fieldset>
<%
    pageContext.setAttribute("showMeasurements", CommonConfiguration.showMeasurements(context));
%>
<c:if test="${showMeasurements}">
<hr>
 <fieldset class="field-indent">
<%
    pageContext.setAttribute("items", Util.findMeasurementDescs(langCode,context));
    pageContext.setAttribute("samplingProtocols", Util.findSamplingProtocols(langCode,context));
%>

 <div class="form-group">
           <h4><%=props.getProperty("measurements") %></h4>


<div class="col-xs-12 col-lg-8">
  <table class="measurements">
  <tr>
  <th><%=props.getProperty("type") %></th><th><%=props.getProperty("size") %></th><th><%=props.getProperty("units") %></th><c:if test="${!empty samplingProtocols}"><th><%=props.getProperty("samplingProtocol") %></th></c:if>
  </tr>
  <c:forEach items="${items}" var="item">
    <tr>
    <td>${item.type}</td>
    <td><input name="measurement(${item.type})" id="${item.type}" data-toggle="tooltip" title="<%=props.getProperty("lengthTooltip")%>"/><input type="hidden" name="measurement(${item.type}units)" value="${item.units}"/></td>
    <td><c:out value="${item.units}"/></td>
    <c:if test="${!empty samplingProtocols}">
      <td>
        <select name="measurement(${item.type}samplingProtocol)" data-toggle="tooltip" title="<%=props.getProperty("samplingProtocolTooltip")%>">
        <c:forEach items="${samplingProtocols}" var="optionDesc">
          <option value="${optionDesc.name}"><c:out value="${optionDesc.display}"/></option>
        </c:forEach>
        </select>
      </td>
    </c:if>
    </tr>
    <br>
  </c:forEach>
  </table>
   </div>
        </div>
         </fieldset>
</c:if>




      <hr/>
      
<!--  turns on and off tag section of advanced info for submission -->	
<%
boolean tagSwitch = false;
if (tagSwitch == true) {
%>
       <fieldset class="field-indent">
        <h4><%=props.getProperty("tags") %></h4>
      <%
  pageContext.setAttribute("showMetalTags", CommonConfiguration.showMetalTags(context));
  pageContext.setAttribute("showAcousticTag", CommonConfiguration.showAcousticTag(context));
  pageContext.setAttribute("showSatelliteTag", CommonConfiguration.showSatelliteTag(context));
  pageContext.setAttribute("metalTags", Util.findMetalTagDescs(langCode,context));
%>

<c:if test="${showMetalTags and !empty metalTags}">

 <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label><%=props.getProperty("physicalTags") %></label>
          </div>

<div class="col-xs-12 col-lg-8">
    <table class="metalTags">
    <tr>
      <th><%=props.getProperty("location") %></th><th><%=props.getProperty("tagNumber") %></th>
    </tr>
    <c:forEach items="${metalTags}" var="metalTagDesc">
      <tr>
        <td><c:out value="${metalTagDesc.locationLabel}:"/></td>
        <td><input name="metalTag(${metalTagDesc.location})"/></td>
      </tr>
    </c:forEach>
    </table>
  </div>
  </div>
</c:if>

<c:if test="${showAcousticTag}">
 <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label><%=props.getProperty("acousticTag") %></label>
          </div>
<div class="col-xs-12 col-lg-8">
      <table class="acousticTag">
      <tr>
      <td><%=props.getProperty("serialNumber") %></td>
      <td><input name="acousticTagSerial"/></td>
      </tr>
      <tr>
        <td><%=props.getProperty("id") %></td>
        <td><input name="acousticTagId"/></td>
      </tr>
      </table>
    </div>
    </div>
</c:if>

<c:if test="${showSatelliteTag}">
 <div class="form-group">
          <div class="col-xs-6 col-md-4">
            <label><%=props.getProperty("satelliteTag") %></label>
          </div>
<%
  pageContext.setAttribute("satelliteTagNames", Util.findSatelliteTagNames(context));
%>
<div class="col-xs-12 col-lg-8">
      <table class="satelliteTag">
      <tr>
        <td><%=props.getProperty("name") %></td>
        <td>
            <select name="satelliteTagName">
              <c:forEach items="${satelliteTagNames}" var="satelliteTagName">
                <option value="${satelliteTagName}">${satelliteTagName}</option>
              </c:forEach>
            </select>
        </td>
      </tr>
      <tr>
        <td><%=props.getProperty("serialNumber") %></td>
        <td><input name="satelliteTagSerial"/></td>
      </tr>
      <tr>
        <td><%=props.getProperty("argosNumber") %></td>
        <td><input name="satelliteTagArgosPttNumber"/></td>
      </tr>
      </table>
    </div>
    </div>
</c:if>

      </fieldset>

<hr/>
<!-- end tagSwitch -->
<%}%>
      <div class="form-group">
        <label class="control-label"><%=props.getProperty("otherEmails") %></label>
        <input class="form-control" name="informothers" type="text" id="informothers" size="75" data-toggle="tooltip" title="<%=props.getProperty("additionalEmailTooltip")%>">
        <p class="help-block"><%=props.getProperty("multipleEmailNote") %></p>
      </div>
      </div>

  <hr>	

         <%
         if(request.getRemoteUser()==null){
         %>
     
	<div id="myCaptcha" style="width: 50%;margin: 0 auto; "></div>
           <script>
		         //we need to first check here if we need to do the background social image send... in which case,
		        // we cancel do not do the form submit *here* but rather let the on('load') on the iframe do the task

		       var captchaWidgetId;
		        function onloadCallback() {
		        	captchaWidgetId = grecaptcha.render(

			        	'myCaptcha', {
				  			'sitekey' : '<%=recaptchaProps.getProperty("siteKey") %>',  // required
				  			'theme' : 'light'
						});
		        }





           </script>

        <%
         }
        %>
<script>

function sendButtonClicked() {
	console.log('sendButtonClicked()');
	
	console.log('fell through -- must be no social!');

    <%
    if(request.getUserPrincipal()!=null){
    %>
    	$("#encounterForm").attr("action", "EncounterForm");
    	submitForm();
    <%
    }
    else{
    %>
    	if(($('#myCaptcha > *').length < 1)){
    	    $("#encounterForm").attr("action", "EncounterForm");
			submitForm();
   		}
   		else{	console.log('Here!'); 	
   			    	var recaptachaResponse = grecaptcha.getResponse( captchaWidgetId );
   					
   					console.log( 'g-recaptcha-response: ' + recaptachaResponse );
   					if(!isEmpty(recaptachaResponse)) {		
   						$("#encounterForm").attr("action", "EncounterForm");
   						
   						
   						//ok all is well so far, but quick redirect if we're doing a social upload
   						if (sendSocialPhotosBackground()) return false;
   						
   						//if no social, proceed
   						submitForm();
   					}
   					
		}
	//alert(recaptachaResponse);
	<%
    }
	%>
	return true;
}
</script>


      <p class="text-center">
        <button class="large" type="submit" onclick="return sendButtonClicked();">
          <%=props.getProperty("submit_send") %>
          <span class="button-icon" aria-hidden="true" />
        </button>
      </p>


<p>&nbsp;</p>
<%if (request.getRemoteUser() != null) {%>
	<input name="submitterID" type="hidden" value="<%=request.getRemoteUser()%>"/>
<%}
else {%>
	<input name="submitterID" type="hidden" value="N/A"/>
<%
}
%>


<p>&nbsp;</p>
</form>

</div>
</div>
</div>

<jsp:include page="footer.jsp" flush="true"/>
