var createTabs = function(properties) {
  //var tabs = document.createElement('div');
  //tabs.className = 'tabs-ui';
  //var titleTab = document.createElement('div');
  //titleTab.className = 'tab';

  //var input = document.createElement('input');
  //input.type = 'radio';
  //input.id = 'title';
  //input.name = 'tab-group';
  //input.setAttribute('checked', true);
  //titleTab.appendChild(input);

  //titleTab.innerHTML += "<label for='title'>Event</label>" +
    //"<div class='content'>" +
    //"<h1>" + properties.title + "</h1>" +
    //"<h2>" + properties.startdate + "</h2>" +
    //"<p>" + properties.description + "</p>" +
    //"</div>";

  //tabs.appendChild(titleTab);

  //var linkedEventsTab = document.createElement('div');
  //linkedEventsTab.className = 'tab';

  //var input = document.createElement('input');
  //input.type = 'radio';
  //input.id = 'linked-events';
  //input.name = 'tab-group';
  //linkedEventsTab.appendChild(input);

  //linkedEventsTab.innerHTML += "<label for='linked-events'>Linked Events</label>" +
    //"<div class='content'>" +
    //"<h1>" + properties.tags + "</h1>" +
    //"<h1>" + properties.events + "</h1>" +
    //"</div>";

  //tabs.appendChild(linkedEventsTab);
  //return tabs;
  var source = $("#popup-template").html();
  var template = Handlebars.compile(source);
  var context = properties;
  var html = template(context);
  return html;
}

var getMapData = function(timescale, date, mapLayer){
            $.ajax({
                url: "events/" + timescale + "/" + date,
                beforeSend: function(){mapLayer.clearLayers();}
              }).done(function(geojson){
                var features = JSON.parse(geojson);
                eventLayer = L.mapbox.featureLayer(features).addTo(map);
                eventLayer.eachLayer(function (marker){
                  marker.bindPopup( createTabs(marker.feature.properties)  );
                })
            });
}

L.mapbox.accessToken = "pk.eyJ1IjoiZ3lwc3lkYXZlNSIsImEiOiIxTmJIeHJNIn0.a1tH004BEEbTs0k5UhIF0Q";
var mapOptions = {
         minZoom: 2,
         maxZoom: 10,
         maxBounds: [[-90.0,-180.0],[90.0,180.0]]
}
var map = L.mapbox.map('map', 'gypsydave5.jnnf7a4f', mapOptions);

var eventLayer = L.mapbox.featureLayer()
