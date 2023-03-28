# `graphql-engine` Profiling Demo

A demo of profiling Hasura's `graphql-engine` using
[`ghc-eventlog-socket`](https://github.com/bgamari/ghc-eventlog-socket) and
[`eventlog-live`](https://github.com/mpickering/eventlog-live). Components:
- A [`graphql-engine`](https://github.com/hasura/graphql-engine) executable that
  has been instrumented using
  [`ghc-eventlog-socket`](https://github.com/bgamari/ghc-eventlog-socket) to
  stream its eventlog over a socket during execution.
- Another executable (in
  [./engine/eventlog-influxdb](./engine/eventlog-influxdb/)) which reads data
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

Navigate to [`localhost:3000`](http://localhost:3000) for the Grafana instance.
Enter username `admin` and password `admin`.

The InfluxDB instance is preconfigured as a data source in the Grafana
container, so all you have to do is create a dashboard which visualizes the
eventlog data from the InfluxDB instance. You can either create your own, or
import one of the preexisting ones from the
[`./grafana/dashboards`](./grafana/dashboards/) folder in this repository.

#### Importing a dashboard

Under the "Dashboards" tab in the side navigation bar, select "Import":
![](./assets/import-dashboard.png)

Select the "Upload dashboard JSON file" option and upload one of the dashboard
files in the [`./grafana/dashboards`](./grafana/dashboards/) folder. When
prompted to select the InfluxDB data source, select the preconfigured one:
![](./assets/influxdb-datasource.png)
