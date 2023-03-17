#!/bin/sh

# Load schema
gunzip -c /chinook/dump.sql.gz | psql "$HASURA_GRAPHQL_DATABASE_URL" > /dev/null 2>&1

# Replace metadata
curl \
    --fail \
    --request POST \
    --header "Content-Type: application/json" \
    --data @/chinook/replace_metadata.json \
    "$HASURA_URL/v1/query"

# Run benchmarks
node /app/cli/bin/run query \
    --config="/chinook/config.query.yaml" \
    --outfile="/report.json" \
    --url "$HASURA_URL/v1/graphql"
