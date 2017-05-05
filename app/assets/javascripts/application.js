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
	getForecast();
});

// create map with searchbox
var initMap = function(){
	var map = new google.maps.Map(document.getElementById('map'), {
		// hardcode Chicago for now
		center: {lat:41.875586, lng:-87.627105},
		zoom: 4
	});
	// createSearchBox(map);
	var pageDiv = document.getElementById('searchbox');
	var searchBox = new google.maps.places.Autocomplete(pageDiv, {types: ['(cities)']});
	map.controls[google.maps.ControlPosition.TOP].push(pageDiv);

 // Bias the SearchBox results towards current map's viewport.
  map.addListener('bounds_changed', function() {
    searchBox.setBounds(map.getBounds());
  });

  getLocation(map);
	chooseLocation(map, searchBox);
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
	 console.log('poop')
	 console.log(place)
		map.setCenter(place.geometry.location);
		
	});
};
// var createSearchBox = function(mapToJoin){
// 	var boxPlacement = document.getElementById('searchbox');
// 	var searchBox = new google.maps.places.SearchBox(boxPlacement);
// 	mapToJoin.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
// 	// Bias the SearchBox results towards current map's viewport.
//   mapToJoin.addListener('bounds_changed', function() {
//     searchBox.setBounds(mapToJoin.getBounds());
// 	});
// };

// hardcode Chicago for now
var getForecast = function(){
	$('.forecast-button').on('click', function(e){
		e.preventDefault();
		var $this = $(this);

		var baseUrl = $this.attr('href');
		// var key = FIND IN ENV FILE;
		var coords = '41.875586,-87.627105';
		var url = baseUrl+key+'/'+coords
		
		$.ajax({
			url
		})
		.done(function(response){
			console.log(response)
		});

	});
};







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