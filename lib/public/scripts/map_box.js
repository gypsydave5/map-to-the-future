var createTabs = function(properties) {
  var source = $("#popup-template").html();
  var template = Handlebars.compile(source);
  var context = properties;
  var html = template(context);
  return html;
}

var getMapData = function(timescale, date, mapLayer, callback){
            $.ajax({
                url: "events/" + timescale + "/" + date,
                beforeSend: function(){mapLayer.clearLayers();}
              }).done(function(geojson){
                var features = JSON.parse(geojson);
                eventLayer = L.mapbox.featureLayer(features).addTo(map);
                eventLayer.eachLayer(function (marker){
                  marker.bindPopup( createTabs(marker.feature.properties),
                  {
                    keepInView: true,
                    autoPan: false,
                    closeButton: false
                  }
                  );
                });
                eventLayer.on('click', function(event){
                  map.setZoom(5).panTo(event.layer.getLatLng());
                });
                map.fitBounds(eventLayer.getBounds(), {maxZoom: 5});
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
