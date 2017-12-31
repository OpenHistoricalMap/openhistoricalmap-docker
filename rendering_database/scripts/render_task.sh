#!/bin/bash

# http://www.geofabrik.de/media/2012-09-08-osm2pgsql-performance.pdf

# Name the temporary .osm file
file=/osm_data/$(date +%s).osm

# Log the last run time to a file so we can always find it
date > /last_cron_run

# export the data from the api_db and run it into osm2pgsql, then remove the file
osmosis \
  --replicate-apidb \
    host=postgres \
    user=osm \
    password=osm \
    database=osm  \
    validateSchemaVersion=no \
  --replication-to-change \
  --write-xml-change \
    $file > /osm_data/last_osmosis_run 2>&1 \
  && \
    osm2pgsql \
      --slim \
      --append \
      -U postgres \
      -d gis \
    $file \
  && \
    rm $file
