redis = require 'redis'
{Pool} = require './pool'

class Redises

  constructor: (options = {}) ->
    @pool = new Pool
      factory: options.factory or (-> redis.createClient())

  # Forward redis call to pool'ed client.
  #
  # @params [String] k Function name
  # @params args... Function call arguments
  __fwd: (k, args...) ->

    # Pop callback.
    f = args.pop() if typeof args[args.length - 1] == 'function'

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
  'append',
  'auth',
  'bgrewriteaof',
  'bgsave',
  'bitcount',
  'bitop',
  'blpop',
  'brpop',
  'brpoplpush',
  'client',
  'client getname',
  'client kill',
  'client list',
  'client setname',
  'cluster',
  'config',
  'config get',
  'config resetstat',
  'config rewrite',
  'config set',
  'dbsize',
  'debug',
  'debug object',
  'debug segfault',
  'decr',
  'decrby',
  'del',
  'discard',
  'dump',
  'echo',
  'eval',
  'evalsha',
  'exec',
  'exists',
  'expire',
  'expireat',
  'flushall',
  'flushdb',
  'get',
  'getbit',
  'getrange',
  'getset',
  'hdel',
  'hexists',
  'hget',
  'hgetall',
  'hincrby',
  'hincrbyfloat',
  'hkeys',
  'hlen',
  'hmget',
  'hmset',
  'hscan',
  'hset',
  'hsetnx',
  'hvals',
  'incr',
  'incrby',
  'incrbyfloat',
  'info',
  'keys',
  'lastsave',
  'lindex',
  'linsert',
  'llen',
  'lpop',
  'lpush',
  'lpushx',
  'lrange',
  'lrem',
  'lset',
  'ltrim',
  'mget',
  'migrate',
  'monitor',
  'move',
  'mset',
  'msetnx',
  'multi',
  'object',
  'persist',
  'pexpire',
  'pexpireat',
  'ping',
  'psetex',
  'psubscribe',
  'pttl',
  'publish',
  'pubsub',
  'punsubscribe',
  'quit',
  'randomkey',
  'rename',
  'renamenx',
  'restore',
  'rpop',
  'rpoplpush',
  'rpush',
  'rpushx',
  'sadd',
  'save',
  'scan',
  'scard',
  'script exists',
  'script flush',
  'script kill',
  'script load',
  'sdiff',
  'sdiffstore',
  'select',
  'set',
  'setbit',
  'setex',
  'setnx',
  'setrange',
  'shutdown',
  'sinter',
  'sinterstore',
  'sismember',
  'slaveof',
  'slowlog',
  'smembers',
  'smove',
  'sort',
  'spop',
  'srandmember',
  'srem',
  'sscan',
  'strlen',
  'subscribe',
  'substr',
  'sunion',
  'sunionstore',
  'sync',
  'time',
  'ttl',
  'type',
  'unsubscribe',
  'unwatch',
  'watch',
  'zadd',
  'zcard',
  'zcount',
  'zincrby',
  'zinterstore',
  'zrange',
  'zrangebyscore',
  'zrank',
  'zrem',
  'zremrangebyrank',
  'zremrangebyscore',
  'zrevrange',
  'zrevrangebyscore',
  'zrevrank',
  'zscan',
  'zscore',
  'zunionstore'
]

for c, i in module.exports.commands
   eval "Redises.prototype['#{c}'] = function () { return this.__fwd.apply(this, ['#{c}'].concat(Array.prototype.slice.call(arguments))) }"

module.exports.Redises = Redises
