# Patterns

## Arrayify

### Ensures an object is an array.

If input is not an Array, it is returned as the first element in a new Array.

If input is already an Array, it is simply returned.

----

Input: Object | Array

Output: Array

----

```coffee
array = [].concat array
```