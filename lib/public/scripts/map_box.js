var createTabs = function(properties) {
  var source = $("#popup-template").html();
  var template = Handlebars.compile(source);
  var context = properties;
  var dateHelper = new Date(Date.parse(context.startdate));
  context.date = "" + dateHelper.getDate() + " " + month[dateHelper.getMonth()] + " " + dateHelper.getFullYear();
  var html = template(properties);
  return html;
}

var createSidebar = function(properties) {
  var source = $("#sidebar-template").html();
  var template = Handlebars.compile(source);
  var context = "Muell";
  var html = context;
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

$("#map").on('click', '.sidebar-caller', function(){
  var event_id = $(this).data('id');
  eventLayer.eachLayer(function(marker) {
    console.log(event_id)
    if (marker.feature.properties.id === event_id) {
      var sidebar_text = marker.feature.properties.description
    console.log(sidebar_text)
      sidebar_text = '<p>' + sidebar_text.replace(/(\r\n\r\n)/g, '</p><p>')
                  + '</p>';
    console.log(sidebar_text)
      $('#sidebar').html(sidebar_text);
      sidebar.show();
      }
  });
});

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
        });
       transitionTo()
     if (callback){callback()};
     },
  })
}

var transitionTo = function() {
  map.on('popupopen', function(event){
    var px = map.project(event.popup._latlng);
    if (map.getZoom() > 4) {
          px.y -= event.popup._container.clientHeight/1.5;
          map.panTo(map.unproject(px),{animate: true});
      } else {
            px.y -= event.popup._container.clientHeight/1.5;
            map.panTo(map.unproject(px),{animate: true});
    }
  });
}

L.mapbox.accessToken =
  "pk.eyJ1IjoiZ3lwc3lkYXZlNSIsImEiOiJJLVNiRHpvIn0.w6LHnjmmQ_irxtmZfZlgUA";

var mapOptions = {
  attributionControl: false,
  minZoom: 2,
  maxZoom: 10,
  maxBounds: [[-90.0,-180.0],[90.0,180.0]]
};

var map = L.mapbox.map('map', 'gypsydave5.aad99df8', mapOptions);

var eventLayer = L.mapbox.featureLayer();
