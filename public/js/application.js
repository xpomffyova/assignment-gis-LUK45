L.mapbox.accessToken = 'pk.eyJ1IjoibHVrNDUiLCJhIjoiY2lnM21kdm4xMDJsM3Zua2hqczJ1ZTQ1NyJ9.sSsOgeUmoQmc3q4K5_VEIw';
var user_long;
var user_lat;
map = L.mapbox.map('map', 'luk45.a7f41a86')
  .setView([48.149784, 17.120030], 13);
locations = new L.LayerGroup();  
geolocate = document.getElementById('geolocate');
myLayer = L.mapbox.featureLayer().addTo(map);
    
if (!navigator.geolocation) {
 geolocate.innerHTML = 'Geolocation is not available';
 } else {
    geolocate.onclick = function (e) {
    e.preventDefault();
    e.stopPropagation();
    map.locate();
    };

}
map.on('locationfound', function(e) {
  // map.fitBounds(e.bounds);
  map.setView([e.latlng.lat, e.latlng.lng], 15);
  some_data = e.latlng;
  $.post("/generator", {"lng":e.latlng.lng, "lat":e.latlng.lat, "search_name":$("input[name='search_name']").val(), "search_dist":$("input[name='search_dist']").val()})
  .done(function(string) {
              distance_geojson = jQuery.parseJSON(string);

    var listings = document.getElementById('listings');
    while (listings.firstChild) {
        listings.removeChild(listings.firstChild);
      }

      // locations = L.mapbox.featureLayer().addTo(map);
      
    locations.clearLayers();
    locations = L.mapbox.featureLayer().addTo(map);
    locations.setGeoJSON(distance_geojson);
    function setActive(el) {
      var siblings = listings.getElementsByTagName('div');
      for (var i = 0; i < siblings.length; i++) {
        siblings[i].className = siblings[i].className
        .replace(/active/, '').replace(/\s\s*$/, '');
      }

      el.className += ' active';
    }

    locations.eachLayer(function(locale) {
      var prop = locale.feature.properties;
      if (prop.f2) {
          var popup = '<h3>' + prop.f2 +'</h3><div>' ;
      }
      else{
          var popup = '<h3><i>unknown name</i></h3><div>' ;
      }
      var listing = listings.appendChild(document.createElement('div'));
      listing.className = 'item';

      var link = listing.appendChild(document.createElement('a'));
      link.href = '#';
      link.className = 'title';
          
      if (prop.f2) {
          link.innerHTML = prop.f2;
      }
      else{
          link.innerHTML = "unknown name";
      }

      var details = listing.appendChild(document.createElement('div'));
      details.innerHTML = prop.f5;
      // details.innerHTML += ' &middot; ' + prop.f1;
      if (prop.f3) {
      details.innerHTML += ' &middot; ' + prop.f3;
      }

      if (prop.f4) {
        details.innerHTML += ' &middot; ' + prop.f4;
      }
       details.innerHTML += ' &middot; ' + parseFloat(prop.f6 / 1000).toFixed(2) + " km";
      link.onclick = function() {
        setActive(listing);
        map.setView(locale.getLatLng(), 16);
        locale.openPopup();
        return false;
      };

      locale.on('click', function(e) {
        map.panTo(locale.getLatLng());
        setActive(listing);
      });

      popup += parseFloat(prop.f6 / 1000).toFixed(2) + " km" + '</div>';
      locale.bindPopup(popup);
      dist_fl = parseFloat(prop.f6 / 1000);

      if(prop.f5 == "pub")
      {
        if(dist_fl < 1) { iconUrls = '/static/icon/bar1.png' }
        else if( dist_fl<= 4) { iconUrls = '/static/icon/bar2.png' }
        else {iconUrls = '/static/icon/bar3.png' }
        locale.setIcon(L.icon({
        iconUrl: iconUrls,
        iconSize: [33, 33],
        iconAnchor: [28, 28],
        popupAnchor: [0, -34]
      }));
      }
      else{
        if(dist_fl < 1) { iconUrls = '/static/icon/restaurant1.png' }
        else if( dist_fl<= 4) { iconUrls = '/static/icon/restaurant2.png' }
        else {iconUrls = '/static/icon/restaurant3.png' } 
        locale.setIcon(L.icon({
        iconUrl: iconUrls,
        iconSize: [33, 33],
        iconAnchor: [28, 28],
        popupAnchor: [0, -34]
      }));
      }

    });
       
    myLayer.setGeoJSON({
      type: 'Feature',
      geometry: {
          type: 'Point',
          coordinates: [e.latlng.lng, e.latlng.lat]
      },
      properties: {
          'title': 'Here I am!',
          'marker-color': '#ff8888',
          'marker-symbol': 'star'
      }
    }) ;

  }, "json");     /////toto som sem odpalil az 


});


     
 
