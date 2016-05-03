module Test.Main where

import Prelude 
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Either(Either(Left, Right))
import Dust (compile, render, DUST())

main :: forall e. Eff (dust :: DUST, console :: CONSOLE | e) Unit
main = do
  let cjs = compile "<div>{test}</div>" "test"
  log ("Compiled template: " ++ cjs)
  render "test" {test : "Test string"} $ \res -> case res of
    (Left err)     -> log ("Render error: " ++ show err)
    (Right result) -> log ("Render result: " ++ result)
