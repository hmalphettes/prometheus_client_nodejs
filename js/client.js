var Client, debug;

debug = require("debug")("prometheus-client");

module.exports = Client = (function() {
  Client._globalRegistry = null;

  Client.Gauge = require("./gauge");

  Client.Counter = require("./counter");

  Client.Registry = require("./registry");

  function Client(opts) {
    this.registry = (opts != null ? opts.registry : void 0) || (Client._globalRegistry || (Client._globalRegistry = new Client.Registry));
  }

  Client.prototype.register = function(metric) {
    return this.registry.register(metric);
  };

  Client.prototype.metricsFunc = function() {
    return this.registry.metricsFunc;
  };

  Client.prototype.newCounter = function(args) {
    return this.register(new Client.Counter(args));
  };

  Client.prototype.newGauge = function(args) {
    return this.register(new Client.Gauge(args));
  };

  return Client;

})();

//# sourceMappingURL=client.js.map
