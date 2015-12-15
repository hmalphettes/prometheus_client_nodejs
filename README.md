# Prometheus Client

WIP [Prometheus](http://prometheus.io) instrumentation metrics library for
Node.JS. Metrics are intended to be scraped by a Prometheus server.

## Usage

### Getting Started

Install the `prometheus-client` package with NPM:

    npm install prometheus-client

Then require the package and set up a new client instance:

    Prometheus = require("prometheus-client")

    client = new Prometheus()

The client library does not provide a builtin server.

To use the metrics output function in an express app, you might do:

    app = express()
    app.get("/metrics",client.metricsFunc())
    app.listen(9090)

Then use `curl http://127.0.0.1:9090` to see a text representation of your metrics.

By default, the Prometheus client will use a global namespace. That means that
any metrics registered inside your app (even by libraries) will show up in your
client without any need to pass around a client object.

See [examples/test.coffee](examples/test.coffee) for a full example of registering and using metrics in coffeescript and [examples/counterAndGauge.js](examples/counterAndGauge.js) to see the same example written in Javascript.
