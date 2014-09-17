err = ( val, type ) ->
  throw new TypeError "Invalid argument: #{ value } should be a #{ ctor }"

isPrimitive = ( value ) ->
  to = typeof value
  to is "string" or to is "number" or to is "boolean"

checkPrimitive = ( value, ctor ) ->
  to = typeof value
  unless to is "string" and ctor is String or
  to is "number" and ctor is Number or
  to is "boolean" and ctor is Boolean
    err value, ctor

checkObj = ( value, ctor ) ->
  err value, ctor unless value instanceof ctor

check =  ( arg, type ) ->
  if isPrimitive arg then checkPrimitive arg, type else checkObj arg, type

impel = ( fn, types ) ->
  ->
    for arg, i in arguments
      check arg, types[i]
    fn.apply @, arguments

impel.fnFirst = ( fn, args... ) ->
  impel fn, args

impel.fnLast = ( args..., fn ) ->
  impel fn, args

impel.ctor = ( ctor, types ) ->
  ->
    for arg, i in arguments
      check arg, types[i]
    inst = Object.create ctor::
    ctor.apply inst, arguments
    inst

module.exports = impel
