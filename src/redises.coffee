redis = require 'redis'
{Pool} = require './pool'

class Redises

  constructor: (options = {}) ->
    @pool = new Pool
      factory: options.factory or (-> redis.createClient())

  # set: (args...) -> @__fwd 'set', args...
  # get: (args...) -> @__fwd 'get', args...

  # Forward redis call to pool'ed client.
  # @params [String] k Function name
  # @params args... Function call arguments
  __fwd: (k, args...) ->

    # Pop callback.
    # TODO: iff it's a function
    f = args.pop()

    # Use local var so we don't need to bind the following chain
    # of call.
    pool = @pool

    # Dequeue the client
    pool.dequeue (client) ->

      argsWithCb = args.concat (redisArgs...) ->

        # Put the client back to the pool if there were no errors.
        pool.enqueue(client) unless redisArgs[0]?

        f redisArgs... if f?

      client[k] argsWithCb...

module.exports.commands = [
  "get", "set", "setnx", "setex", "append", "strlen", "del", "exists", "setbit", "getbit", "setrange", "getrange", "substr",
  "incr", "decr", "mget", "rpush", "lpush", "rpushx", "lpushx", "linsert", "rpop", "lpop", "brpop", "brpoplpush", "blpop", "llen", "lindex",
  "lset", "lrange", "ltrim", "lrem", "rpoplpush", "sadd", "srem", "smove", "sismember", "scard", "spop", "srandmember", "sinter", "sinterstore",
  "sunion", "sunionstore", "sdiff", "sdiffstore", "smembers", "zadd", "zincrby", "zrem", "zremrangebyscore", "zremrangebyrank", "zunionstore",
  "zinterstore", "zrange", "zrangebyscore", "zrevrangebyscore", "zcount", "zrevrange", "zcard", "zscore", "zrank", "zrevrank", "hset", "hsetnx",
  "hget", "hmset", "hmget", "hincrby", "hdel", "hlen", "hkeys", "hvals", "hgetall", "hexists", "incrby", "decrby", "getset", "mset", "msetnx",
  "randomkey", "select", "move", "rename", "renamenx", "expire", "expireat", "keys", "dbsize", "auth", "ping", "echo", "save", "bgsave",
  "bgrewriteaof", "shutdown", "lastsave", "type", "multi", "exec", "discard", "sync", "flushdb", "flushall", "sort", "info", "monitor", "ttl",
  "persist", "slaveof", "debug", "config", "subscribe", "unsubscribe", "psubscribe", "punsubscribe", "publish", "watch", "unwatch", "cluster",
  "restore", "migrate", "dump", "object", "client", "eval", "evalsha"
]

for c, i in module.exports.commands
   eval "Redises.prototype['#{c}'] = function () { return this.__fwd.apply(this, ['#{c}'].concat(Array.prototype.slice.call(arguments))) }"

r = new Redises
r.set 'mirek:1', '1234', (err, resp) ->
  console.log err, resp
  
  r.get 'mirek:1', (err, resp) ->
    console.log err, resp

