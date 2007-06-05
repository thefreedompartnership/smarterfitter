var map = null;
var points = new Array();
var distanceMarkers = new Array();
var routeLine = null;
var geocoder = new GClientGeocoder();
var undoHistory = new Array();
var metersPerDistanceUnit = 1000;
var isEditable = true;
var lastClick = new Date();
var doubleClicked = false;
var lastClickPoint = null;


function undo() {
	if(points.length > 0) {
		undoHistory.push(points.pop());	
	}
	refreshMap();
}

function redo() {
	if(undoHistory.length > 0) {
		points.push(undoHistory.pop());
	}
	refreshMap();
}

function clearRoute() {
	if(confirm("Are you sure you want to clear your route?")){
		points = new Array();
		refreshMap();
	}
}

function removeDistanceMarkers() {
	for(i = 0; i < distanceMarkers.length; i++) {
		map.removeOverlay(distanceMarkers[i]);
	}
	distanceMarkers = new Array();
}

function refreshMap() {
	updateRoutePoints();
	drawRoute();
	drawMileMarkers();
	if(points.length > 0) {
		map.panTo(points[points.length - 1]);
	}
	if(isEditable) {
		writeDistance();
		updateRedoUndoClearControls();
	}
}

function updateRedoUndoClearControls() {
	if(undoHistory.length == 0) {
		disableAnchor($('redoAnchor'), true);
	} else {
		disableAnchor($('redoAnchor'), false);
	}
	
	if(points.length == 0) {
		disableAnchor($('undoAnchor'), true);
		disableAnchor($('clearAnchor'), true);
	} else {
		disableAnchor($('undoAnchor'), false);
		disableAnchor($('clearAnchor'), false);
	}

	function disableAnchor(obj, disable){
	  if(disable){
	    var href = obj.getAttribute("href");
	    if(href && href != "" && href != null){
	       obj.setAttribute('href_bak', href);
	    }
	    obj.removeAttribute('href');
	    obj.style.color="gray";
	  } else if(obj.attributes['href_bak']) {
	    obj.setAttribute('href', obj.attributes['href_bak'].nodeValue);
	    obj.style.color="blue";
	  }
	}	
	
}

function serializeGLatLngArray(array) {
	if(array == null) return null;
	var result = "";
	for(var i = 0; i < array.length; i++) {
		var point = array[i];
		result += point.lat().toString();
		result += ",";
		result += point.lng().toString();
		if(i != array.length -1) {
			result += ",";
		}
	}
	return result;
}

function deserializeGLatLngArray(string) {
	if(string == null) return null;
	var result = new Array();
	var coordinates = string.split(",");
	for(var i = 0; i < coordinates.length; i+=2) {
		var point = new GLatLng(parseFloat(coordinates[i]), parseFloat(coordinates[i+1]));
		result.push(point);
	}
	return result;
}

function updateRoutePoints() {
	$('run_route_points').value = serializeGLatLngArray(points);
}

function drawRoute() {
	map.removeOverlay(routeLine);
	if(points.length > 1) {
		routeLine = new GPolyline(points, "#ff0000", 10);
		map.addOverlay(routeLine);
	}
}
	
function drawMileMarkers() {
	removeDistanceMarkers();
	if(points.length > 1) {
		var markerNumber = 0;
		var distanceUntilNextMarker = 0;
		for(i = 0, j = 1; j < points.length; i++, j++) {
			var deltaDistance = points[i].distanceFrom(points[j]);
			var firstPoint = points[i];
			var secondPoint = points[j];
			while(deltaDistance >= distanceUntilNextMarker) {
				var proportion = distanceUntilNextMarker / deltaDistance;
				var deltaX = secondPoint.lng() - firstPoint.lng();
				var deltaY = secondPoint.lat() - firstPoint.lat();
				var markerPoint = new GLatLng(firstPoint.lat() + (proportion * deltaY), firstPoint.lng() + (proportion * deltaX));														
				var distanceMarker = createMarker(markerPoint, markerNumber);
				map.addOverlay(distanceMarker);
				distanceMarkers.push(distanceMarker);
				deltaDistance -= distanceUntilNextMarker;
				distanceUntilNextMarker = metersPerDistanceUnit;
				firstPoint = markerPoint;
				markerNumber++;
			}
			distanceUntilNextMarker = distanceUntilNextMarker - deltaDistance;
		}				
	} else if(points.length == 1) {
		distanceMarkers.push(new GMarker(points[0]));
		map.addOverlay(distanceMarkers[0]);
	}
	
}

function createMarker(markerPoint, markerNumber) {
	var baseIcon = new GMarker(markerPoint).getIcon();
	var icon = new GIcon(baseIcon);
	if(0 < markerNumber && markerNumber <= 100) {
		var imageURI = '/images/maps/markers/numbered/' + markerNumber + '.png'
		icon.image = imageURI;
	}
	return new GMarker(markerPoint, icon);
}


function writeDistance() {
	var distance = getDistance() / metersPerDistanceUnit;
	distance = Math.round(distance * 1000) / 1000;
	if(distance != 0) {
		$("run_distance").value = distance;
	} else {
		$("run_distance").value = "";
	}

}

function getDistance() {

	var distance = 0;
	if(points.length > 1) {
		for(i = 0, j = 1; j < points.length; i++, j++) {
			distance += points[i].distanceFrom(points[j]);
		}
	}
	return distance;
}

function changeMetersPerDistanceUnit(distance_unit) {
	if(distance_unit == "miles") {
		metersPerDistanceUnit = 1609.334;
	} else {
		metersPerDistanceUnit = 1000;
	}
}

/*
function showAddress(address) {
  geocoder.getLatLng(
    address,
    function(point) {
      if (!point) {
        alert(address + " not found");
      } else {
        map.panTo(point, 13);
      }
    }
  );
}
*/

function loadPickLocation() {
	if (GBrowserIsCompatible()) {
    	map = new GMap2(document.getElementById("map"));

		var lat = null;
		var lng = null;
		var zoom = null;
		
		if($('user_default_latitude').value == "" ||
 		   $('user_default_longitude').value == "" ||
		   $('user_default_zoom').value == "") {
			lat = 51.561473704830611;
			lng = -0.078783670755158325;
			zoom = 10;
		} else {
			lat = parseFloat($('user_default_latitude').value);
			lng = parseFloat($('user_default_longitude').value);
			zoom = parseInt($('user_default_zoom').value);			
		}
		
		map.setCenter(new GLatLng(lat, lng), zoom);
		map.addControl(new GLargeMapControl());
		map.addControl(new GScaleControl());
		map.addControl(new GOverviewMapControl());

		GEvent.addListener(map, "moveend", function() {			
			var center = map.getCenter();
			$('user_default_latitude').value = center.lat();
			$('user_default_longitude').value = center.lng();
			$('user_default_zoom').value = map.getZoom();
		});
		GEvent.addListener(map, "zoomend", function(oldLevel, newLevel) {			
			var center = map.getCenter();
			$('user_default_latitude').value = center.lat();
			$('user_default_longitude').value = center.lng();
			$('user_default_zoom').value = map.getZoom();
		});
		
	}
}

function load() {
	if (GBrowserIsCompatible()) {
		
    	map = new GMap2(document.getElementById("map"));
		points = new Array();

		var lat = null;
		var lng = null;
		var zoom = null;

		if($('user_default_latitude').value == "" ||
 		   $('user_default_longitude').value == "" ||
		   $('user_default_zoom').value == "") {
			lat = 51.561473704830611;
			lng = -0.078783670755158325;
			zoom = 10;
		} else {
			lat = parseFloat($('user_default_latitude').value);
			lng = parseFloat($('user_default_longitude').value);
			zoom = parseInt($('user_default_zoom').value);			
		}
		map.setCenter(new GLatLng(lat, lng), zoom);
		map.addControl(new GLargeMapControl());
		map.addControl(new GScaleControl());
		map.addControl(new GOverviewMapControl());

		changeMetersPerDistanceUnit($('run_distance_unit').value);

		if($('run_route_points').value) {
			points = deserializeGLatLngArray($('run_route_points').value);
		}
		refreshMap();
		if(points.length > 0) {
			map.panTo(points[0]);
		}
	}

	if(isEditable) {
		GEvent.addListener(map, "click", function(marker, point) {
			if(point) {
				// okay, this is some fairly gruesome code for handling the double click
				// i don't much care for it but that's what i've got right now...
				// basically two clicks within 500ms is a double click -- yeah, not accessible really
				// it doesn't work in IE either
				var now = new Date();
				var diff = now.getTime() - lastClick.getTime();
				doubleClicked = (diff < 500);
				if(doubleClicked) {
					map.panTo(point);
				} else {
					lastClickPoint = point;
					lastClick = new Date();
					window.setTimeout("checkClick()", 500);
				}
			}
		});
		GEvent.addListener(map, "moveend", function() {			
			var center = map.getCenter();
			$('user_default_latitude').value = center.lat();
			$('user_default_longitude').value = center.lng();
			$('user_default_zoom').value = map.getZoom();
		});
		GEvent.addListener(map, "zoomend", function(oldLevel, newLevel) {			
			var center = map.getCenter();
			$('user_default_latitude').value = center.lat();
			$('user_default_longitude').value = center.lng();
			$('user_default_zoom').value = map.getZoom();
		});
		
	}

}


function checkClick() {
	if(!doubleClicked) {
		points.push(lastClickPoint);
		refreshMap();					
	}
}

function loadNoEdit() {
	isEditable = false;
	load();
}

function saveDefaultMap() {
	new Ajax.Updater({success:'defaultMapFlash',failure:'defaultMapFlash'}, '/runlog/pick_location_ajax', {asynchronous:true, evalScripts:true, parameters:Form.serialize($("defaultMapForm"))});
}

