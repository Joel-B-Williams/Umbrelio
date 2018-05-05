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

// $(document).ready(function(){
// 	initMap();
// 	google.charts.load('current', {'packages':['corechart']});
// });

// $(document).on("pageshow", '#map', function(){
// 	initMap();
// 	google.charts.load('current', {'packages':['corechart']});
// });

document.addEventListener('turbolinks:load', function(){
	initMap();
	google.charts.load('current', {'packages':['corechart']});	
})

// create map with searchbox
var initMap = function(){
	// createMap(); 
	var map = new google.maps.Map(document.getElementById('map'), {
		// hardcode Chicago for now as default
		center: {lat:41.875586, lng:-87.627105},
		zoom: 4
	});
	
	addSearchBox(map);
  getLocation(map);
	getForecast(map);
};


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
	$('.forecast_form').on('submit', function(e){
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
		
console.log('pushed')
		$.ajax({
			url: url,
			method: method,
			data: data
		})
		.done(function(response){
			enlargeTable();
			enlargeWeekly();
			enlargePast();
			scrollToTop();
	
			$('.temperature').html(response.currently.temperature);
			$('.humidity').html(response.currently.humidity);
			$('.feels_like').html(response.currently.apparentTemperature);
			$('.summary').html(response.currently.summary);
			$('.weekly_weather').html('');
			$('.weekly_weather').append("<section class='glance'>Upcoming Weather</section>");
			for (var i=0; i<response.daily.data.length; i++){
				$('.weekly_weather').append("<section class='daily_weather'></section>");
				$('.daily_weather').eq(i).append("<section class='daily_hi'> Hi: "+response.daily.data[i].temperatureMax+"</section>");
				$('.daily_weather').eq(i).append("<section class='daily_lo'> Lo: "+response.daily.data[i].temperatureMin+"</section>");
				$('.daily_weather').eq(i).append("<section class='daily_summary'>"+response.daily.data[i].summary+"</section>");
			};

			// drawChart(response);

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
	{ height: '20vh'}, 
	{ duration: 1000 }
	);
};

var enlargeWeekly = function(){
	$('.weekly_weather').animate(
	{ height: '20vh' },
	{ duration: 1000 }
	);
}

var enlargePast = function(){
	$('#past_weather').animate(
	{ height: '35vh' },
	{ duration: 1000 }
	);
}

// draw chart pulled from past data

// var drawChart = function(response){
// 	var data = google.visualization.arrayToDataTable([
// 		['Last Week', response.days_ago_7.temperatureMin, response.days_ago_7.temperatureMin, response.days_ago_7.temperatureMax, response.days_ago_7.temperatureMax],
// 		['', response.days_ago_6.temperatureMin, response.days_ago_6.temperatureMin, response.days_ago_6.temperatureMax, response.days_ago_6.temperatureMax],
// 		['', response.days_ago_5.temperatureMin, response.days_ago_5.temperatureMin, response.days_ago_5.temperatureMax, response.days_ago_5.temperatureMax],
// 		['', response.days_ago_4.temperatureMin, response.days_ago_4.temperatureMin, response.days_ago_4.temperatureMax, response.days_ago_4.temperatureMax],
// 		['', response.days_ago_3.temperatureMin, response.days_ago_3.temperatureMin, response.days_ago_3.temperatureMax, response.days_ago_3.temperatureMax],
// 		['', response.days_ago_2.temperatureMin, response.days_ago_2.temperatureMin, response.days_ago_2.temperatureMax, response.days_ago_2.temperatureMax],
// 		['Yesterday', response.days_ago_1.temperatureMin, response.days_ago_1.temperatureMin, response.days_ago_1.temperatureMax, response.days_ago_1.temperatureMax]
// 		], true);

// 	var options = { 
// 		legend: 'none',
// 		colors: ['#1a778c'],
// 		fontName: 'helvetica',
// 		title: 'Past week daily hi/lo',
// 		titleTextStyle: {
// 			fontName: 'helvetica',
// 			italic: true,
// 			fontSize: 18
// 		}
// 		// bar: {groupWidth: '100%' }
// 		 };

// 	var chart = new google.visualization.CandlestickChart(document.getElementById('past_weather'));

// 	chart.draw(data, options);

// };

var scrollToTop = function(){
	$('body').animate({ 
		scrollTop: 0 },
		'slow' 
	);
};