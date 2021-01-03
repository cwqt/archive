# mcnlang

a dead-simple domain specific language for writing tasks on mcn.  
9 instructions, no variables, no functions, no non-primitive data-types.

each line is essentially a task that is sent to the device, performed, then acknowledged complete, running the next line and so forth.

```mcn
# routines->b 
if sensors->photocell > 2000 ? break
set states->light_intensity 80
if metrics->voltage_level < 3.5
    ? itr 2 trigger routines->b
    : set states->light_state false

# routines->b
set states->light_state !states->light_state
wait 10
```

## key words

```
if
? //then
: //else
goto
set
wait
break
itr
json
```

### data types

* `"double quote enclosed"`: string
* `2310`: int
* `1.34`: float
* `true | false`: boolean
* `json{"key":value}`: json

### operators

lhs compared to rhs

* `==` equals 
* `!=` not equals
* `>` greater than
* `<` less than
* `>=` greater than or equal
* `<=` less than or equal
* `!` logical not
* `&&` logical and
* `||` logical or

no math

## examples

`if <states | sensors | metrics>-><Measurement | IoTMeasurement | IoTState> <operator>`

`states->light_level` is equivalent to `states["light_level"]` in js

### subroutines

`routines.some_uuid`
```
    set states.pump_state true
    wait 60
    set states.pump_state false

    if sensors->photocell <= 200 ? goto routines->a5ec990fa9c5043e74f21a497
```

`routines.a5ec990fa9c5043e74f21a497`
```
    set states->light_state true
```

max routine depth of 5