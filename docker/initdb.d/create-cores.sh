#!/bin/bash

set -eo pipefail

# Create test cores
TEST_CORES=( "test" )
for corename in "${TEST_CORES[@]}"; do
    coredir="${SOLR_HOME:-/opt/solr/server/solr}/$corename"
    
    # Create the core directory if it doesn't already exist
    if [ ! -f "$coredir/core.properties" ]; then
        mkdir -p "$coredir"
        touch "$coredir/core.properties"
    fi
    
    rm -rf "$coredir/conf"
    cp -r /opt/solr/server/solr/configsets/_default/conf/ "$coredir/conf"
done
