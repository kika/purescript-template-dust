"use strict";

// module Dust

// either use global `dust` instance or require module
var _PS_dust = (typeof dust == 'undefined')? require( "dustjs-linkedin" ) : dust;

exports.compileImpl = _PS_dust.compile;

exports.callbackImpl = function(left, right, cb) {
    return function (err, result) {
        if( err ) {
            cb( left(err) )();
        } else {
            cb( right(result) )();
        }
    }
}

exports.renderImpl = _PS_dust.render
