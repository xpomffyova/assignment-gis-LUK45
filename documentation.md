# Prehľad

Táto aplikácia zobrazuje na mape reštaurácie a krčmy na Slovensku.
Umožnuje:
* zobraziť tie v blízkosti aktuálnej polohy používateľa
* vyhľadať podla vzdialenosti
* vyhľadať podla názvu - full text search
* zoradiť podla vzdialenosti 
* farebne odlíšiť podla druhu (reštaurácia / krčma) a podla vzdialenosti od používateľovej polohy

Takto to vyzerá v akcii:

![Screenshot](screenshot.png)

Aplikácia je zložená z dvoch častí. [Frontend](#frontend), ktorý využíva mapbox API, mapbox.js, html a css a [backend](#backend), ktorý je napísaný v Python-e s použitím frameworku [CherryPy](#http://cherrypy.org) a ďalej komunikuje s PostGIS-om. Frontend a backend komunikujú pomocou RestAPI.	

# Frontend

Frontend je staticka HTML stránka (`index.html`). Zobrazuje mapu a bočný panel. Mapa je mierne upravená v mapbox studiu. Je farebne upravená, aby nezobrazovala zbytočne veľa informácii irelevantných pre toto použitie. Naopak, zvýraznené sú všetky cesty, názvy miest a ich častí a po priblížení aj názvy ulíc. V hornej časti bočného panelu je ovládací panel. Po kliknutí na tlačidlo "Find", aplikácia získa polohu používateľa, zobrazí ju na mape spolu so všetkými krčmami a reštauráciami, pričom ich do bočného panelu vypíše a usporiada podľa vzdialenosti do používateľa vzostupne. Používateľ má možnosť do vyhľadávacich polí zadať meno alebo maximálnu vzdialenosť a aplikácia zobrazí len výsledky vyhovujúce jeho zadaniu.

Dôležitý kód je v súbore /public/js/application.js. Vykonáva sa v ňom komunikácia s backendom, a spracovanie prijatých dát, ktoré prijíma z backendu vo forme JSONu resp geoJSONu. Prijaté dáta zobrazí do mapy a bočného panelu. Lokalizuje sa tu používateľ pomocou štandardného webového [API](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/Using_geolocation)


# Backend

Backend je napísaný v Pythone pomocou frameworku [CherryPy](#http://cherrypy.org). Dopytuje geo dáta a posiela geojson na frontend.

## Data

Dáta sú z Open Street Maps. Stiahnuté je celé Slovensko a pomocou osm2pgsql naimportované do databázy. Za účelom zrýchlenia dotazov je vytvorený index na sĺpci amenity, keďže sú z databázy vyberané iba riadky, ktorých amenity je buď "restaurant", alebo "pub". Geojson je gengerovaný pomocou funkcie st_asgeojson a všetky riadky sú spojené priamo v databáze do jedného geojsonu. Pre vyhľadávanie podla mena sa robí fulltext search s použitím funkcii to_tsvector, ts_rank_cd, to_tsquery a indexom nad stĺpcom "name". 


## Api

Využívajú sa dotazy POST vo formate JSON. 

**Všetky reštaurácie a krčmy a zoradené podla vzdialenosti od používateľovej polohy**

`POST /generator?lng=xxxx&lat=yyyy`
  
**Nájsť reštaurácie a krčmy podla mena,usporiadané podla vzdialenosti**

`POST /generator?lng=xxxx&lat=yyyy&search_name=xxx`

**Nájsť reštaurácie a krčmy do maximálnej vzdialenosti**

`POST /generator?lng=xxxx&lat=yyyy&search_dist=xxx`

### Response

API vracia gejson, ktorý obsahuje "geometry" a "properties" pre každú nájdenú položku vyhovujúcu podmienkam.
Properties obsahujú položky:
* id
* meno 
* adresa - väčšina záznamov nemá adresu zadanú
* typ
* vzdialenost

```
{
	"type": "Feature",
	"properties": {
		"f1": 3327435719, 
		"f2": "GOLF PUB", 
		"f3": null, 
		"f4": null, 
		"f5": "restaurant",
		"f6": 269755.604842372
	}}, {
	"geometry": {
		"type": "Point", 
		"coordinates": [20.5755175, 48.9335478]
	}, 

}

```

