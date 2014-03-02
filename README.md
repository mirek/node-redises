## Summary

Redis client with pool support and drop-in replacement/transparent API.

## Usage

    {Redises} = require 'redises'
    
    redises = new Redises
    redises.set 'myval', 'foo', (err, resp) ->
      console.log err, resp
      redises.get 'myval', (err, resp) ->
        console.log err, resp

Another example:

    redis = require 'redis'
    {Redises} = require 'redises'

    # Select db 2
    redises = new Redises
      client = redis.createClient()
      client.select 2, (err, resp) =>
        done(client)

    # Use multi
    multi = redises.multi()
    multi.set 'multi:test:1', 'foo'
    multi.get 'multi:test:1'
    multi.exec (err, resp) ->
      console.log err, resp
      # null [ 'OK', 'foo' ]

### Stateless commands

All stateless commands are handled transparently. From library usage point of view all of them will behave as if they were called on redis client:

* `APPEND`
* `BGREWRITEAOF`
* `BGSAVE`
* `BITCOUNT`
* `BITOP`
* `BLPOP`
* `BRPOP`
* `BRPOPLPUSH`
* `CLIENT KILL`
* `CLIENT LIST`
* `CONFIG GET`
* `CONFIG RESETSTAT`
* `CONFIG REWRITE`
* `CONFIG SET`
* `DBSIZE`
* `DEBUG OBJECT`
* `DEBUG SEGFAULT`
* `DECR`
* `DECRBY`
* `DEL`
* `DUMP`
* `ECHO`
* `EVAL`
* `EVALSHA`
* `EXISTS`
* `EXPIRE`
* `EXPIREAT`
* `FLUSHALL`
* `FLUSHDB`
* `GET`
* `GETBIT`
* `GETRANGE`
* `GETSET`
* `HDEL`
* `HEXISTS`
* `HGET`
* `HGETALL`
* `HINCRBY`
* `HINCRBYFLOAT`
* `HKEYS`
* `HLEN`
* `HMGET`
* `HMSET`
* `HSCAN`
* `HSET`
* `HSETNX`
* `HVALS`
* `INCR`
* `INCRBY`
* `INCRBYFLOAT`
* `INFO`
* `KEYS`
* `LASTSAVE`
* `LINDEX`
* `LINSERT`
* `LLEN`
* `LPOP`
* `LPUSH`
* `LPUSHX`
* `LRANGE`
* `LREM`
* `LSET`
* `LTRIM`
* `MGET`
* `MIGRATE`
* `MONITOR`
* `MOVE`
* `MSET`
* `MSETNX`
* `OBJECT`
* `PERSIST`
* `PEXPIRE`
* `PEXPIREAT`
* `PING`
* `PSETEX`
* `PTTL`
* `QUIT`
* `RANDOMKEY`
* `RENAME`
* `RENAMENX`
* `RESTORE`
* `RPOP`
* `RPOPLPUSH`
* `RPUSH`
* `RPUSHX`
* `SADD`
* `SAVE`
* `SCAN`
* `SCARD`
* `SCRIPT EXISTS`
* `SCRIPT FLUSH`
* `SCRIPT KILL`
* `SCRIPT LOAD`
* `SDIFF`
* `SDIFFSTORE`
* `SET`
* `SETBIT`
* `SETEX`
* `SETNX`
* `SETRANGE`
* `SHUTDOWN`
* `SINTER`
* `SINTERSTORE`
* `SISMEMBER`
* `SLAVEOF`
* `SLOWLOG`
* `SMEMBERS`
* `SMOVE`
* `SORT`
* `SPOP`
* `SRANDMEMBER`
* `SREM`
* `SSCAN`
* `STRLEN`
* `SUBSTR`
* `SUNION`
* `SUNIONSTORE`
* `SYNC`
* `TIME`
* `TTL`
* `TYPE`
* `ZADD`
* `ZCARD`
* `ZCOUNT`
* `ZINCRBY`
* `ZINTERSTORE`
* `ZRANGE`
* `ZRANGEBYSCORE`
* `ZRANK`
* `ZREM`
* `ZREMRANGEBYRANK`
* `ZREMRANGEBYSCORE`
* `ZREVRANGE`
* `ZREVRANGEBYSCORE`
* `ZREVRANK`
* `ZSCAN`
* `ZSCORE`
* `ZUNIONSTORE`

Please note that `SCRIPT ...` commands give impression of statefull commands, but are in fact client side stateless commands.

### Statefull commands

The following commands hold state on the client side and require special treatment:

* `SELECT` - todo, at the moment you can select database in the factory
* `AUTH` - todo
* `CLIENT GETNAME` - todo
* `CLIENT SETNAME` - todo
* `MULTI` - supported
* `EXEC` - supported
* `DISCARD` - supported
* `WATCH` - supported
* `UNWATCH` - supported
* `SUBSCRIBE` - todo
* `UNSUBSCRIBE` - todo
* `PSUBSCRIBE` - todo
* `PUBLISH` - todo
* `PUBSUB` - todo
* `PUNSUBSCRIBE` - todo

