Version 1.00
BEGIN Form InterfaceWindow
	AutoRedraw   = 0
	BackColor    = QBColor(7)
	BorderStyle  = 2
	Caption      = "DOSPad"
	ControlBox   = -1
	Enabled      = -1
	ForeColor    = QBColor(0)
	Height       = Char(17)
	Left         = Char(15)
	MaxButton    = -1
	MinButton    = -1
	MousePointer = 0
	Tag          = ""
	Top          = Char(3)
	Visible      = -1
	Width        = Char(63)
	WindowState  = 0
	BEGIN TextBox TextBox
		BackColor    = QBColor(7)
		BorderStyle  = 1
		DragMode     = 0
		Enabled      = -1
		ForeColor    = QBColor(0)
		Height       = Char(12)
		Left         = Char(0)
		MousePointer = 0
		MultiLine    = -1
		ScrollBars   = 3
		TabIndex     = 0
		TabStop      = -1
		Tag          = ""
		Text         = ""
		Top          = Char(0)
		Visible      = -1
		Width        = Char(49)
	END
	BEGIN Menu FileMain
		Caption      = "&File"
		Checked      = 0
		Enabled      = -1
		Separator    = 0
		Tag          = ""
		Visible      = -1
		BEGIN Menu FileNewMenu
			Caption      = "&New"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^N
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FileOpenMenu
			Caption      = "&Open"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^O
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FileSaveMenu
			Caption      = "&Save"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^S
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FileMenuSeparator1
			Caption      = ""
			Checked      = 0
			Enabled      = -1
			Separator    = -1
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FilePrintMenu
			Caption      = "&Print"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^P
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FileMenuSeparator2
			Caption      = ""
			Checked      = 0
			Enabled      = -1
			Separator    = -1
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu FileExitMenu
			Caption      = "&Exit"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^X
			Tag          = ""
			Visible      = -1
		END
	END
	BEGIN Menu EditMainMenu
		Caption      = "&Edit"
		Checked      = 0
		Enabled      = -1
		Separator    = 0
		Tag          = ""
		Visible      = -1
		BEGIN Menu EditCopyMenu
			Caption      = "&Copy"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^C
			Tag          = ""
			Visible      = -1
		END
		BEGIN Menu EditPasteMenu
			Caption      = "&Paste"
			Checked      = 0
			Enabled      = -1
			Separator    = 0
			Shortcut     = ^V
			Tag          = ""
			Visible      = -1
		END
	END
	BEGIN Menu AboutMainMenu
		Caption      = "&About"
		Checked      = 0
		Enabled      = -1
		Separator    = 0
		Tag          = ""
		Visible      = -1
	END
END
'$INCLUDE: 'CMNDLG.BI'
'$INCLUDE: 'CONSTANT.BI'
DEFINT A-Z
OPTION EXPLICIT

CONST EXTENSION$ = ".txt"

DECLARE FUNCTION BuildCompletePath (FilePath AS STRING, FileName AS STRING, FileExtension AS STRING) AS STRING
DECLARE FUNCTION ErrorHandlingPrompt (ErrorCode AS INTEGER) AS INTEGER
DECLARE FUNCTION LoadFile (FileName AS STRING) AS STRING
DECLARE SUB SaveFile (FileName AS STRING, Text AS STRING)

SUB AboutMainMenu_Click ()
ON LOCAL ERROR GOTO AMM_ErrorTrap
DIM Choice AS INTEGER

 MSGBOX "DOSPad v1.00 - By: Peter Swinkels, ***2024***", MB_OK
AMM_EndRoutine:
EXIT SUB

AMM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME AMM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB EditCopyMenu_Click ()
ON LOCAL ERROR GOTO ECM_ErrorTrap
DIM Choice AS INTEGER

 ClipBoard.SETTEXT MID$(TextBox.Text, TextBox.SelStart + 1, TextBox.SelLength)
ECM_EndRoutine:
EXIT SUB

ECM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME ECM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB EditPasteMenu_Click ()
ON LOCAL ERROR GOTO EPM_ErrorTrap
DIM Choice AS INTEGER
DIM Position AS INTEGER

 Position = TextBox.SelStart
 TextBox.Text = LEFT$(TextBox.Text, Position + 1) + ClipBoard.GETTEXT() + MID$(TextBox.Text, Position + TextBox.SelLength + 1)
 IF Position < LEN(TextBox.Text) THEN TextBox.SelStart = Position
EPM_EndRoutine:
EXIT SUB

EPM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME EPM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB FileExitMenu_Click ()
ON LOCAL ERROR GOTO FEM_ErrorTrap
DIM Choice AS INTEGER

 UNLOAD InterfaceWindow
FEM_EndRoutine:
EXIT SUB

FEM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FEM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB FileNewMenu_Click ()
ON LOCAL ERROR GOTO FNM_ErrorTrap
DIM Choice AS INTEGER

 IF MSGBOX("Do you want to start a new document?", MB_YESNO OR MB_DEFBUTTON2) = IDYES THEN
  TextBox.Text = ""
 END IF
FNM_EndRoutine:
EXIT SUB

FNM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FNM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB FileOpenMenu_Click ()
ON LOCAL ERROR GOTO FOM_ErrorTrap
DIM Cancel AS INTEGER
DIM Choice AS INTEGER
DIM FileName AS STRING
DIM FilePath AS STRING

 FilePath = CURDIR$
 FileOpen FileName, FilePath, "*" + EXTENSION$, "Open file.", CINT(InterfaceWindow.ForeColor), CINT(InterfaceWindow.BackColor), 0, Cancel
 IF NOT Cancel THEN
  TextBox.Text = LoadFile(BuildCompletePath(FilePath, FileName, EXTENSION$))
 END IF
FOM_EndRoutine:
EXIT SUB

FOM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FOM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB FilePrintMenu_Click ()
ON LOCAL ERROR GOTO FPM_ErrorTrap
DIM Cancel AS INTEGER
DIM Choice AS INTEGER
DIM CopyCount AS INTEGER
DIM Count AS INTEGER

 FilePrint CopyCount, CINT(InterfaceWindow.ForeColor), CINT(InterfaceWindow.BackColor), Cancel
 IF NOT Cancel THEN
  FOR Count = 0 TO CopyCount - 1
   Printer.PRINT TextBox.Text
   Printer.ENDDOC
  NEXT Count
 END IF
FPM_EndRoutine:
EXIT SUB

FPM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FPM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

SUB FileSaveMenu_Click ()
ON LOCAL ERROR GOTO FSM_ErrorTrap
DIM Cancel AS INTEGER
DIM Choice AS INTEGER
DIM FileName AS STRING
DIM FilePath AS STRING

 FilePath = CURDIR$
 FileSave FileName, FilePath, "*" + EXTENSION$, "Save file.", CINT(InterfaceWindow.ForeColor), CINT(InterfaceWindow.BackColor), 0, Cancel
 IF NOT Cancel THEN
  SaveFile BuildCompletePath(FilePath, FileName, EXTENSION$), (TextBox.Text)
 END IF
FSM_EndRoutine:
EXIT SUB

FSM_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FSM_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

DEFSNG A-Z
SUB Form_Load ()
ON LOCAL ERROR GOTO FL_ErrorTrap
DIM Choice AS INTEGER

 InterfaceWindow.Width = Screen.Width / 2
 InterfaceWindow.Height = Screen.Height / 2
 InterfaceWindow.Left = (Screen.Width / 2) - (InterfaceWindow.Width / 2)
 InterfaceWindow.Top = (Screen.Height / 2) - (InterfaceWindow.Height / 2)
 InterfaceWindow.WindowState = MAXIMIZED
FL_EndRoutine:
EXIT SUB

FL_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FL_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

DEFINT A-Z
SUB Form_Resize ()
ON LOCAL ERROR RESUME NEXT
 TextBox.Width = InterfaceWindow.ScaleWidth
 TextBox.Height = InterfaceWindow.ScaleHeight
END SUB

SUB Form_Unload (Cancel AS INTEGER)
ON LOCAL ERROR GOTO FU_ErrorTrap
DIM Choice AS INTEGER

 Cancel = (MSGBOX("Do you want to quit?", MB_YESNO OR MB_DEFBUTTON2) = IDNO)
FU_EndRoutine:
EXIT SUB

FU_ErrorTrap:
 Choice = ErrorHandlingPrompt(ERR)
 IF Choice = IDIGNORE THEN RESUME FU_EndRoutine
 IF Choice = IDRETRY THEN RESUME
END SUB

