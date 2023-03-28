#!/bin/bash

graphql-engine serve +RTS -l --eventlog-flush-interval=1 &

sleep 10s

eventlog-influxdb
