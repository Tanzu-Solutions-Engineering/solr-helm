FROM solr:7.6

MAINTAINER Li Wang <liwang@pivotal.io>

USER root

# Init solr home
ENV INIT_SOLR_HOME "yes"
ENV SOLR_HOME /pivotal/solr-home

# Replace default "solrconfig.xml"
RUN rm -rf /opt/solr/server/solr/configsets/_default/conf/solrconfig.xml
COPY initdb.d/solrconfig.xml /opt/solr/server/solr/configsets/_default/conf/solrconfig.xml

# Install the initialisation scripts
COPY initdb.d/create-cores.sh /docker-entrypoint-initdb.d/
COPY initdb.d/update-solr-in.sh /docker-entrypoint-initdb.d/

# Revert to the solr user
USER 8983
