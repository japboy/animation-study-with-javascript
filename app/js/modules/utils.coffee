'use strict'

define [], ->

  ###*
  # requestAnimationFrame polyfill
  # based on an article by Paul Irish
  # @link https://gist.github.com/paulirish/1579671
  ###
  do ->
    lastTime = 0
    vendors = [
      'ms'
      'moz'
      'webkit'
      'o'
    ]

    for vendor in vendors when not window.requestAnimationFrame
      window.requestAnimationFrame = window["#{vendor}RequestAnimationFrame"]
      window.cancelAnimationFrame = (window["#{vendor}CancelAnimationFrame"] or
                                     window["#{vendor}CancelRequestAnimationFrame"])

    if not window.requestAnimationFrame
      window.requestAnimationFrame = (callback, element) ->
        currTime = new Date().getTime()
        timeToCall = Math.max(0, 16 - (currTime - lastTime))
        id = window.setTimeout ->
          callback(currTime + timeToCall)
        , timeToCall
        lastTime = currTime + timeToCall
        return id

    if not window.cancelAnimationFrame
      window.cancelAnimationFrame = (id) ->
        clearTimeout id


  Utils =

    ###*
    # captureMouse function
    # based on Foundation HTML5 Animation with JavaScript
    # @link http://www.apress.com/9781430236658
    ###
    captureMouse: (element) ->
      mouse =
        x: 0
        y: 0

      handleMousemove = (event) ->
        if event.pageX or event.pageY
          x = event.pageX
          y = event.pageY
        else
          x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
          y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop

        x -= element.offsetLeft
        y -= element.offsetTop

        mouse.x = x
        mouse.y = y

      element.addEventListener 'mousemove', handleMousemove, false

      return mouse


    ###*
    # captureTouch function
    # based on Foundation HTML5 Animation with JavaScript
    # @link http://www.apress.com/9781430236658
    ###
    captureTouch: (element) ->
      touch =
        x: undefined
        y: undefined
        isPressed: false

      handleTouchstart = (event) ->
        touch.isPressed = true

      handleTouchend = (event) ->
        touch.isPressed = false
        touch.x = undefined
        touch.y = undefined

      handleTouchmove = (event) ->
        touch_event = event.touches[0]

        if touch_event.pageX or touch_event.pageY
          x = touch_event.pageX
          y = touch_event.pageY
        else
          x = touch_event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
          y = touch_event.clientY + document.body.scrollTop + document.documentElement.scrollTop

        x -= element.offsetLeft
        y -= element.offsetTop

        touch.x = x
        touch.y = y

      element.addEventListener 'touchstart', handleTouchstart, false
      element.addEventListener 'touchend', handleTouchend, false
      element.addEventListener 'touchmove', handleTouchmove, false

      return touch


  return Utils
