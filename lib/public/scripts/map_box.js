var createTabs = function(properties) {
  var source = $("#popup-template").html();
  var template = Handlebars.compile(source);
  var context = properties;
  var html = template(context);
  return html;
}


$("#map").on('click', '.linked-event', function(){
  var year = $(this).data("year");
  var event_id = $(this).data("id");
  $("#slider").slider("value", year);
  getMapData("year", year, eventLayer, function(){
    eventLayer.eachLayer(function(marker){
      console.log("hello markerrrr")
      if (marker.feature.properties.id === event_id) {
        map.panTo(marker.getLatLng());
        marker.openPopup();
        console.log(marker.getLatLng());
      };
    });
    return "Banana"
  });
})

var getMapData = function(timescale, date, mapLayer, callback){
  $.ajax({
    url: ("events/" + timescale + "/" + date),
    beforeSend: function(){mapLayer.clearLayers();},
    success: function(geojson){
      var features = JSON.parse(geojson);
      eventLayer = L.mapbox.featureLayer(features).addTo(map);
      eventLayer.eachLayer(function(marker){
        marker.bindPopup( createTabs(marker.feature.properties),
          {
            autoPan: false,
            closeButton: false
          }
        );
      });
        transitionSmoothly(event)

      callback();
      //map.fitBounds(eventLayer.getBounds(), {maxZoom: 5});
    },
  //complete: function() { console.log(callback ? callback() : "nope") }
  })
}

var transitionTo = function(event) {
  eventLayer.on('click', function(event){
      map.setZoom(4);
      setTimeout( function() {
        map.panTo(event.layer.getLatLng());
      setTimeout( function() {
        map.setZoom(7);
      }, 350);
    }, 350);
  });
}

var transitionSmoothly = function(event) {
   eventLayer.on('click', function(event){
      map.setZoom(1);
      setTimeout( function() {
        map.panTo(event.layer.getLatLng());
      setTimeout( function() {
        map.setZoom(2);
      setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        setTimeout( function() {
        map.setZoom(3);
        setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        setTimeout( function() {
        map.setZoom(4);
        setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        setTimeout( function() {
        map.setZoom(5);
        setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        setTimeout( function() {
        map.setZoom(6);
        setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        setTimeout( function() {
        map.setZoom(7);
        setTimeout( function() {
        map.panTo(event.layer.getLatLng());
        }, 550);
        }, 250);
        }, 550);
        }, 250);
        }, 550);
        }, 250);
        }, 550);
        }, 250);
        }, 550);
        }, 250);
        }, 550);
        }, 250);
    }, 550);
  });
}




L.mapbox.accessToken =
  "pk.eyJ1IjoiZ3lwc3lkYXZlNSIsImEiOiIxTmJIeHJNIn0.a1tH004BEEbTs0k5UhIF0Q";

var mapOptions = {
         minZoom: 2,
         maxZoom: 10,
         maxBounds: [[-90.0,-180.0],[90.0,180.0]]
}
var map = L.mapbox.map('map', 'gypsydave5.jnnf7a4f', mapOptions);

var eventLayer = L.mapbox.featureLayer();
