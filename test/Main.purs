module Test.Main where

import Prelude (Unit, (++))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Dust

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  let result = compile "<div>{test}</div>" "test"
  log ("Result: " ++ result)
