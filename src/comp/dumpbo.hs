{-# LANGUAGE CPP #-}
module Main_dumpbo(main) where

import System.Environment(getArgs)
import System.Exit(exitWith, ExitCode(..))

import PPrint
import GenBin
import BinaryIO
import ISyntax
import Error(initErrorHandle)
import System.IO

main :: IO ()
main = do
    errh <- initErrorHandle
    as <- getArgs
    (isBI, fname) <- case as of
                       ["-bi", mi]             -> return (True, mi)
                       [mi@(c:_)] | (c /= '-') -> return (False, mi)
                       _ -> do putStr ("Usage: dumpbo [-bi] mod-id\n")
                               exitWith (ExitFailure 1)
    file <- readBinaryFile fname
    (bi_sig, bo_sig, ipkg, hash) <- readBinFile errh fname file
    hSetEncoding stdout latin1
    if (isBI)
       then do putStr (ppReadable bi_sig)
       else do putStrLn ("Internal Symbols (export): ")
               putStr (ppReadable bi_sig)
               putStrLn ("Internal Symbols (all): ")
               putStr (ppReadable bo_sig)
               putStr (ppReadable (ipkg :: IPackage ()))
               putStrLn ("Hash: " ++ hash)
    exitWith ExitSuccess
