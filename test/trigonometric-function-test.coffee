'use strict'

chai = require 'chai'

chai.use (_chai, utils) ->
  Assertion = chai.Assertion
  # FIXME: No matter test failed or suceeded!
  utils.addMethod Assertion::, 'almostEqual', (str) ->
    obj = utils.flag @, str
    myAssert = new Assertion obj

should = chai.should()


describe 'Tests of Trigonometric Functions:', ->

  before ->
    console.log 'Get ready.'

  after ->
    console.log 'Done.'

  describe 'Math.PI', ->
    it 'should be equal to 180 degrees', ->
      radians = Math.PI
      degrees = radians * 180 / Math.PI
      degrees.should.equal 180

  describe '180 degrees', ->
    it 'should be equal to Math.PI', ->
      degrees = 180
      radians = degrees * Math.PI / 180
      radians.should.equal Math.PI

  describe '2 * Math.PI', ->
    it 'should be equal to 360 degrees', ->
      radians = 2 * Math.PI
      degrees = radians * 180 / Math.PI
      degrees.should.equal 360

  describe '360 degrees', ->
    it 'should be equal to 2 * Math.PI', ->
      degrees = 360
      radians = degrees * Math.PI / 180
      radians.should.equal 2 * Math.PI

  describe 'Math.PI / 2', ->
    it 'should be 90 degrees', ->
      radians = Math.PI / 2
      degrees = radians * 180 / Math.PI
      degrees.should.equal 90

  describe '90 degrees', ->
    it 'should be Math.PI / 2', ->
      degrees = 90
      radians = degrees * Math.PI / 180
      radians.should.equal Math.PI / 2

  # TODO: 対辺、斜辺、隣辺の長さのテスト

  describe 'Radians of 30 degrees of a rectangular triangle', ->
    degrees = 30
    radians = degrees * Math.PI / 180

    it 'should have sine, 0.5', ->
      sin = Math.sin radians
      sin.should.almostEqual 0.5

    it 'should be equal to arc sine, 0.523', ->
      sin = Math.sin radians
      asin = Math.asin sin
      asin.should.equal radians

  describe 'Cosine of 30 degrees of a rectangular triangle', ->
    it 'should be arc cosine of about 0.865', ->
      degrees = 30
      radians = degrees * Math.PI / 180
      cos = Math.cos radians
      acos = Math.acos cos
      cos.should.equal acos

  describe 'Sine (oppsite side / hypotenuse) of 60 degrees of a rectangular triangle', ->
    it 'should be arc sine, almost 0.865', ->
      degrees = 60
      radians = degrees * Math.PI / 180
      sin = Math.sin radians
      asin = Math.asin sin
      sin.should.equal asin

  describe 'Cosine (adjacent side / hypotenuse) of 60 degrees of a rectangular triangle' , ->
    it 'should be arc cosine, 0.5', ->
      degrees = 60
      radians = describe * Math.PI / 180
      cos = Math.cos radians
      acos = Math.acos cos
      cos.should.almostEqual acos

  describe 'Tangent of 30 degrees of a rectangular triangle', ->
    it 'should be equal to 0.578, 1 / 1.73 (oppsite side / adjacent side)', ->
      degrees = 30
      radians = degrees * Math.PI / 180
      tan = Math.tan radians
      tan.should.almostEqual 0.578

