require( "chai" ).should()

impel = require "../src/impel.coffee"

mult = ( n, arr ) ->
  arr.map ( e ) -> e * n

class Person
  constructor: ( name, age, isAwesome ) ->
    @name = name
    @age = age
    @isAwesome = isAwesome

  foo: ->
    "#{ @name } is #{ @age } years old and #{ if @isAwesome then "is" else "isn't" } awesome."

impelMult = undefined
ImpelPerson = undefined

beforeEach ->
  impelMult = impel mult, [Number, Array]
  ImpelPerson = impel.ctor Person, [String, Number, Boolean]

describe "impel()", ->
  it "Should not throw errors when passed the right types of arguments", ->
    ( -> impelMult 123, [1, 2, 3] ).should.not.throw()

  it "Should throw errors when passed the wrong types of arguments", ->
    ( -> impelMult "a", [1, 2, 3] ).should.throw()
    ( -> impelMult 123, "abcdefg" ).should.throw()

describe "impelConstructor()", ->
  it "Should not throw errors when passed the right types of arguments", ->
    ( -> new ImpelPerson "Nick", 27, true ).should.not.throw()
    p = new ImpelPerson "Nick", 27, true
    p.should.be.instanceof Person
    p.foo.should.equal Person::foo
    p.foo().should.equal "Nick is 27 years old and is awesome."

  it "Impelled constructors should work without 'new'", ->
    ( -> ImpelPerson "Nick", 27, true ).should.not.throw()
    p = ImpelPerson "Nick", 27, true
    p.should.be.instanceof Person
    p.foo.should.equal Person::foo
    p.foo().should.equal "Nick is 27 years old and is awesome."

  it "Should throw errors when passed the right types of arguments", ->
    ( -> new ImpelPerson "Joe", 25, "nope" ).should.throw()
    ( -> new ImpelPerson "Jane", [], true ).should.throw()
    ( -> new ImpelPerson {}, 1234, false ). should.throw()

