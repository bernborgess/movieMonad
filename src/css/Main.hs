{-# LANGUAGE OverloadedStrings #-}

import Clay
import Clay.Box
import Clay.Transform

main :: IO ()
main = putCss $ do
  body ? do
    backgroundColor "#323A45"
    color           "#eee"
    fontFamily      ["Oswald"] [sansSerif]
    overflow        hidden
    height          $ pct 100
    width           $ pct 100
    marginAll       $ px 0
  
  label ? do
    borderBottomStyle solid
    borderBottomColor $ rgba' 26 105 94 0.7969
    backgroundColor   $ rgba' 31 187 166 0.8
    boxShadow         (px 0) (px 10) (px 5) (rgba' 27 39 35 0.39)
    fontSize          $ px 60
    paddingAll        $ px 20
    borderBottomWidth $ px 10
    display           inlineBlock
    cursor            pointer
  
  video ? do
    height $ pct 100
    width  $ pct 100
  
  "#pageContainer" ?
    textAlign (alignSide sideLeft)
  
  "#fileInput" ? do
    width         $ px 0
    outlineWidth  $ px 0
    display       none
  
  "#videoContainer" ? do
    position  absolute
    zIndex    (-1)
    top       $ px 0
    left      $ px 0
    height    $ pct 100
    width     $ pct 100

  "#statueMessage" ? do
    position    absolute
    minHeight   $ pct 100
    minWidth    $ pct 100
    paddingTop  $ pct 25
    zIndex      (-2)
    top         $ px 0
    left        $ px 0
    width       $ pct 100
    height      $ pct 100
    fontSize    $ px 60
    textAlign   $ alignSide sideCenter
    

paddingAll :: Size z -> Css
paddingAll s = padding s s s s

marginAll :: Size z -> Css
marginAll s = margin s s s s

rgba' :: Integer -> Integer -> Integer -> Double -> Color
rgba' r g b a = rgba r g b $ floor $ a * 255