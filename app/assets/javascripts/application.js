// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	initMap();
});

// create map with searchbox
var initMap = function(){
	// createMap(); 
	var map = new google.maps.Map(document.getElementById('map'), {
		// hardcode Chicago for now as default
		center: {lat:41.875586, lng:-87.627105},
		zoom: 4
	});
	
	addSearchBox(map);
	// createSearchBox(map);
	// var pageDiv = document.getElementById('searchbox');
	// var searchBox = new google.maps.places.Autocomplete(pageDiv, {types: ['(cities)']});
	// map.controls[google.maps.ControlPosition.TOP].push(pageDiv);

  // map.addListener('bounds_changed', function() {
  //   searchBox.setBounds(map.getBounds());
  // });

  getLocation(map);
	getForecast(map);
};

// create base map
// var createMap = function(){
// 	var map = new google.maps.Map(document.getElementById('map'), {
// 		// hardcode Chicago for now as default
// 		center: {lat:41.875586, lng:-87.627105},
// 		zoom: 4
// 	});
// };

// add searchBox to map
var addSearchBox = function(map){
	var pageDiv = document.getElementById('searchbox');
	var searchBox = new google.maps.places.Autocomplete(pageDiv, {types: ['(cities)']});
	map.controls[google.maps.ControlPosition.TOP].push(pageDiv);
	chooseLocation(map, searchBox);
	biasOnView(map, searchBox);
};


// Bias the SearchBox results towards current map's viewport.
var biasOnView = function(map, searchBox){
  map.addListener('bounds_changed', function() {
    searchBox.setBounds(map.getBounds());
  });
};

// find current position
var getLocation = function(map){
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position){
			var pos = {
				lat: position.coords.latitude,
				lng: position.coords.longitude
			};
		map.setCenter(pos);
		map.setZoom(8);
		});
	};
};

// Select new position
var chooseLocation = function(map, searchBox){
	searchBox.addListener('place_changed', function(){
		var place = searchBox.getPlace();
		map.setCenter(place.geometry.location);
		
	});
};

// get forecast for area at center of map
var getForecast = function(map){
	$('#forecast form').on('submit', function(e){
		e.preventDefault();
		var $this = $(this);

		var url = $this.attr('action');
		var method = $this.attr('method');
		var lat = getLat(map);
		var lng = getLng(map);
		var data = {
			lat: lat,
			lng: lng
		};
		
		enlargeTable();
		enlargeWeekly();

		$.ajax({
			url: url,
			method: method,
			data: data
		})
		.done(function(response){
			// console.log(response)
			// console.log(response.currently)		
			$('.temperature').html(response.currently.temperature);
			$('.humidity').html(response.currently.humidity);
			$('.feels_like').html(response.currently.apparentTemperature);
			$('.summary').html(response.currently.summary);
			$('.weekly_weather').append("<section class='glance'>Upcoming Weather</section>")
			for (var i=0; i<response.daily.data.length; i++){
				$('.weekly_weather').append("<section class='daily_weather'></section>")
				$('.daily_weather').eq(i).append("<section class='daily_hi'> Hi: "+response.daily.data[i].temperatureMax+"</section>");
				$('.daily_weather').eq(i).append("<section class='daily_lo'> Lo: "+response.daily.data[i].temperatureMin+"</section>");
				$('.daily_weather').eq(i).append("<section class='daily_summary'>"+response.daily.data[i].summary+"</section>");
			};
		});
	});
};



// get coordinates from center of map
var getLat = function(map){
	var centerCoords = map.getCenter();
	return centerCoords.lat();
};

var getLng = function(map){
	var centerCoords = map.getCenter();
	return centerCoords.lng();
};


// styling

var enlargeTable = function(){
	$('.details').animate(
	{ height: '35vh'}, 
	{ duration: 500 }
	);
};

var enlargeWeekly = function(){
	$('.weekly_weather').animate(
	{ height: '20vh' },
	{ duration: 500 }
	);
}

// var fadeIn = function(){
// 	$('td').fadeIn("slow", function(){});
// };







// Dark Sky API
// import DarkSkyApi from 'dark-sky-api';
// var DarkSkySpi = require("DarkSkyApi");
// DarkSkyApi.apiKey = ENV["DARK_SKY"];
// DarkSkyApi.initialize();

// current weather
// var getCurrent = function(){
// 	DarkSkyApi.loadCurrent()
// 		.then(result => console.log(result));
// };