
class Pool

  constructor: (options = {}) ->
    @objects = []
    @factory = options.factory
    @min = options.min
    @max = options.max

  enqueue: (object) ->
    console.log "pool - did enq, size #{@objects.length + 1}"
    @objects.push object

  dequeue: (f) ->
    if @objects.length == 0
      f @factory()
    else
      console.log "pool - did pop, size #{@objects.length - 1}"
      f @objects.pop()

module.exports.Pool = Pool
