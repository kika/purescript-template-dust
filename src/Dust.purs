module Dust
(
    DUST()
  , runDust
  , compile
  , load
  , render
  , renderSync
  , RenderCallback (..)
) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Nullable (Nullable)
import Data.Either (Either(Right, Left)) 
import Data.Function.Uncurried (Fn1, Fn2, Fn3, Fn4, 
                                runFn1, runFn2, runFn3, runFn4)
import Unsafe.Coerce (unsafeCoerce)

type CompiledTemplate = String
type RenderCallbackJS a = Fn2 (Nullable Error) a Unit
type RenderCallback eff a = Either Error a -> Eff ( dust :: DUST | eff ) Unit

-- | Effect type for dust callback and internal state change 
foreign import data DUST :: !
foreign import compileImpl :: Fn2 String String CompiledTemplate
foreign import loadImpl :: 
  forall eff.  Fn1 CompiledTemplate (Eff ( dust :: DUST | eff ) Unit)
foreign import callbackImpl :: 
  forall eff a. Fn3 (Error -> Either Error a) (a -> Either Error a)
                    (RenderCallback eff a) (RenderCallbackJS a)
foreign import renderImpl :: 
  forall ctx. Fn3 String {|ctx} (RenderCallbackJS String) Unit
foreign import renderSyncImpl :: 
  forall ctx eff. Fn4 String {|ctx} 
                  (Error -> Either Error String)
                  (String -> Either Error String)
                  (Eff eff (Either Error String))

-- typecast a function into Eff monad
-- smells some C++
mkEff :: forall eff a. (Unit -> a) -> Eff eff a
mkEff = unsafeCoerce

-- | removes the DUST effect
runDust::forall eff a. (Eff (dust::DUST|eff) a) -> Eff eff a
runDust = unsafeCoerce

-- shove PS callback into JS one
runCallback :: forall eff a. (RenderCallback eff a) -> RenderCallbackJS a
runCallback cb = runFn3 callbackImpl Left Right cb


-- Public API

-- | Compiles template contained in string `src` into internal representation
-- | and gives it the name `name`. Returns compiled template (js source)
compile :: String -> String -> CompiledTemplate
compile src name = runFn2 compileImpl src name

-- | Loads the template into the engine 
load :: forall eff. CompiledTemplate -> Eff (dust :: DUST | eff) Unit
load code = runFn1 loadImpl code

-- | Renders the template asynchronously
-- | Runs the template `name` giving it the record with context `context` 
-- | and calls the callback with `Either` `Error` or `String` with rendered
-- | contents.
render :: forall eff ctx. String -> {|ctx} -> RenderCallback eff String -> 
                          Eff (dust::DUST | eff) Unit
render name context cb = 
  mkEff $ \_ -> runFn3 renderImpl name context (runCallback cb)

-- | The `render` function can actually run synchronously if everything
-- | is preloaded in advance. To avoid using callbacks this is a 
-- | convenience wrapper.
-- | It handles errors and thus removes the DUST effect
renderSync::forall eff ctx. String -> {|ctx} -> 
                            (Eff eff (Either Error String))
renderSync name ctx = runFn4 renderSyncImpl name ctx Left Right

