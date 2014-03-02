## Summary

Redis client with pool support and drop-in replacement/transparent API.

## Usage

    {Redises} = require 'redises'
    
    redises = new Redises
    redises.set 'myval', 'foo', (err, resp) ->
      console.log err, resp
      redises.get 'myval', (err, resp) ->
        console.log err, resp

### Stateless commands

All stateless commands are handled transparently. From library usage point of view all of them will behave as if they were called on redis client.

`APPEND`
`BGREWRITEAOF`
`BGSAVE`
`BITCOUNT`
`BITOP`
`BLPOP`
`BRPOP`
`BRPOPLPUSH`
`CLIENT KILL`
`CLIENT LIST`
`CONFIG GET`
`CONFIG RESETSTAT`
`CONFIG REWRITE`
`CONFIG SET`
`DBSIZE`
`DEBUG OBJECT`
`DEBUG SEGFAULT`
`DECR`
`DECRBY`
`DEL`
`DUMP`
`ECHO`
`EVAL`
`EVALSHA`
`EXISTS`
`EXPIRE`
`EXPIREAT`
`FLUSHALL`
`FLUSHDB`
`GET`
`GETBIT`
`GETRANGE`
`GETSET`
`HDEL`
`HEXISTS`
`HGET`
`HGETALL`
`HINCRBY`
`HINCRBYFLOAT`
`HKEYS`
`HLEN`
`HMGET`
`HMSET`
`HSCAN`
`HSET`
`HSETNX`
`HVALS`
`INCR`
`INCRBY`
`INCRBYFLOAT`
`INFO`
`KEYS`
`LASTSAVE`
`LINDEX`
`LINSERT`
`LLEN`
`LPOP`
`LPUSH`
`LPUSHX`
`LRANGE`
`LREM`
`LSET`
`LTRIM`
`MGET`
`MIGRATE`
`MONITOR`
`MOVE`
`MSET`
`MSETNX`
`OBJECT`
`PERSIST`
`PEXPIRE`
`PEXPIREAT`
`PING`
`PSETEX`
`PTTL`
`QUIT`
`RANDOMKEY`
`RENAME`
`RENAMENX`
`RESTORE`
`RPOP`
`RPOPLPUSH`
`RPUSH`
`RPUSHX`
`SADD`
`SAVE`
`SCAN`
`SCARD`
`SCRIPT EXISTS`
`SCRIPT FLUSH`
`SCRIPT KILL`
`SCRIPT LOAD`
`SDIFF`
`SDIFFSTORE`
`SET`
`SETBIT`
`SETEX`
`SETNX`
`SETRANGE`
`SHUTDOWN`
`SINTER`
`SINTERSTORE`
`SISMEMBER`
`SLAVEOF`
`SLOWLOG`
`SMEMBERS`
`SMOVE`
`SORT`
`SPOP`
`SRANDMEMBER`
`SREM`
`SSCAN`
`STRLEN`
`SUBSTR`
`SUNION`
`SUNIONSTORE`
`SYNC`
`TIME`
`TTL`
`TYPE`
`ZADD`
`ZCARD`
`ZCOUNT`
`ZINCRBY`
`ZINTERSTORE`
`ZRANGE`
`ZRANGEBYSCORE`
`ZRANK`
`ZREM`
`ZREMRANGEBYRANK`
`ZREMRANGEBYSCORE`
`ZREVRANGE`
`ZREVRANGEBYSCORE`
`ZREVRANK`
`ZSCAN`
`ZSCORE`
`ZUNIONSTORE`

Please note that `SCRIPT ...` commands give impression of statefull commands, but are in fact client side stateless commands.

### Statefull commands

The following commands hold state on the client side and require special threatment:

* `SELECT` - not supported yet. To select the pass your own factory method, ie:

    redis = new Redises factory: (done) ->
      client = redis.createClient()
      client.select 2, (err, resp) =>
        unless err?
          done(client)

* `AUTH` - not supported yet.
* `CLIENT GETNAME`
* `CLIENT SETNAME` - not supported yet.

* `MULTI` - supported.
* `EXEC` - supported.
* `DISCARD` - not supported yet.
* `WATCH` - supported.
* `UNWATCH` - supported.

* `SUBSCRIBE`
* `UNSUBSCRIBE`
* `PSUBSCRIBE`
* `PUBLISH`
* `PUBSUB`
* `PUNSUBSCRIBE`
