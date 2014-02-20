assert = require 'assert'
redis = require 'redis'
{Redises} = require '../lib/redises'

redises = new Redises
  factory: ((done) -> done(redis.createClient()))

describe 'Redises', ->

  it 'should set, get and delete', (done) ->
    redises.set 'redises:spec:1', 'foo', (err, resp) ->
      assert.equal null, err
      redises.get 'redises:spec:1', (err, resp) ->
        assert.equal null, err
        assert.equal 'foo', resp
        done()

  it 'should load script', (done) ->
    redises.script 'load', 'return "foo"', (err, resp) ->
      sha1 = resp
      redises.evalsha sha1, 0, (err, resp) ->
        assert.equal 'foo', resp
        done()
