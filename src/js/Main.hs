{-# LANGUAGE RebindableSyntax, OverloadedStrings, EmptyDataDecls #-}

import Prelude
import FFI
import JQuery
import Fay.Text

data File
data FileReader

main :: Fay ()
main = startApp

startApp :: Fay ()
startApp = ready $ do
  fileInput' <- fileInput
  void $ change (const $ onFileInputChange fileInput') fileInput'

fileInput :: Fay JQuery
fileInput = select "#fileInput"

newFileReader :: Fay FileReader
newFileReader = ffi "new FileReader()"

fileInputFiles :: JQuery -> Fay (Nullable [File])
fileInputFiles = ffi "%1['prop']('files')"

fileSize :: File -> Fay Int
fileSize = ffi "%1['size']"

nullableFileSize :: Nullable File -> Fay Int
nullableFileSize nullableFile = 
  case nullableFile of
    Nullable file -> fileSize file
    Null          -> return 0

fileSizeLimit :: Int
fileSizeLimit = 51000000

fileInputFile :: JQuery -> Int -> Fay (Nullable File)
fileInputFile fileInput index = do
  nullableFiles <- fileInputFiles fileInput
  let files = case nullableFiles of
    Nullable files  -> files
    Null            -> [] 
  if Prelude.null files || (Prelude.length files <= index)
    then return Null
    else return (Nullable $ files!!index)
  
fileReaderResult :: FileReader -> Fay Text
fileREaderResult = ffi "%1['result']"

addFileReaderEventListener :: FileReader -> Text -> (Event -> Fay ()) -> Fay ()
addFileReaderEventListener = ffi "%1['addEventListener'](%2,%3)"

setUpNewFileRead :: Nullable File -> Fay ()
setUpNewFileRead Null = return ()
setUpNewFileRead (Nullable file) = do
  fr <- newFileReader
  let onLoadCallback = const $ handleVideoFile fr
  addFileReaderEventListener fr "load" onLoadCallback
  readAsDataURL fr file

onFileInputChange :: JQuery -> Fay ()
onFileInputChange fileInput = do
  emptyVideoContainer
  nullableFile <- fileInputFile fileInput 0
  nfs <- nullableFileSize nullableFile
  if (&&) (nfs > 0) (nfs <= fileSizeLimit)
    then setUpNewFileRead nullableFile
    else void $ setStatusMessage "File too small or large."

setStatusMessage :: Text -> Fay JQuery
setStatusMessage text = select "#statusMessage" >>= setHtml text

videoContainer :: Fay JQuery
videoContainer = select "#videoContainer"

addVideoElement :: Fay JQuery
addVideoElement = select "<video id='video' src='' controls/>" >>= addToVideoContainer

addToVideoContainer :: JQuery -> Fay JQuery
addToVideoContainer el = videoContainer >>= flip appendTo el

emptyVideoContainer :: Fay JQuery
emptyVideoContainer = videoContainer >>= JQuery.empty

handleVideoFile :: FileReader -> Fay ()
handleVideoFile fr = do
  url <- fileReaderResult fr
  if "data:video" `isPrefixOf` url
    then void $ addVideoElement >>= setAttr "src" url >> setStatusMessage ""
    else void $ setStatusMessage "Not a video file."

readAsDataURL :: FileReader -> File -> Fay ()
readAsDataURL = ffi "%1['readAsDataURL'](%2)"


