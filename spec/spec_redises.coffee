assert = require 'assert'
redis = require 'redis'
{Redises} = require '../src/redises'

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
      assert.equal null, err
      sha1 = resp
      redises.evalsha sha1, 0, (err, resp) ->
        assert.equal 'foo', resp
        done()

  it 'should exec multi', (done) ->
    multi = redises.multi()
    multi.set 'multi:test:1', '111'
    multi.get 'multi:test:1'
    multi.exec (err, resp) ->
      assert.equal null, err
      assert.equal 'OK', resp[0]
      assert.equal '111', resp[1]
      done()
