assert = require 'assert'
{Pool} = require '../src/pool'

describe 'Pool', ->

  it 'should decorate', (done) ->
    p = new Pool
      factory: (done2) -> done2(3)

    p.appendDecorator (object, done2) ->
      done2(object * 5)

    p.dequeue (o) ->
      assert.equal 15, o
      done()
