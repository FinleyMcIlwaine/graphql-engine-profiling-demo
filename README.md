# `graphql-engine` Profiling Demo

**NOTE:** This repository contains important submodules. Either clone with the
`--recursive` flag or do `git submodule init && git submodule update` after
cloning.

<hr>

A demo of profiling Hasura's `graphql-engine` using
[`ghc-eventlog-socket`](https://github.com/bgamari/ghc-eventlog-socket) and
[`eventlog-live`](https://github.com/mpickering/eventlog-live). Components:
- A [`graphql-engine`](https://github.com/hasura/graphql-engine) executable that
  has been instrumented using
  [`ghc-eventlog-socket`](https://github.com/bgamari/ghc-eventlog-socket) to
  stream its eventlog over a socket during execution.
- Another executable (in
  [`eventlog-influxdb`](https://github.com/finleymcilwaine/eventlog-influxdb)) which reads data
  from the eventlog socket and inserts it into an
  [InfluxDB](https://github.com/influxdata/influxdb) database.
- A benchmarking tool (in [./bench](./bench)) copied from the existing
  `graphql-engine` benchmark suite to generate traffic and make the profile more
  interesting.
- A [Grafana](https://github.com/grafana/grafana) instance to view the live
  eventlog data on a pretty webpage.
- A [Docker Compose](https://docs.docker.com/compose/) configuration to tie all
  of this together and run it all with a single command.

## Usage

### Build the images

> **NOTE:** There are `linux/amd64` and `linux/arm64` images published on Docker
> Hub which are already listed in the `docker-compose.yml`, so building the
> images yourself is only necessary if the pre-built images are not acceptable
> for some reason. Skip to [Start the containers](#start-the-containers) to use
> the prebuilt images.

Begin by building the base benchmarking image:
```bash
docker build ./bench/graphql-bench/app -t finleymcilwaine/graphql-bench:base
```

Then build the benchmarking image:
```bash
docker build ./bench -t finleymcilwaine/graphql-bench:main
```

Now build the base `graphql-engine` image:
```bash
docker build ./engine -f ./engine/base.Dockerfile -t finleymcilwaine/graphql-engine:base
```

Then build the `graphql-engine` image:
```bash
docker build ./engine -f ./engine/main.Dockerfile -t finleymcilwaine/graphql-engine:main
```

With the images built, the steps below should now work for you.

### Start the containers

Run everything with just:
```
docker compose up
```

If it's your first time pulling the images, it may take a while (the
`graphql-engine` image is about 1GB in compressed size).

The benchmark will just run on a loop. There will be a lot of docker compose log
output from the the PostgreSQL and `graphql-engine` instances as they handle the
requests from the benchmark.

### Viewing the data

#### With Grafana

Navigate to [`localhost:3000`](http://localhost:3000) for the Grafana instance.
Enter username `admin` and password `admin`.

The dashboards from [`./grafana/dashboards`](./grafana/dashboards/) are
automatically loaded into the instance. To view and interact with them, select
the "Dashboards" tab:

![](./assets/dashboards.png)

#### Query InfluxDB

To check the data in the InfluxDB instance directly, you can submit queries from
your local command-line, e.g.:

```bash
curl -G 'localhost:8086/query?pretty=true&u=admin&p=admin' --data-urlencode "db=eventlog" --data-urlencode "q=SHOW MEASUREMENTS ON eventlog"
```

Outputs the available measurements.

```bash
curl -G 'localhost:8086/query?pretty=true&u=admin&p=admin' --data-urlencode "db=eventlog" --data-urlencode "q=SELECT * FROM \"gauge.eventlog.heap_size\""
```

Outputs the heap size measurement data.
