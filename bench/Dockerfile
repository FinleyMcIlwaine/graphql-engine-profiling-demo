FROM finleymcilwaine/graphql-bench:base

WORKDIR /

RUN apk add postgresql curl

COPY ./graphql-engine/server/benchmarks/benchmark_sets/chinook /chinook
COPY ./run-bench.sh /run-bench.sh
