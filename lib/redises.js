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
      this.pool = new Pool({
        factory: options.factory || (function(done) {
          return done(redis.createClient());
        })
      });
    }

    Redises.prototype.script = function() {
      var args, k;
      k = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.__fwd.apply(this, ['script', k.toLowerCase()].concat(__slice.call(args)));
    };

    Redises.prototype.__fwd = function() {
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

  module.exports.commands = ['append', 'auth', 'bgrewriteaof', 'bgsave', 'bitcount', 'bitop', 'blpop', 'brpop', 'brpoplpush', 'cluster', 'dbsize', 'decr', 'decrby', 'del', 'discard', 'dump', 'echo', 'eval', 'evalsha', 'exec', 'exists', 'expire', 'expireat', 'flushall', 'flushdb', 'get', 'getbit', 'getrange', 'getset', 'hdel', 'hexists', 'hget', 'hgetall', 'hincrby', 'hincrbyfloat', 'hkeys', 'hlen', 'hmget', 'hmset', 'hscan', 'hset', 'hsetnx', 'hvals', 'incr', 'incrby', 'incrbyfloat', 'info', 'keys', 'lastsave', 'lindex', 'linsert', 'llen', 'lpop', 'lpush', 'lpushx', 'lrange', 'lrem', 'lset', 'ltrim', 'mget', 'migrate', 'monitor', 'move', 'mset', 'msetnx', 'multi', 'object', 'persist', 'pexpire', 'pexpireat', 'ping', 'psetex', 'psubscribe', 'pttl', 'publish', 'pubsub', 'punsubscribe', 'quit', 'randomkey', 'rename', 'renamenx', 'restore', 'rpop', 'rpoplpush', 'rpush', 'rpushx', 'sadd', 'save', 'scan', 'scard', 'sdiff', 'sdiffstore', 'select', 'set', 'setbit', 'setex', 'setnx', 'setrange', 'shutdown', 'sinter', 'sinterstore', 'sismember', 'slaveof', 'slowlog', 'smembers', 'smove', 'sort', 'spop', 'srandmember', 'srem', 'sscan', 'strlen', 'subscribe', 'substr', 'sunion', 'sunionstore', 'sync', 'time', 'ttl', 'type', 'unsubscribe', 'unwatch', 'watch', 'zadd', 'zcard', 'zcount', 'zincrby', 'zinterstore', 'zrange', 'zrangebyscore', 'zrank', 'zrem', 'zremrangebyrank', 'zremrangebyscore', 'zrevrange', 'zrevrangebyscore', 'zrevrank', 'zscan', 'zscore', 'zunionstore'];

  _ref = module.exports.commands;
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    c = _ref[i];
    eval("if (Redises.prototype['" + c + "'] === undefined) {\n  Redises.prototype['" + c + "'] = function () {\n    return this.__fwd.apply(this, ['" + c + "'].concat(Array.prototype.slice.call(arguments)))\n  }\n}");
  }

  module.exports.Redises = Redises;

}).call(this);
