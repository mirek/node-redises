
class Pool

  # @param [Object] options
  # @param [Function] options.factory (done(object))
  constructor: (options = {}) ->
    @objects = []
    @decorators = []
    if options.factory?
      factory = options.factory

      # Factory, as a first decorator, doesn't have object argument. Make
      # it consistent with the rest of decorators so we can chain them
      # nicely.
      @decorators.push ((object, done) -> factory(done))

    @min = if options.min? and +options.min >= 0 then (+options.min | 0) else 5
    @max = if options.max? and +options.max >= 0 then (+options.max | 0) else 128

    # Idiot proof.
    if @min > @max
      [@min, @max] = [@max, @min] 

    # TODO: create min clients
    # dequeued = for i in [1..@min]
    #   @

  length: ->
    @objects.length

  each: (f) ->
    for object in @objects
      f(object)

  enqueue: (object) ->
    @objects.push object

  # @param [Function] f (object, done(decorated))
  appendDecorator: (f) ->
    @decorators.push f

  create: (done, object = null, i = 0) ->
    @decorators[i] object, (decorated) =>
      if i + 1 < @decorators.length
        @create done, decorated, i + 1
      else
        done(decorated)

  dequeue: (done) ->
    if @objects.length == 0
      @create done
    else
      done @objects.pop()

module.exports.Pool = Pool
