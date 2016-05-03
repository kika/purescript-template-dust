module Test.Main where

import Prelude 
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Either(Either(Left, Right))
import Dust (compile, load, render, DUST())

main :: forall e. Eff (dust :: DUST, console :: CONSOLE | e) Unit
main = do
  let js = """
  (function(dust){
    dust.register("test",body_0);
    function body_0(chk,ctx)
    {
      return chk.w("<div>").f(ctx.get(["test"], false),ctx,"h").w("</div>");
    }
    body_0.__dustBody=!0;
    return body_0
    }(dust)
  );"""
  let cjs = compile "<div>{test}</div>" "test"
  log ("Compiled template: " ++ cjs)
  load js
  log "Template loaded"
  render "test" {test : "Test string"} $ \res -> case res of
    (Left err)     -> log ("Render error: " ++ show err)
    (Right result) -> log ("Render result: " ++ result)
