#!/bin/bash

graphql-engine serve +RTS -l -hT --eventlog-flush-interval=1 --no-automatic-heap-samples &

sleep 10s

eventlog-influxdb
