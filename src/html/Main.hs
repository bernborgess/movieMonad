{-# LANGUAGE OverloadedStrings #-}

import Text.Blaze.Html.Renderer.Pretty
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A

main :: IO ()
main = putStrLn $ renderHtml $ docTypeHtml $ do

  H.head $ do
    H.title     "Movie Monad - Lettier.com"
    styleSheet  "https://fonts.googleapis.com/css?family=Oswald"
    styleSheet  "https://cdnjs.cloudfare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
    styleSheet  "all.css"
    scriptSrc   "jquery.js"
    H.script $ toHtml' "if ('require' in window) { window.$ = window.jQuery = require('./jquery.js'); }"
    scriptSrc   "all.js"
  
  H.body $
    H.div ! A.id "pageContainer" $ do
      H.input ! A.id "fileInput" ! A.name "fileInput" ! A.type_ "file"
      H.label ! A.for "fileInput" $ H.i ! A.class_ "fi-upload" ! A.title "Upload a Video File" $ empty
      H.div   ! A.id "videoContainer" $ empty
      H.div   ! A.id "statusMessage" $ empty



toHtml' :: String -> Html
toHtml' = toHtml

empty :: Html
empty = toHtml' ""

styleSheet :: AttributeValue -> Html
styleSheet s = H.link ! A.href s ! A.rel "stylesheet" ! A.type_ "text/css"

scriptSrc :: AttributeValue -> Html
scriptSrc s = H.script ! A.src s ! A.type_ "text/javascript" $ empty
