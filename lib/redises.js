(function() {
  var Pool, Redises, c, i, redis, _i, _len, _ref,
    __slice = [].slice;

  redis = require('redis');

  Pool = require('./pool').Pool;

  Redises = (function() {
    function Redises(options) {
      if (options == null) {
        options = {};
      }
      this.db = options.db != null ? +options.db | 0 : 0;
      this.pool = new Pool({
        factory: options.factory || (function(_this) {
          return function(done) {
            var client;
            client = redis.createClient();
            return client.select(_this.db, function(err, resp) {
              return done(client);
            });
          };
        })(this)
      });
    }

    Redises.prototype.enqueue = function(client) {
      return this.pool.enqueue(client);
    };

    Redises.prototype.dequeue = function(done) {
      return this.pool.dequeue(done);
    };

    Redises.prototype.script = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      switch (args[0].toLowerCase()) {
        case 'exists':
        case 'flush':
        case 'kill':
        case 'load':
          return this.__command.apply(this, ['script'].concat(__slice.call(args)));
        default:
          throw new TypeError("Redises object #<" + this + "> has no method script('" + args[0] + "', ...)");
      }
    };

    Redises.prototype.auth = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Redises#auth(...) not supported, call this command from factory or dequeue client manually.");
    };

    Redises.prototype.debug = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      switch (args[0].toLowerCase()) {
        case 'object':
        case 'segfault':
          return this.__command.apply(this, ['debug'].concat(__slice.call(args)));
        default:
          throw new TypeError("Redises object #<" + this + "> has no method script('" + args[0] + "', ...)");
      }
    };

    Redises.prototype.select = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.discard = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.multi = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.exec = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.watch = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.unwatch = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      throw new TypeError("Not supported.");
    };

    Redises.prototype.client = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      switch (args[0].toLowerCase()) {
        case 'getname':
        case 'kill':
        case 'list':
          return this.__command.apply(this, ['client'].concat(__slice.call(args)));
        case 'setname':
          throw new TypeError("Redises object #<" + this + "> does not support client('setname', ...) method. Invoke this command from factory or manually dequeue client and call this method.");
          break;
        default:
          throw new TypeError("Redises object #<" + this + "> has no method config('" + "', ...)");
      }
    };

    Redises.prototype.config = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      switch (args[0].toLowerCase()) {
        case 'get':
        case 'resetstat':
        case 'rewrite':
        case 'set':
          return this.__command.apply(this, ['config'].concat(__slice.call(args)));
        default:
          throw new TypeError("Redises object #<" + this + "> has no method config('" + args[0] + "', ...)");
      }
    };

    Redises.prototype.__command = function() {
      var args, f, k, pool;
      k = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (typeof args[args.length - 1] === 'function') {
        f = args.pop();
      }
      pool = this.pool;
      return pool.dequeue(function(client) {
        var argsWithCb;
        argsWithCb = args.concat(function() {
          var redisArgs;
          redisArgs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          if (redisArgs[0] == null) {
            pool.enqueue(client);
          }
          if (f != null) {
            return f.apply(null, redisArgs);
          }
        });
        return client[k].apply(client, argsWithCb);
      });
    };

    return Redises;

  })();

  module.exports.commands = ['append', 'bgrewriteaof', 'bgsave', 'bitcount', 'bitop', 'blpop', 'brpop', 'brpoplpush', 'dbsize', 'decr', 'decrby', 'del', 'dump', 'echo', 'eval', 'evalsha', 'exists', 'expire', 'expireat', 'flushall', 'flushdb', 'get', 'getbit', 'getrange', 'getset', 'hdel', 'hexists', 'hget', 'hgetall', 'hincrby', 'hincrbyfloat', 'hkeys', 'hlen', 'hmget', 'hmset', 'hscan', 'hset', 'hsetnx', 'hvals', 'incr', 'incrby', 'incrbyfloat', 'info', 'keys', 'lastsave', 'lindex', 'linsert', 'llen', 'lpop', 'lpush', 'lpushx', 'lrange', 'lrem', 'lset', 'ltrim', 'mget', 'migrate', 'monitor', 'move', 'mset', 'msetnx', 'object', 'persist', 'pexpire', 'pexpireat', 'ping', 'psetex', 'pttl', 'quit', 'randomkey', 'rename', 'renamenx', 'restore', 'rpop', 'rpoplpush', 'rpush', 'rpushx', 'sadd', 'save', 'scan', 'scard', 'sdiff', 'sdiffstore', 'set', 'setbit', 'setex', 'setnx', 'setrange', 'shutdown', 'sinter', 'sinterstore', 'sismember', 'slaveof', 'slowlog', 'smembers', 'smove', 'sort', 'spop', 'srandmember', 'srem', 'sscan', 'strlen', 'substr', 'sunion', 'sunionstore', 'sync', 'time', 'ttl', 'type', 'zadd', 'zcard', 'zcount', 'zincrby', 'zinterstore', 'zrange', 'zrangebyscore', 'zrank', 'zrem', 'zremrangebyrank', 'zremrangebyscore', 'zrevrange', 'zrevrangebyscore', 'zrevrank', 'zscan', 'zscore', 'zunionstore'];

  _ref = module.exports.commands;
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    c = _ref[i];
    eval("if (Redises.prototype['" + c + "'] === undefined) {\n  Redises.prototype['" + c + "'] = function () {\n    return this.__command.apply(this, ['" + c + "'].concat(Array.prototype.slice.call(arguments)))\n  }\n} else {\n  throw \"Redises.prototype['" + c + "'] already defined.\"\n}");
  }

  module.exports.Redises = Redises;

}).call(this);
