-----------------------------------------------------------------------------
-- |
-- Module      :  Data.SBV.Examples.BitPrecise.BitTricks
-- Copyright   :  (c) Levent Erkok
-- License     :  BSD3
-- Maintainer  :  erkokl@gmail.com
-- Stability   :  experimental
-- Portability :  portable
--
-- Checks the correctness of a few tricks from the large collection found in:
--      http://graphics.stanford.edu/~seander/bithacks.html
-----------------------------------------------------------------------------

module Data.SBV.Examples.BitPrecise.BitTricks where

import Data.SBV

-- http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
fastMinCorrect :: SInt32 -> SInt32 -> SBool
fastMinCorrect x y = m .== fm
  where m  = ite (x .< y) x y
        fm = y `xor` ((x `xor` y) .&. (-(oneIf (x .< y))));

-- http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
fastMaxCorrect :: SInt32 -> SInt32 -> SBool
fastMaxCorrect x y = m .== fm
  where m  = ite (x .< y) y x
        fm = x `xor` ((x `xor` y) .&. (-(oneIf (x .< y))));

-- http://graphics.stanford.edu/~seander/bithacks.html#DetectOppositeSigns
oppositeSignsCorrect :: SInt32 -> SInt32 -> SBool
oppositeSignsCorrect x y = r .== os
  where r  = (x .< 0 &&& y .>= 0) ||| (x .>= 0 &&& y .< 0)
        os = (x `xor` y) .< 0

-- http://graphics.stanford.edu/~seander/bithacks.html#ConditionalSetOrClearBitsWithoutBranching
conditionalSetClearCorrect :: SBool -> SWord32 -> SWord32 -> SBool
conditionalSetClearCorrect f m w = r .== r'
  where r  = ite f (w .|. m) (w .&. complement m)
        r' = w `xor` ((-(oneIf f) `xor` w) .&. m);

-- http://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2
powerOfTwoCorrect :: SWord32 -> SBool
powerOfTwoCorrect v = f .== s
  where f = (v ./= 0) &&& ((v .&. (v-1)) .== 0);
        powers :: [Word32]
        powers = map ((2::Word32)^) [(0::Word32) .. 31]
        s = bAny (v .==) $ map literal powers

queries :: IO ()
queries =
  let check :: Provable a => String -> a -> IO ()
      check w t = do putStr $ "Proving " ++ show w ++ ": "
                     print =<< prove t
  in do check "Fast min             " fastMinCorrect
        check "Fast max             " fastMaxCorrect
        check "Opposite signs       " oppositeSignsCorrect
        check "Conditional set/clear" conditionalSetClearCorrect
        check "PowerOfTwo           " powerOfTwoCorrect
