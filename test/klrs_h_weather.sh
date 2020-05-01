#!/bin/bash
set -e

# This is a very simple bash script for testing the command line
# interface with a local SensorThings API server.

SCRIPT=transload
PROVIDER="klrs_h_weather"
STATION_ID="KLRS_5264"
DATASTORE="datastore/weather"
DESTINATION="http://192.168.33.77:8080/FROST-Server/v1.0/"

# KLRS Historical Weather Dadta Test Run
ruby $SCRIPT get metadata \
    --provider $PROVIDER \
    --station_id $STATION_ID \
    --data_path "tmp/klrs-weather/2012/September/TOA5_5264.FiveMin.dat" \
    --data_path "tmp/klrs-weather/2013/July/TOA5_5264.FiveMin.dat" \
    --cache $DATASTORE \
    --overwrite

ruby $SCRIPT put metadata \
    --provider $PROVIDER \
    --station_id $STATION_ID \
    --cache $DATASTORE \
    --destination $DESTINATION

ruby $SCRIPT get observations \
    --provider $PROVIDER \
    --station_id $STATION_ID \
    --cache $DATASTORE

# Upload partial 2012 observations only to save time (approx 4600).
# (For a local SensorThings API instance, 250,000 observations takes 
# about 45 minutes to upload.)
ruby $SCRIPT put observations \
    --provider $PROVIDER \
    --station_id $STATION_ID \
    --cache $DATASTORE \
    --date "2012-08-01T00:00:00Z/2012-08-07T00:00:00Z" \
    --destination $DESTINATION
