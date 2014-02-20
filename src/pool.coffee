
class Pool

  # @param [Object] options
  # @param [Function] options.factory (done(object))
  constructor: (options = {}) ->

    # Objects outside of the pool.
    @outside = []

    # Objects inside the pool.
    @inside = []

    # Decorators chain is invoked for each created object.
    @decorators = []

    @factory = options.factory

    # # Set min and max.
    # @min = if options.min? and +options.min >= 0 then (+options.min | 0) else 5
    # @max = if options.max? and +options.max >= 0 then (+options.max | 0) else 128
    # if @min > @max
    #   [@min, @max] = [@max, @min]
    # TODO: create min clients?

  # @return [Number] Number of objects inside and outside the pool.
  count: ->
    @inside.length + @outside.length

  # @return [Number] Number of objects inside the pool.
  insideCount: ->
    @inside.length

  # @return [Number] Number of objects outside the pool.
  outsideCount: ->
    @outside.length

  # Iterate over all objects (inside and outside the pool).
  #
  # @param [Function] f (object)
  each: (f) ->
    f object for object in @inside
    f object for object in @outside

  # Append decorator to the factory chain and decorate all
  # objects inside and outside the pool.
  #
  # @param [Function] decorator (object, done())
  # @param [Function] done ()
  decorate: (decorator, done = null) ->

    @decorators.push decorator

    i = @count()
    eachDone = () ->
      if --i == 0
        done() if done?

    @each (object) ->
      decorator object, ->
        eachDone()

  # For internal use, decorates newly created object.
  #
  # @param [Object] object
  # @param [Number] i Decorator's index
  # @param [Function] done ()
  decorateObject: (object, i, done) ->
    if i < @decorators.length
      @decorateObject object, i + 1, done
    else
      done()

  # Create object by using factory method and all registered
  # decorator functions in the factory chain.
  #
  # @param [Function] done (object)
  create: (done) ->
    @factory (object) =>
      @decorateObject object, 0, ->
        done(object)

  # Put object back to the pool.
  #
  # @param [Object] object
  enqueue: (object) ->
    @outside.splice @outside.indexOf(object), 1
    @inside.push object

  # Pop the object from the pool or create new one.
  # 
  # @param [Function] done (object)
  dequeue: (done) ->
    if @inside.length > 0
      object = @inside.pop()
      @outside.push object
      done object
    else
      @create (object) =>
        @outside.push object
        done object

module.exports.Pool = Pool
