FROM finleymcilwaine/graphql-bench:base

WORKDIR /

RUN apk add postgresql curl

COPY ./chinook /chinook
COPY ./run-bench.sh /run-bench.sh
