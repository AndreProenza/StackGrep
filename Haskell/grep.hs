-- @Author André Proenza

-- Compile: ghc --make grep
-- Run: ./grep
-- or compile and run once: runhaskell grep.hs file.txt

import System.IO 
import System.Environment
import Data.List     
  
main = do
    args <- getArgs
    content <- readFile $ head args
    putStrLn content
    putStrLn "Filtering:"
    inputFilter <- getLine
    filtering (head args) filterList inputFilter
    
-- Function which manages the process of filter a file
-- Receives the file name to filter, a list of filters, and a filter given by the user.
-- Returns an IO() which represents the filtered list and the filter list.
filtering :: String -> [String] -> String -> IO()
filtering fileName filterList' filter' = do
    if (filter' == "pop") && (null filterList')
    then return ()
    else (if filter' == "pop" 
          then do
              content <- readFile fileName
              if ((length filterList') == 1) --Se for o penúltimo pop
              then do
                  putStrLn content
                  putStrLn "Filtering:"
                  inputFilter <- getLine
                  filtering fileName (removeFromFilterList filterList') inputFilter
              else do
                  -- Filter  file
                  putStrLn $ unlines $ filterFile content (removeFromFilterList filterList')
                  -- Print Filter List
                  putStrLn $ "Filtering: " ++ intercalate ", " (removeFromFilterList filterList')
                  inputFilter <- getLine
                  filtering fileName (removeFromFilterList filterList') inputFilter
          else do
              content <- readFile fileName
              -- Filter  file
              putStrLn $ unlines $ filterFile content (addToFilterList filterList' [filter'])
              -- Print Filter List
              putStrLn $ "Filtering: " ++ intercalate ", " (addToFilterList filterList' [filter'])
              inputFilter <- getLine
              filtering fileName (addToFilterList filterList' [filter']) inputFilter)

-- Filter list given by the user
filterList :: [String]
filterList = []

-- Add a filter to the filter list
-- Receives a filter list and the filter we want to add
-- Returns a filter list with one more filter
addToFilterList :: [String] -> [String] -> [String]
addToFilterList = (++) 

-- Remove a filter to the filter list (Remove last filter from the filter list)
-- Receives a filter list
-- Returns a filter list with one less filter
removeFromFilterList :: [String] -> [String]
removeFromFilterList = init

-- FIlter the file
-- Receives a string which represents the file content, and a filter list.
-- Returns a list of strings with the file filtered
filterFile :: String -> [String] -> [String]
filterFile fileContent filterList' = filterFileAux (lines fileContent) filterList'

--  Auxiliary function which filters the file.
-- Receives a list of strings representing the content of the file divided in lines 
--  and a list of filters,  where each filter in the list will be used to filter the file.
-- Returns a list of strings with the file filtered
-- Example: filterFileAux ["This is line one!","This is line two!"] ["one"]
-- Output: ["This is line one!"]
filterFileAux :: [String] -> [String] -> [String]
filterFileAux [] _ = []
filterFileAux (fileLineList:fileContentList) filterList'
    | (and $ filterFileLine fileLineList filterList') = 
        fileLineList : filterFileAux fileContentList filterList'
    | otherwise = filterFileAux fileContentList filterList'

-- Function which filters a line from a file according to a filter list.
-- Receives a file line and a filter list.
-- Returns: A list of booleans. Each index of the list is True if the line has a word similar to 
-- the current filter of the filter list.
-- Example:  filterFileLine "Hello this is  a java file!" ["util","java"]
-- Output: [False, True]
filterFileLine :: String -> [String] -> [Bool]
filterFileLine _ [] = []
filterFileLine fileLine (filter':filterList') 
    | filter' `isInfixOf` fileLine = True : filterFileLine fileLine filterList'
    | otherwise = False : filterFileLine fileLine filterList' 
