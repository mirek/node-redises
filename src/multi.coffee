redis = require 'redis'

# Internal use only, wrapper around `redis.Multi`.
# 
# Inherits from `redis.Multi`. Constructor stores reference to `redises` instance
# and invokes `redis.Multi`'s constructor with redis client set to `null`.
#
# All commands are cached offline. On `exec`/`discard` invocation new client is
# dequeued from redises' pool, all commands invoked, the client is put back to the
# pool and callback invoked.
class Multi extends redis.Multi

  constructor: (@redises, args) ->
    super null, args

  exec: (done) ->
    @redises.dequeue (client) =>
      @_client = client
      super (err, resp) =>
        unless err?
          @redises.enqueue @_client
        @_client = null
        if done?
          done(err, resp)

if module? and module.exports
  module.exports.Multi = Multi
