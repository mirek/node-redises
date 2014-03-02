# # _ = require 'underscore'
# 
# a = ['a', 'b', 'c']
# 
# f = []
# 
# for e, i in a
#   g = e + '!'
#   f.push ->
#     console.log g
# 
# for e in f
#   e()

# redis = require 'redis'
# 
# # c = redis.createClient()
# # c.select 3
# 
# {Redises} = require './redises'
# 
# c = new Redises
#   factory: (done) ->
#     client = redis.createClient()
#     client.select 3, ->
#       done(client)
# 
# console.log +new Date(), 'start'
# 
# c.hgetall 'largehash', (err, resp) ->
#   console.log +new Date(), 'long'
# 
# c.srandmember 'someset', (err, resp) ->
#   console.log +new Date(), 'fast'

# a = {a:1}
# b = a
# b = {b:1}
# 
# console.log a,b

# f = (i, done) ->
#   console.log i
#   if i < 10
#     f i + 1, done
#   else
#     done(i)
# 
# f 0, (o) ->
#   console.log 'last', o

# class Decor
#   
#   constructor: ->
#     @a = []
# 
#   append: (f) ->
#     @a.push f
# 
#   create: (done, object = null, i = 0) ->
#     @a[i] object, (decorated) =>
#       if i + 1 < @a.length
#         @create done, decorated, i + 1
#       else
#         done(decorated)
# 
# d = new Decor
# d.append (object, done) ->
#   done('start')
# d.append (object, done) ->
#   done("#{object}:1")
# 
# d.create (object) ->
#   console.log object

# a =
#   a: 1
#   b: 3
#   c: 5
# 
# for e of a
#   console.log e

# a = { a: 1 }
# b = { a: 1 }
# # h = {}
# # h[a] = true
# # delete h[b]
# # console.log h
# # console.log a == b
# # console.log a is b
# 
# arr = [a, b, {c: 1}]
# console.log arr.indexOf(b)
# arr.splice arr.indexOf(b), 1
# console.log arr
# console.log arr.indexOf(b)

# a = {a:1}
# b = a
# b.b = 1
# console.log a

# a = new Number(7)
# b = a
# b += 1
# console.log a.valueOf(), b.valueOf()

# a = {v:7}
# b = a
# b.v += 1
# console.log a, b

class C

  foo: (x, args...) ->
    console.log(x, args)

A = ['a', 'b', 'c']

for a in A
  C.prototype[a] = (args...) ->
    @foo a, args

c = new C
c.a()
c.b()
c.c()

