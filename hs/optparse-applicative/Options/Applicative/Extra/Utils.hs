{-
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
-}

module Options.Applicative.Extra.Utils ( manyReadableArgs
                                       , manyStringArgs
                                       , optionalReadableArg
                                       , optionalStringArg
                                       , readableArg
                                       , someReadableArgs
                                       , someStringArgs
                                       , stringArg
                                       , subcommands
                                       , withHelpInfo ) where

import Control.Applicative ( (<*>), many, optional, some )
import Data.Monoid ( mconcat )
import Options.Applicative.Builder ( ArgumentFields
                                   , CommandFields
                                   , InfoMod
                                   , Mod
                                   , argument
                                   , auto
                                   , footer
                                   , fullDesc
                                   , info
                                   , strArgument
                                   , subparser )
import Options.Applicative.Common ( Parser, ParserInfo )
import Options.Applicative.Extra ( helper )

manyReadableArgs :: (Read a) => [Mod ArgumentFields a] -> Parser [a]
manyReadableArgs = many . readableArg

manyStringArgs :: [Mod ArgumentFields String] -> Parser [String]
manyStringArgs = many . stringArg

optionalReadableArg :: (Read a) => [Mod ArgumentFields a] -> Parser (Maybe a)
optionalReadableArg = optional . readableArg

optionalStringArg :: [Mod ArgumentFields String] -> Parser (Maybe String)
optionalStringArg = optional . stringArg

readableArg :: (Read a) => [Mod ArgumentFields a] -> Parser a
readableArg = argument auto . mconcat

someReadableArgs :: (Read a) => [Mod ArgumentFields a] -> Parser [a]
someReadableArgs = some . readableArg

someStringArgs :: [Mod ArgumentFields String] -> Parser [String]
someStringArgs = some . stringArg

stringArg :: [Mod ArgumentFields String] -> Parser String
stringArg = strArgument . mconcat

subcommands :: [Mod CommandFields a] -> Parser a
subcommands = subparser . mconcat

withHelpInfo :: Parser a -> [InfoMod a] -> ParserInfo a
withHelpInfo parser infos = info (helper <*> parser) . mconcat $ moreInfo where
    moreInfo = fullDesc
             : footer "Report bugs to <email_address>"
             : infos
