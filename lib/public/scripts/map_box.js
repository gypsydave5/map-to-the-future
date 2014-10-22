var createTabs = function(properties) {
  var source = $("#popup-template").html();
  var template = Handlebars.compile(source);
  var context = properties;
  var dateHelper = new Date(Date.parse(context.startdate));
  context.date = "" + dateHelper.getDate() + " " + month[dateHelper.getMonth()] + " " + dateHelper.getFullYear();
  var html = template(properties);
  console.log(properties.links[0]);
  return html;
}

var month = new Array();
month[0] = "January";
month[1] = "February";
month[2] = "March";
month[3] = "April";
month[4] = "May";
month[5] = "June";
month[6] = "July";
month[7] = "August";
month[8] = "September";
month[9] = "October";
month[10] = "November";
month[11] = "December";

$("#map").on('click', '.linked-event', function(){
  var year = $(this).data("year");
  var event_id = $(this).data("id");
  $("#slider").slider("value", year);
  getMapData("year", year, eventLayer, function(){
    eventLayer.eachLayer(function(marker){
      if (marker.feature.properties.id === event_id) {
        map.panTo(marker.getLatLng());
        marker.openPopup();
      };
    });
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
        marker.setIcon(L.mapbox.marker.icon({
            'marker-color': '#e69524',
            'marker-size': 'medium'
        }));
        eventLayer.on('mouseover', function(marker) {
            marker.layer.openPopup();
        });
        eventLayer.on('click', function(marker) {
            marker.layer.closePopup();
        });
      });
        transitionTo(event)

      callback();
     },
  })
}

var transitionTo = function(event) {
  eventLayer.on('click', function(event){
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
  "pk.eyJ1IjoiZ3lwc3lkYXZlNSIsImEiOiJJLVNiRHpvIn0.w6LHnjmmQ_irxtmZfZlgUA"

var mapOptions = {
         minZoom: 2,
         maxZoom: 10,
         maxBounds: [[-90.0,-180.0],[90.0,180.0]]
}
var map = L.mapbox.map('map', 'gypsydave5.aad99df8', mapOptions);

var eventLayer = L.mapbox.featureLayer();
