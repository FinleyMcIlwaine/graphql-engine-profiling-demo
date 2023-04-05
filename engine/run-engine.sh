#!/bin/bash

graphql-engine serve +RTS -l -hT --eventlog-flush-interval=1 &

sleep 10s

eventlog-influxdb
