-----------------------------------------------------------------------------
-- |
-- Module      :  Data.SBV.TestSuites.PrefixSum.PrefixSum
-- Copyright   :  (c) Levent Erkok
-- License     :  BSD3
-- Maintainer  :  erkokl@gmail.com
-- Stability   :  experimental
-- Portability :  portable
--
-- Test suite for Data.SBV.Examples.PrefixSum.PrefixSum
-----------------------------------------------------------------------------

module Data.SBV.TestSuites.PrefixSum.PrefixSum(testSuite) where

import Data.SBV
import Data.SBV.Internals
import Data.SBV.Examples.PrefixSum.PrefixSum

-- Test suite
testSuite :: SBVTestSuite
testSuite = mkTestSuite $ \_ -> test [
   "prefixSum1" ~: assert =<< isTheorem (flIsCorrect  8 (0, (+)))
 , "prefixSum1" ~: assert =<< isTheorem (flIsCorrect 16 (0, smax))
 ]
