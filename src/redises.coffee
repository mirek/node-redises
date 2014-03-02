redis = require 'redis'
{Pool} = require './pool'
{Multi} = require './multi'

class Redises

  # @param [Object] options
  # @param [Number] options.db Default is 0.
  # @param []
  # @param [Function] options.factory 
  constructor: (options = {}) ->
    @db = if options.db? then +options.db|0 else 0
    @pool = new Pool
      factory: options.factory or (done) =>
        client = redis.createClient()
        client.select @db, (err, resp) =>
          done(client)

  enqueue: (client) ->
    @pool.enqueue client

  dequeue: (done) ->
    @pool.dequeue done

  multi: (args) ->
    new Multi this, args

  MULTI: () -> @multi arguments...

  script: (args...) ->
    switch args[0].toLowerCase()
      when 'exists', 'flush', 'kill', 'load'
        @__command 'script', args...
      else
        throw new TypeError "Redises object #<#{this}> has no method script('#{args[0]}', ...)"

  SCRIPT: () -> @script arguments...

  auth: (args...) ->
    throw new TypeError("Redises#auth(...) not supported, call this command from factory or dequeue client manually.")

  AUTH: () -> @auth arguments...

  debug: (args...) ->
    switch args[0].toLowerCase()
      when 'object', 'segfault'
        @__command 'debug', args...
      else
        throw new TypeError "Redises object #<#{this}> has no method script('#{args[0]}', ...)"

  DEBUG: () -> @debug arguments...

  select: (args...) ->
    throw new TypeError("Not supported.")

  SELECT: () -> @select arguments...

  discard: (args...) ->
    throw new TypeError("Not supported.")

  DISCARD: () -> @discard arguments...

  exec: (args...) ->
    throw new TypeError("Not supported.")

  EXEC: () -> @exec arguments...

  watch: (args...) ->
    throw new TypeError("Not supported.")

  WATCH: () -> @watch arguments...

  unwatch: (args...) ->
    throw new TypeError("Not supported.")

  UNWATCH: () -> @unwatch arguments...

  # 'psubscribe',
  # 'publish',
  # 'pubsub',
  # 'punsubscribe',
  # 'subscribe',
  # 'unsubscribe'

  client: (args...) ->
    switch args[0].toLowerCase()
      when 'getname', 'kill', 'list'
        @__command 'client', args...
      when 'setname'
        throw new TypeError "Redises object #<#{this}> does not support client('setname', ...) method. Invoke this command from factory or manually dequeue client and call this method."
      else
        throw new TypeError "Redises object #<#{this}> has no method config('#{#{args[0]}}', ...)"

  CLIENT: () -> @client arguments...

  config: (args...) ->
    switch args[0].toLowerCase()
      when 'get', 'resetstat', 'rewrite', 'set'
        @__command 'config', args...
      else
        throw new TypeError "Redises object #<#{this}> has no method config('#{args[0]}', ...)"

  CONFIG: () -> @config arguments...

  # Forward redis call to a new or one of pool'ed client.
  #
  # @params [String] k Function name
  # @params args... Function call arguments
  __command: (k, args...) ->

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
  # 'auth', TODO: Auth with prepend.
  'bgrewriteaof',
  'bgsave',
  'bitcount',
  'bitop',
  'blpop',
  'brpop',
  'brpoplpush',
  # 'client getname',
  # 'client kill',
  # 'client list',
  # 'client setname',
  # 'config get',
  # 'config resetstat',
  # 'config rewrite',
  # 'config set',
  'dbsize',
  # 'debug object',
  # 'debug segfault',
  'decr',
  'decrby',
  'del',
  # 'discard', # Part of multi.
  'dump',
  'echo',
  'eval',
  'evalsha',
  # 'exec', # Part of multi.
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
  # 'multi', Part of multi proxy.
  'object',
  'persist',
  'pexpire',
  'pexpireat',
  'ping',
  'psetex',
  # 'psubscribe',
  'pttl',
  # 'publish',
  # 'pubsub',
  # 'punsubscribe',
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
  # 'script exists',
  # 'script flush',
  # 'script kill',
  # 'script load',
  'sdiff',
  'sdiffstore',
  # 'select',
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
  # 'subscribe',
  'substr',
  'sunion',
  'sunionstore',
  'sync',
  'time',
  'ttl',
  'type',
  # 'unsubscribe',
  # 'unwatch',
  # 'watch',
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

# Closure wrapper
__makeForwarder = (k) ->
  () ->
    @__command k, arguments...

for c, i in module.exports.commands
  if Redises.prototype[c]? or Redises.prototype[c.toUpperCase()]
    throw "Redises##{c} or Redises##{c.toUpperCase()} already defined!"
  else
    Redises.prototype[c.toUpperCase()] = Redises.prototype[c] = __makeForwarder(c)

module.exports.Redises = Redises
