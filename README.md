## Summary

Redis client pool with drop-in/transparent support for stateless commands.

## Usage

    {Redises} = require 'redises'
    
    redises = new Redises
    redises.set 'myval', 'foo', (err, resp) ->
      console.log err, resp
      redises.get 'myval', (err, resp) ->
        console.log err, resp

