module Dust
(compile)
where

import Data.Function (Fn2(), runFn2)

foreign import compileImpl :: Fn2 String String String

compile :: String -> String -> String
compile src name = runFn2 compileImpl src name

