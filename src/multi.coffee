redis = require 'redis'

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

  EXEC: () -> @exec arguments...

if module? and module.exports
  module.exports.Multi = Multi
