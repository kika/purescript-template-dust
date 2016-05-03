module Dust
(
    DUST()
  , compile
  , render
  , RenderCallback (..)
) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Nullable (Nullable)
import Data.Either (Either(Right, Left)) 
import Data.Function (Fn2(), Fn3(), runFn2, runFn3)
import Unsafe.Coerce (unsafeCoerce)

type CompiledTemplate = String
type RenderCallbackJS a = Fn2 (Nullable Error) a Unit
type RenderCallback eff a = Either Error a -> Eff ( dust :: DUST | eff ) Unit

-- | Effect type for dust render callback
foreign import data DUST :: !
foreign import compileImpl :: Fn2 String String CompiledTemplate
foreign import callbackImpl :: 
  forall eff a. Fn3 (Error -> Either Error a) (a -> Either Error a)
                    (RenderCallback eff a) (RenderCallbackJS a)
foreign import renderImpl :: 
  forall ctx. Fn3 String {|ctx} (RenderCallbackJS String) Unit

-- typecast a function into Eff monad
-- smells some C++
mkEff :: forall eff a. (Unit -> a) -> Eff eff a
mkEff = unsafeCoerce

-- | shove PS callback into JS one
runCallback :: forall eff a. (RenderCallback eff a) -> RenderCallbackJS a
runCallback cb = runFn3 callbackImpl Left Right cb


compile :: String -> String -> CompiledTemplate
compile src name = runFn2 compileImpl src name

render :: forall eff ctx. String -> {|ctx} -> RenderCallback eff String -> 
                          Eff( dust :: DUST | eff) Unit
render name context cb = 
  mkEff $ \_ -> runFn3 renderImpl name context (runCallback cb)
