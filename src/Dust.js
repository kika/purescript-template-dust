"use strict";

// module Dust

exports.compileImpl = function(src, name) {
    return function() {
        return dust.compile(src, name);
    }
}
