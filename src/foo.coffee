# _ = require 'underscore'

a = ['a', 'b', 'c']

f = []

for e, i in a
  g = e + '!'
  f.push ->
    console.log g

for e in f
  e()
