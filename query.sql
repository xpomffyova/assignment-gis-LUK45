select ST_AsEWKT(way) from planet_osm_point where amenity like 'restaurant' or amenity like 'pub';
select * from planet_osm_point where amenity like 'restaurant' or amenity like 'pub';
select ST_AsText(way) from planet_osm_point where  name like 'Irish pub' and "addr:housenumber" like '736';
select * from planet_osm_point where amenity = 'pub' or amenity = 'restaurant';

select * from planet_osm_point where lower(name) like '%machnáč%';

SELECT name,ST_AsGeoJSON(way) AS geojson
	FROM planet_osm_point
	where amenity like 'restaurant' or amenity like 'pub';


SELECT ST_AsGeoJSON(way) AS geojson
FROM planet_osm_point
where amenity like 'restaurant' or amenity like 'pub';


select row_to_json(rc) from (SELECT name, ST_AsGeoJSON(way) AS geojson
	FROM planet_osm_point
where amenity like 'restaurant' or amenity like 'pub');


SELECT row_to_json(fc)
FROM ( SELECT ST_AsGeoJSON(way) AS geojson
FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub'
) As fc;


SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
    , ST_AsGeoJSON(lg.geog)::json As geometry
    , row_to_json((loc_id, loc_name)) As properties
   FROM locations As lg   ) As f )  As fc;



SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity)) As properties
 FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub' ) As f )  As fc;	

SELECT ST_Distance(gg1,gg2) 


SELECT ST_Distance(gg1, gg2) As spheroid_dist, ST_Distance(gg1, gg2, false) As sphere_dist 
FROM (SELECT
	ST_GeomFromText('POINT(-72.1235 42.3521)',4326), As gg1,
	ST_GeomFromText('POINT(-72.1235 42.3521)',4326),As gg2
	) As foo  ;


select way from planet_osm_point where amenity like 'restaurant' or amenity like 'pub' limit 1;

SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText((select ST_AsText(way) from planet_osm_point where  name like 'Irish pub' and "addr:housenumber" like '736'),4326),26986)
		
	);

SELECT ST_Distance(
		ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),
		ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326)
		
	);
st_distance	


SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity)) As properties
 FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub' ) As f )  As fc;	

SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where amenity = 'restaurant' or amenity = 'pub' ) As f )  As fc;	


SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub' 
 order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))

 ) As f )  As fc;	

create index index_points_amenity on planet_osm_point (amenity);
SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where amenity =  'restaurant' or amenity  = 'pub' order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) As f )  As fc;	

 
 //// totoo je aktualny dobry ... treba len za json pridat as geometry
SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub' order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) As f )  As fc;	

"addr:housename" name operator 

select * from planet_osm_point
where lower(name) like '%irish%'
or lower(operator) like '%irish%'

select * from planet_osm_point
where to_tsvector('simple', name || ' ' || operator ) @@ to_tsquery('simple', 'irish');


select * from planet_osm_point
where to_tsvector('simple', name || ' ' || operator ) @@ to_tsquery('simple', 'irish');

SELECT id, meta->>'name' as name, meta FROM (
  SELECT id, meta, tsv
  FROM data_rows, plainto_tsquery('irish') AS q
  WHERE (tsv @@ q)
) AS t1 ORDER BY ts_rank_cd(t1.tsv, plainto_tsquery('irish')) DESC LIMIT 5;

create index index_points_amenity on planet_osm_point (amenity);

select ts_rank_cd(to_tsvector(name || ' ' || operator || ' ' || "addr:housename"), to_tsquery('irish')) rank, * from planet_osm_point
where to_tsvector(name || ' ' || operator || ' ' || "addr:housename") @@ to_tsquery('irish')
order by rank desc;


create extension unaccent;
create text search configuration sk(copy = simple);
alter text search configuration sk alter mapping for word with unaccent, simple;
create index index_contracts_ft on planet_osm_point using gin(to_tsvector('sk', name ))


select * from planet_osm_point where amenity = 'restaurant' or amenity = 'pub'
and to_tsvector('sk', name ) @@ to_tsquery('sk', 'jedalen');

select ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', 'jedalen')) rank, * from planet_osm_point 
where to_tsvector('sk', name ) @@ to_tsquery('sk', 'jedalen')
order by rank desc;



/////search name
SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM (select ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', 'machnac')) rank, * from planet_osm_point 
where (amenity like 'restaurant' or amenity like 'pub') and to_tsvector('sk', name ) @@ to_tsquery('sk', 'machnac')
order by rank desc) as foo  order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) As f )  As fc;


		SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM (select ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', 'jedalen')) rank, * from planet_osm_point 
where to_tsvector('sk', name ) @@ to_tsquery('sk', 'jedalen')
order by rank desc) as foo order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))


/////search dist
SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where (amenity like 'restaurant' or amenity like 'pub' )and (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		)) < 1 order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) As f )  As fc;


(SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM planet_osm_point where ( amenity like 'restaurant' or amenity like 'pub') and (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		)) < 1000 order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) 



		SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
 FROM (SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM (select ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', 'machnac')) rank, * from planet_osm_point 
where to_tsvector('sk', name ) @@ to_tsquery('sk', 'machnac')
order by rank desc) as foo  order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))) As f )  As fc;



		SELECT 'Feature' As type
 , ST_AsGeoJSON(way)::json 
    , row_to_json((osm_id,name,"addr:housename",amenity,(SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))
		)) As properties
 FROM (select ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', 'machnac')) rank, * from planet_osm_point 
where (amenity like 'restaurant' or amenity like 'pub') and to_tsvector('sk', name ) @@ to_tsquery('sk', 'machnac')
order by rank desc) as foo order by (SELECT ST_Distance(
		ST_Transform(ST_GeomFromText('POINT(17.1296604 48.172398099999995)',4326),26986),
		ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986)
		))

		