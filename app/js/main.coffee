'use strict'

require [
  'modules/utils'
], (Utils) ->

  window.onload = ->
    console.log 'Ready.'

    canvas = document.getElementById 'canvas'
    mouse = Utils.captureMouse canvas

    canvas.addEventListener 'mousedown', ->
      console.log mouse.x, mouse.y
    , false
