#!/bin/bash

set -u
set -e

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MY_JAR="twitter-consumer-1.0-SNAPSHOT.jar"
JARS=""

#apt-get update
#apt-get -y install python-pip
#pip install cqlsh==5.0.4
echo "INSERT INTO twitter_sentiment.movies (title, rating, release) VALUES ('${MOVIE_NAME}', ${MOVIE_IMDB}, '${MOVIE_DATE}');"

echo "INSERT INTO twitter_sentiment.movies (title, rating, release) VALUES ('${MOVIE_NAME}', ${MOVIE_IMDB}, '${MOVIE_DATE}');" | cqlsh ${CASSANDRA_HOST} ${CASSANDRA_PORT} --cqlversion="3.3"

for i in ${MY_DIR}/lib/*.jar; do
    JARS=$(echo "${i}":${JARS})
done
JARS="$JARS:${MY_DIR}/${MY_JAR}"

$JAVA_HOME/bin/java -cp "${JARS}" \
     -Dlog4j.configuration="file://${MY_DIR}/log4j.properties" \
     com.griddynamics.blueprint.streaming.twitter.Main \
     --config "${MY_DIR}/application.conf" \
     "$@"
