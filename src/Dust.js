"use strict";

// either use global `dust` instance or require module
//var _PS_dust = (typeof dust == 'undefined')? require( "dustjs-linkedin" ) : dust;
var dust = require( "dustjs-linkedin" );

exports.compileImpl = dust.compile;

exports.callbackImpl = function(left, right, cb) {
    return function (err, result) {
        if( err ) {
            cb( left(err) )();
        } else {
            cb( right(result) )();
        }
    }
}

exports.renderImpl = dust.render;

// Implements sync interface to render
exports.renderSyncImpl = function( name, ctx, left, right ) {
  return function() {
    var result;
    dust.render( name, ctx, function (err, res) {
      if( err ) {
        result = left(err);
      } else {
        result = right(res);
      }
    });
    return result;
  }
}

exports.loadImpl   = function( source ) {
    return function() {
        dust.loadSource( source );
        return {};
    }
}

