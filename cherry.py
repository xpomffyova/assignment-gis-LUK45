import os, os.path
import random
import string
import cherrypy
import psycopg2
import sys
import pprint
import json

cherrypy.config.update({'server.socket_port': 8090})
cherrypy.engine.restart()
conn_string = "host='192.168.99.100' dbname='postgres' user='postgres'"
print "Connecting to database\n ->%s" % (conn_string)
conn = psycopg2.connect(conn_string)
cursor = conn.cursor()
print "Connected!\n"

class DataGenerator(object):
    @cherrypy.expose
    def index(self):
            # alert("index!")
            return open('index.html')

class DataGeneratorWebService(object):
    exposed = True
    @cherrypy.tools.accept(media='text/plain')

    def GET(self):
        cursor.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity)) As properties FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub'   ) As f )  As fc; ")
        
        first = True

            # Vytvaranie JSONa
        for record in cursor:
            # print record
            # print "NEXT"
            if first == True:
                finalJson = json.dumps(record)
                # print finalJson
                first = False
            else:
                finalJson = finalJson.concat(json.dumps(record))

        # print finalJson 
        print "returnujem"       
        return finalJson    
        # return records


    def POST(self, lng, lat, search_name, search_dist):
        # print lng
        # print lat
        # print search_name
        # print search_dist
        if search_dist != "":  
            search_dist = str(float(search_dist) * 1000)
        

        if search_name != "" and search_dist != "":
            print "kombinacia"
            cursor.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM planet_osm_point where (amenity like 'restaurant' or amenity like 'pub') and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) < "+search_dist+"  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; ")
            
        elif search_name != "":
            print "meno"
            cursor.execute("select * from planet_osm_point where amenity = 'restaurant' or amenity = 'pub' and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"');")
            cursor.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM (SELECT ts_rank_cd(to_tsvector('sk', name ), to_tsquery('sk', '"+search_name+"')) rank, * from planet_osm_point where  (amenity like 'restaurant' or amenity like 'pub') and to_tsvector('sk', name ) @@ to_tsquery('sk', '"+search_name+"') order by rank desc) as foo  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; ")
        
        elif search_dist != "":
            print "vzdialenost"
            cursor.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM planet_osm_point where (amenity like 'restaurant' or amenity like 'pub') and (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) < "+search_dist+"  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; ")
             
        else:
            print "nic" 
            cursor.execute("SELECT row_to_json(fc) FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type , ST_AsGeoJSON(way)::json As geometry, row_to_json((osm_id,name,"'"addr:housename"'","'"addr:housenumber"'",amenity,(SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))))) As properties FROM planet_osm_point where amenity like 'restaurant' or amenity like 'pub'  order by (SELECT ST_Distance(ST_Transform(ST_GeomFromText('POINT(" + lng + " " + lat + ")',4326),26986),ST_Transform(ST_GeomFromText(ST_AsText(way) ,4326),26986))) ) As f )  As fc; ")
                   



        first = True
        # count = 0
            # Vytvaranie JSONa
        for record in cursor:
            if first == True:
                finalJson = json.dumps(record)
                # print finalJson
                first = False
            else:
                finalJson = finalJson.concat(json.dumps(record))

        # print finalJson 
        # print count
        print "returnujem"       
        return finalJson   

    
 
if __name__ == "__main__":
    conf = {
         '/': {
             'tools.sessions.on': True,
             'tools.staticdir.root': os.path.abspath(os.getcwd())
         },
         '/generator': {
             'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
             'tools.response_headers.on': True,
             'tools.response_headers.headers': [('Content-Type', 'text/plain')],
         },
         '/static': {
             'tools.staticdir.on': True,
             'tools.staticdir.dir': './public'
         }

     }

webapp = DataGenerator()
webapp.generator = DataGeneratorWebService()
cherrypy.quickstart(webapp, '/', conf)     


