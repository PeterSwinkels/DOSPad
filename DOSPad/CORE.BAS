'$FORM InterfaceWindow
'$INCLUDE: 'CONSTANT.BI'
DEFINT A-Z
OPTION EXPLICIT

DECLARE FUNCTION BuildCompletePath (FilePath AS STRING, FileName AS STRING, FileExtension AS STRING) AS STRING
DECLARE FUNCTION ErrorHandlingPrompt (ErrorCode AS INTEGER) AS INTEGER
DECLARE FUNCTION LoadFile (FileName AS STRING) AS STRING
DECLARE SUB Main ()
DECLARE SUB SaveFile (FileName AS STRING, Text AS STRING)

ON ERROR GOTO ErrorTrap
 CALL Main
EndProgram:
END

ErrorTrap:
 PRINT "Error code"; STR$(ERR); ":"
 PRINT ERROR$(ERR); "."
RESUME EndProgram

FUNCTION BuildCompletePath (FilePath AS STRING, FileName AS STRING, FileExtension AS STRING) AS STRING
 IF NOT RIGHT$(FilePath, 1) = "\" THEN
  FilePath = FilePath + "\"
 END IF

 IF NOT UCASE$(RIGHT$(FileName, LEN(FileExtension))) = UCASE$(FileExtension) THEN
  FileName = FileName + FileExtension
 END IF

 BuildCompletePath = FilePath + FileName
END FUNCTION

FUNCTION ErrorHandlingPrompt (ErrorCode AS INTEGER) AS INTEGER
ON LOCAL ERROR GOTO EHP_ErrorTrap
DIM Choice AS INTEGER

 Choice = MSGBOX(ERROR$(ErrorCode) + "." + CHR$(13) + "Error code:" + STR$(ErrorCode), MB_ABORTRETRYIGNORE OR MB_DEFBUTTON2, "DOSPad")
 IF Choice = IDABORT THEN
  END
 END IF

EHP_EndRoutine:
 ErrorHandlingPrompt = Choice
EXIT FUNCTION

EHP_ErrorTrap:
RESUME EHP_EndRoutine
END FUNCTION

FUNCTION LoadFile (FileName AS STRING) AS STRING
DIM FileH AS INTEGER
DIM Text AS STRING

 FileH = FREEFILE
 IF NOT DIR$(FileName) = "" THEN
  OPEN FileName FOR BINARY LOCK READ WRITE AS FileH
   Text = INPUT$(LOF(FileH), FileH)
  CLOSE FileH
 END IF

 LoadFile = Text
END FUNCTION

SUB Main ()
 DO
  InterfaceWindow.SHOW
 LOOP WHILE DOEVENTS() > 0
END SUB

SUB SaveFile (FileName AS STRING, Text AS STRING)
DIM FileH AS INTEGER

 FileH = FREEFILE
 OPEN FileName FOR OUTPUT LOCK READ WRITE AS FileH
  PRINT #FileH, Text;
 CLOSE FileH
END SUB

