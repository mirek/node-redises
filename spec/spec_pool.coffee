assert = require 'assert'
{Pool} = require '../src/pool'

describe 'Pool', ->

  describe '#decorate', ->
    it 'should decorate', (done) ->

      # Create simple pool
      p = new Pool
        factory: (done2) ->
          done2({v:3})

      assert.equal 0, p.outsideCount()
      assert.equal 0, p.insideCount()
      assert.equal 0, p.count()

      # Create one object.
      p.dequeue (o) ->
        assert.equal 1, p.outsideCount()
        assert.equal 0, p.insideCount()
        assert.equal 1, p.count()
        p.enqueue o
        assert.equal 0, p.outsideCount()
        assert.equal 1, p.insideCount()
        assert.equal 1, p.count()

        # Decorate.
        p.decorate (o) -> o.v = o.v * 5
        p.decorate (o) -> o.v = o.v + 1

        # Get first object (from the pool)
        p.dequeue (o1) ->
          assert.equal 1, p.outsideCount()
          assert.equal 0, p.insideCount()
          assert.equal 1, p.count()
          assert.equal ((3 * 5) + 1), o.v
          
          # Get second object (created)
          p.dequeue (o2) ->
            assert.equal ((3 * 5) + 1), o.v
            p.enqueue o1
            p.enqueue o2
            assert.equal 0, p.outsideCount()
            assert.equal 2, p.insideCount()
            assert.equal 2, p.count()
            done()
