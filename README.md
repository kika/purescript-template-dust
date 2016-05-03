# purescript-template-dust

Purescript bindings for the [LinkedIn Dust template library](http://dustjs.com).

[![Build Status](https://secure.travis-ci.org/kika/purescript-template-dust.png?branch=master)](http://travis-ci.org/kika/purescript-template-dust)

## API

The API is a straightforward binding to Dust:
* `compile source name` - compiles the template `source` into internal representaion
and assigns it a `name`. Returns internal representation.
* `load compiled` - loads compiled template from the `compile` call and returns
nothing
* `render name context callback` - renders the compiled and loaded template `name` using
Purescript record `context` for variable substitutions. Calls `callback` with `Either`
`Error` or `String` result.

Stream operations are not supported yet. Open an issue.

## Examples and tests

The `test` directory contains an a simple Purescript program which calls all
API functions and should produce a test string with substitution.

