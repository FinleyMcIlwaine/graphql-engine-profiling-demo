FROM finleymcilwaine/graphql-engine:base

###############################################################################
# Build eventlog-influxdb
###############################################################################

# Clone repo, checkout demo branch
COPY ./eventlog-influxdb /eventlog-influxdb
WORKDIR /eventlog-influxdb

# Build eventlog-influxdb
RUN cabal install --overwrite-policy=always eventlog-influxdb

WORKDIR /

COPY ./run-engine.sh /run-engine.sh
