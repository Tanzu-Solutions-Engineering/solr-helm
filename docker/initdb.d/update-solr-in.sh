#!/bin/bash

set -eu

#####
# This script updates solr.in.sh with the required variables
#####

SOLR_IN_SH=/opt/solr/bin/solr.in.sh

echo "[INFO] Writing Solr configuration to ${SOLR_IN_SH}"

# If SOLR_HEAP is not set, use a 1GB heap
echo "SOLR_HEAP=\"${SOLR_HEAP:-"1g"}\"" | tee -a "$SOLR_IN_SH"

# Set Java properties
# Role is either master or replica, default replica
case "$SOLR_ROLE" in
    "master")
        # Enable master only
        echo 'SOLR_OPTS="$SOLR_OPTS -Denable.master=true -Denable.slave=false"' | tee -a "$SOLR_IN_SH"
        ;;
    "slave")
        # Slave nodes have only slave enabled
        # They also need a master URL (required) and a replication interval (default 20 secs)
        cat <<EOF | tee -a "$SOLR_IN_SH"
SOLR_OPTS="\$SOLR_OPTS -Denable.master=false -Denable.slave=true"
SOLR_OPTS="\$SOLR_OPTS -Dsolr.master.url=$SOLR_MASTER_URL"
SOLR_OPTS="\$SOLR_OPTS -Dsolr.core.name=test"
SOLR_OPTS="\$SOLR_OPTS -Dsolr.replication.interval=${SOLR_REPLICATION_INTERVAL:-"00:00:20"}"
EOF
        ;;
    *)
        echo "[ERROR] Unknown SOLR_ROLE: $SOLR_ROLE" 1>&2
        exit 1
esac
