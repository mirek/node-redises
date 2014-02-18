
class Pool

  constructor: (options = {}) ->
    @objects = []
    @factory = options.factory
    @min = options.min
    @max = options.max

  enqueue: (object) ->
    @objects.push object

  dequeue: (f) ->
    if @objects.length == 0
      @factory f
    else
      f @objects.pop()

module.exports.Pool = Pool
