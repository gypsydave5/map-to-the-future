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
      if (marker.feature.properties.id === event_id) {
        map.panTo(marker.getLatLng());
        marker.openPopup();
        marker.openPopup();

        console.log(marker.getLatLng());
      };
    });
    return "Banana"
  });
})

$("#map").on('ready', function(layer) {
        this.eachLayer(function(marker) {
          marker.setIcon(L.mapbox.marker.icon({
              'marker-color': '#ff8888',
              'marker-size': 'large'
          }))
        };

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
        transitionTo(event)

      callback();
      //map.fitBounds(eventLayer.getBounds(), {maxZoom: 5});
    },
  //complete: function() { console.log(callback ? callback() : "nope") }
  })
}

var transitionTo = function(event) {
  eventLayer.on('click', function(event){
    console.log(map.getZoom());
    if (map.getZoom() > 4) {
         map.panTo(event.layer.getLatLng());
      } else {
        map.setZoom(4, {animate: false}).whenReady(
          map.panTo(event.layer.getLatLng())
          );
       
      }
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
