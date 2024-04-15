; �� ���� �� GUI 
#Singleinstance Force ; ������ ���¿��� ���� ����(�ߺ��� ���μ��� ����)
#NoEnv                  ; ȯ�溯�� ����, ��ũ��Ʈ ȿ����
SendMode Input   ; �ӵ�, ������ ��õ
SetWorkingDir %A_ScriptDir%  ; ���� �۾����� ���� 
#Include %A_ScriptDir%\lib\Gdip_all.ahk ; �̹��� Lib
#Include %A_ScriptDir%\lib\Chrome\Chrome.ahk ; Chrome Lib
SetTitleMatchMode, 2  ; Ÿ��Ʋ �Ϻθ�
CoordMode, Pixel, Screen  ; ��üȭ��  �̹���
CoordMode, Mouse, Screen ; ��üȭ�� ���콺
SetFormat,FLOAT,0.0  ; ���� �Ҽ��� 6�ڸ� X
var+=0
; ================================

; Alt+1(!1) �� ��ǥ Ŭ��
alt1(ByRef X1, ByRef Y1)
{
	MouseGetPos, X1, Y1
	EditorSelect_EngMode() ; ������ ���� �� ������
	SendInput, Click, %X1%, %Y1% `; `nSleep, 1000 `n
}

; Alt+2(!2) �� �̹��� Ŭ�� ��img_click(8, 9,"X.png",5)��5�� ã��
alt2(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2
	fname := Clipboard ".png"
	img_coordinate(fname) ; �̹��� ��ǥ(X1,Y1) ���ϱ�
	aa:=X2-X1  ; Ŭ���� ��ǥ�� - �̹��� ��ǥ��
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, img_click(%aa%`, %bb%, "%fname%") `; �⺻10��{End} `n
}

; Alt+3(!3) �� Titleâ Ȱ��ȭ : �� ������
alt3()
{
	WinGetActiveTitle, WTitle
	EditorSelect_EngMode()
	SendInput, WinActivate, %WTitle% `; Titleâ Ȱ��ȭ `nSleep, 200 `n ; ������ UP
}

;  Alt+4(!4) �� Titleâ�� ���� ������ ���
alt4()
{
	WinGetTitle, WTitle, a  ; Ȱ��â Title�� WTitle�� ���� 
	EditorSelect_EngMode()
	SendInput, �۾�â���("%WTitle%") `; ��Ÿ�� ������ `nSleep, 200 `n
}

; Alt+5(!5) ��  Titleâ �̵�  0,0(�»��) [,Width, Height] �۾�â�̵�
alt5()
{
	WinGetTitle, WTitle, a
	EditorSelect_EngMode()
	SendInput, WinMove, %WTitle%,,0,0 `; ,W,H���� `n ; �»��
}

; �� ����ǥ ���(X1,Y1)
get_pos(ByRef X1, ByRef Y1)
{
	MouseGetPos, X1, Y1
}

; �� �����ǥ Ŭ��
get_pos_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2  ; X1, Y1���� �����ǥ �� ���
	EditorSelect_EngMode()
	aa:=X2-X1
	bb:=Y2-Y1
	SendInput, MouseClick, Left, %aa%, %bb%,1,,,R{space} `; `nSleep, 500 `n
}

; �� ����ǥ �� �ȼ��� ���
get_pixel(ByRef X1, ByRef Y1)
{
	MouseGetPos, X1, Y1
	PixelGetColor, F_color, %X1%, %Y1%, RGB
	Clipboard=
	Clipboard = %F_color%
	ClipWait, 2
	while(true) 
	{
		PixelSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight, %F_color%, , Fast RGB
		if (X1 <> "")
		{
			MsgBox,,,% F_color, 0.5
			break
		}
		MouseMove,0,5,,relative ; �Ʒ��� 5pixel ����
		Sleep, 100
	}
} 

; ^+W�� �ȼ� Ŭ�� �� �����ġ Ŭ��
get_pixel_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2
	MouseMove, 40, 40,,Relative
	aa:=X2-X1
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, pixel_click(%aa%,%bb%,`"{Ctrl down}{v}{Ctrl up}`") `; �ȼ�Ŭ��{End}
	Return
}

Capture_PNG() ; �� �׸�ĸ��
{
	pToken := Gdip_Startup()
	sPATH := A_WorkingDir . "\PIC" ; �۾����� �Ʒ�  PIC ���� 
	if (not FileExist(sPath))           ; PIC ���� ���ٸ� ����
		FileCreateDir, %sPATH%    ; ���� �����϶�
	InputBox,OutputVar,�� ���ϸ�(.png ����) �Է�,�� ���� ���ϸ��� ���� ��� ����ϴ�. `n`n  �� �̹��� Ŭ����� : ���콺 ��ġ ��  Alt`+2,,,,,,,,���ϸ�
	name := A_WorkingDir "\PIC\" OutputVar ".png" ; ������ �����̸�	;~ name := A_ScriptDir "\PIC\" OutputVar ".png" ; ������ �����̸�
	Send, #+s ; �� Win+shift+s
	KeyWait, LButton, D  ; ���ʹ�ư ���������� ���
	KeyWait, LButton, U  ; ���ʹ�ư �������� ���
	sleep, 100
	pBitmap := Gdip_CreateBitmapFromClipboard()
		Gdip_SaveBitmapToFile(pBitmap, name)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	sleep, 200
	Clipboard =
	Clipboard := OutputVar
	ClipWait, 2
	MsgBox,,,ĸ�� �Ϸ�, 0.5
}
 
Open_Workingdir() ; Alt+D(!D) �� �۾� ����
{
	IfWinNotExist, ahk_class CabinetWClass
		Run, %A_WorkingDir%\
	WinActivate, ahk_class CabinetWClass
}

Open_Iwb2() ; Alt+B(!B) �� ���ڵ�ȭ (IE���� ����)
{	
	IfWinNotExist, iWB2 Learner
		run, %A_ScriptDir%\lib\iWB2.exe
	IfWinExist, iWB2 Learner
		WinActivate, iWB2 Learner
	IfWinNotExist, ahk_class NotifyIconOverflowWindow
		run, %A_ScriptDir%\lib\iWB2_Writer.exe
}
	
; �� ������ ����(���������� or Notepad++) �� Eng Mode
EditorSelect_EngMode()
{
	ifwinexist, ahk_exe SciTE.exe
		WinActivate, ahk_exe SciTE.exe
	ifwinexist, ahk_class Notepad++
		WinActivate, ahk_class Notepad++
	ifwinexist, ahk_exe Code.exe  ; vscode
		WinActivate, ahk_exe Code.exe
	WinGetActiveTitle, Title_name
	ret := IME_CHECK(Title_name) ; Eng Mode
	if (ret = 1)
		Send, {vk15sc138}
}

send_enter()
{
	WinGetActiveTitle, Title_name ; Ȱ��ȭ�� ��Ÿ��Ʋ ������
	ret := IME_CHECK(Title_name)
	if (ret = 1)
	{
		SendInput, {vk15sc138}
	} 
	SendInput, Send, {{}enter{}}{left 7}
}

Save_Reload()
{
	Edit
	Sleep, 100
	Send, {CtrlDown}s{CtrlUp} ; Ctrl+S(^s)
	Sleep, 100
	Reload
}


Open_TEST_EXCEL()
{
	IfWinNotExist, TEST_EXCEL
	{
		Run, %A_WorkingDir%\TEST\TEST_EXCEL.xlsx ; �������� ����(Run)
		WinWaitActive, TEST_EXCEL ; Titleâ�� Ȱ��ȭ�� ������  ���
	}
	IfWinExist, TEST_EXCEL
		WinActivate, TEST_EXCEL
	Reload
}	

img_coordinate(ByRef F_name)
{
	global X1, Y1
	Img_Dir := A_ScriptDir "\pic\" F_name
	Loop 
	{
		ImageSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir
		if (X1 <> "")	 ; X1 ���� �ִٸ�
			break        ; Loop Ż��
		if ((A_index = 10) or (A_index = 30) or (A_index = 100))
			MouseMove,1,50,,relative ; ���콺 ���� x
		Sleep, 100
	}
} 

; �� !2 (Alt+2) : �̹��� Ŭ�� / �⺻ 10��
img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=15)
{
	start_time := A_TickCount  ; ���۽ð� - �ҿ� �ð�
	Img_Dir := A_ScriptDir "\PIC\" filename
	while(true) 
	{
		ImageSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir
		if (vx <> "")	
		{
			vx := vx + ax
			vy := vy + ay
			MouseMove, %vx%, %vy%
			Click, Down
			Sleep, 200
			Click, Up  ;~ MouseGetPos, 1X, 1Y
			break
		}
		if ((A_index = 10) or (A_index = 30) or (A_index = 70))
			MouseMove,1,50,,relative ; ���콺�� ���� X
		end_time := (A_TickCount - start_time)
		if (end_time >= ntime*1000)
		{
			MsgBox,,, %ntime% �� �׸�ã�� ����, 1
			Break
		}
		Sleep, 100
	}
}

img_move(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10)
{
	start_time := A_TickCount  ; ���۽ð� - �ҿ� �ð�
	Img_Dir := A_ScriptDir "\PIC\" filename
	while(true) 
	{
		ImageSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir
		if (vx <> "")	
		{
			vx := vx + ax
			vy := vy + ay
			MouseMove, %vx%, %vy%  ; �̵���
			break
		}
		if ((A_index = 20) or (A_index = 40) or (A_index = 70))
			MouseMove,1,50,,relative ; ���콺�� ���� X
		end_time := (A_TickCount - start_time)
		if (end_time >= ntime*1000)
		{
			MsgBox,,, %ntime% �� �׸�ã�� ����, 1
			Break
		}
		Sleep, 100
	}
}

; �� ^+q: �ȼ�Ŭ��(�⺻10��)
pixel_click(ByRef ax, ByRef ay, ByRef fpixel, ByRef ntime=10)
{
	start_time := A_TickCount  ; ���۽ð�(�ҿ�ð� ����)
	while(true){
		PixelSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,fpixel, , Fast RGB
		if (vx <> "")
		{
			vx := vx + ax
			vy := vy + ay
			MouseMove, %vx%, %vy%
			Click, Down
			Sleep, 100
			Click, Up
			break
		}
		if ((A_index = 20) or (A_index = 50) or (A_index = 100))	
			MouseMove,1,30,,relative
		end_time := (A_TickCount - start_time)
		if (end_time >= ntime*1000)
		{
			MsgBox,,, %ntime% �� �׸�ã�� ����, 1
			Break
		}
		Sleep, 100
	} ; End while
} 

; �� !4 (Alt+4) �� �۾�â���
�۾�â���(ByRef Title_name)
{
	IfWinExist, %Title_name%
		WinActivate, %Title_name%
	IfWinNotExist, %Title_name%
	{
		WinWait, %Title_name%
		WinWaitActive, %Title_name%
		loop
		{
			IfWinExist, %Title_name% 
			{
				WinActivate, %Title_name%
				Sleep, 200
				break
			}
			Sleep, 100
		}
	}
}

; �� õ���� ǥ�� : -12,345  ; won Format_Number
won(Amount)
{
	StringReplace Amount, Amount, - 
	IfEqual ErrorLevel,0, SetEnv Sign,- 
	Loop Parse, Amount, . 
		If (A_Index = 1){ 
			len := StrLen(A_LoopField) 
			Loop Parse, A_LoopField
				If (Mod(len-A_Index,3) = 0 and A_Index != len) 
					x = %x%%A_LoopField%, 
				Else x = %x%%A_LoopField% 
			} Else Return Sign x   "." A_LoopField 
		Return Sign x 
}

; �� var ��  Ŭ������ ����+�پ�ֱ�
input_value(ByRef var)
{
	Clipboard =          ; �ʱ�ȭ
	Clipboard := var   ; Ŭ������ �ֱ�
	ClipWait, 2            ; ����� ������ ���
	SendInput, {Ctrl Down}v{Ctrl Up}
}

; �� ���� �˻��� ����(^f) ; �׽�Ʈ��
find_text_enter(ByRef ax)
{
	SendInput, {Ctrl Down}f{Ctrl Up}
	Sleep, 100
	SendInput, %ax%
	Send, {Esc}{Enter}	
}

; �� OCR �����ν� �Լ�����
ocr_num(ByRef var)
{
   var := strreplace(var,"O",0)
   var := strreplace(var,"I",1)
   var := strreplace(var,",")
   var := strreplace(var," ")
   var := strreplace(var,"`r`n",,All)
   var := var * 1
   Return var
}

IME_CHECK(WinTitle)
{  ; �� �ѿ����
	WinGet,hWnd,ID,%WinTitle%
	Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}

Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{
	DetectSave := A_DetectHiddenWindows       
	DetectHiddenWindows,ON                          
	 SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
	if (DetectSave <> A_DetectHiddenWindows)
		DetectHiddenWindows,%DetectSave%
	Return ErrorLevel
}

ImmGetDefaultIMEWnd(hWnd)
{
	return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}


;����: https://www.the-automator.com/excel-and-autohotkey/  ��
{ ; ��� ���� Excel Function  ���
	First_Row_original(xlname){  ; �� ù���(����) : First_Row(��ü��)
	   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
	}
	
	First_Row(xlname){  ; �� Used ù��� : First_Row(��ü��)
	   Loop { ; Used���� ù���� ���� �ƴ϶�� ���� (�ڷ�����)
			if (xlname.Cells(A_index, First_Col_Num(xlname)).value <> ""){
				end_numbers := A_index  ; ������ Row ����
				break
			}
		}
		return end_numbers
	}
	
	Last_Row(xlname){  ; �� ������ ��� (����): Last_Row(��ü��)
		if  (Last_Row_original(xlname)=1) or (Last_Row_original(ex)=1)
			return 1
		var:=xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
		Loop { ; Used ����  7�� �� ��  ������� ���� ���� �ִٸ�  ���߰�  ��� ��ȯ
			if (xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,1).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,2).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,3).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,4).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,5).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,6).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,7).value <>""){
				end_numbers := var - A_index  + 1 ; ������ Row ����
				break
			}
		}
		return end_numbers
	}


	Last_Row_original(xlname){  ; �� ������ ��� (����): Last_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
	}
	
	Used_Row(xlname){  ; �� Used��� : Used_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count
	}
	
	First_Col_Num(xlname){ ; �� ù��° Į�� number
	   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
	}
	
	Last_Col_Num(xlname){ ; �� ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
	}
	
	Used_Col_Num(xlname){ ; �� Used ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count 
	}
	
	First_Col(xlname){  ; �� ù��° Į��  alpabet
		FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
			Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
	}
	
	; �� ���� ���� : 1�̸�  ó������, 0�̸� ��� ����
	Used_Rng(xlname,Header=1){   ; Used_Rng(ex,1) ; Use header to include first row
		if(Last_Row_original(xlname)=1)
			return xlname.Range("1:1")  ; �̰� ....
	IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
	IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
	}
	
	Last_Col(xlname){ ; �� ������ Į�� alpabet : Last_Col(��ü��)
		LastCol:=Last_Col_Num(xlname)	 ; + First_Col_num(xlname) -1
		IfLessOrEqual,LastCol,26, Return, (Chr(64+LastCol))
			Else IfGreater,LastCol,26, return, Chr((LastCol-1)/26+64) . Chr(mod((LastCol- 1),26)+65)
	}
	
		
	;***********************alpha to Number********************************.
	String_To_Number(Column){ ;~ String_To_Number("ab")
		StringUpper, Column, Column
		Index := 0
		Loop, Parse, Column  ; loop for each character
		{ascii := asc(A_LoopField)
			if (ascii >= 65 && ascii <= 90)
			   index := index * 26 + ascii - 65 + 1 ; Base = 26 (26 letters)
			else { return
			} }
			return, index
	}
	
	; �� ���� ����� �� EndRows(ex, 1) ; 1��(A)�� �����
	EndRows(ByRef xlname, ByRef col_num=1){
		num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; ������ �����
		Loop {
			if (xlname.Cells(num - A_index, col_num).value <> ""){
				end_numbers := num - A_index  ; ������ Row ����
				break
			}
		}
		return end_numbers
	}
}


{ ; ��� Pointer to Open IE Window ���
	WBGet(WinTitle="ahk_class IEFrame", Svr#=1){  ;// based on ComObjQuery docs
	   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
			, IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
	;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
	   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
	   if (ErrorLevel != "FAIL"){
		  lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
		  if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
			 DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
			 return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
		  }
	   }
	}

	ClickLink(PXL,Text="")
	{ ; �� iwb2 ���� ��ũ Ŭ��
	ComObjError(false)
	Links := PXL.Document.Links
	Loop % Links.Length
	   If (Links[A_Index-1].InnerText = Text ) { ; search for Text
		  Links[A_Index-1].Click() ; click it when you find it
		  break
	   }
	Sleep, 200
	ComObjError(True)
	}
}  ; �� Pointer to Open IE Window ��


; ��� �ֽ�Ʈ�� ���� ���

excel_New()  ; ���ο� ���� ����, ����, ����(���� ��ũ��Ʈ ������)  ex_new; 
{
	SendInput, `;`�� New���� ����, �Է�, ����(���� ��ũ��Ʈ ������) `nex:=ComObjCreate(`"Excel.Application`") `;New���� ex�� ���� `nex.Workbooks.Add  `; ������ ���� `nex.range(`"A1`").value := 12300 `; �����Է� `nex.range(`"B2`").value := `"�׽�Ʈ �����Է�`" `; �����Է� `nex.DisplayAlerts := false `nex.ActiveWorkbook.Saveas(A_ScriptDir . "\123_Test.xlsx") `;���� `nex.Quit `;���� `nMsgBox, ���ο� ������ �����Ǿ����ϴ� `n
}

excel_read() ; ���� ���� ����
{
	SendInput, `;`�� ���� ���� ���� `npath := A_ScriptDir . `"\TEST\TEST_EXCEL.xlsx`" `; ��ũ��Ʈ ������ �������� `nex := ComObjCreate(`"Excel.Application`") `; ex ���� `nex.Workbooks.Open(path) `; �������� `nex.Visible := true `; ���̱� `n`; ex.DisplayAlerts := false  `; Ȯ��, ��� X `n`; ex.ActiveWorkbook.Save() `; �����̸� ����, �ٸ��̸��� ��ȣ�� `n`; ex.quit `; ���� `n
}

excel_Open()  ; ex_open; ���� ���� ����
{
	SendInput, `;`�� �̹� �����ִ� ���� ���� `nex:=ComObjActive(`"Excel.Application`") `;`�῭���ִ¿��� ex�� ���� `nex.sheets(`"DB`").select `;��Ʈ�� Ȯ�Ρڡ� `nMsgBox, `% `"ù�� `" First_Row(ex) `" `/ ���� `" Last_Row(ex) `" `/ ù�� `" First_Col(ex) `" `/ ���� `" Last_Col(ex) `" `/ ù���� `" First_Col_num(ex) `" `/ ������ `" Last_Col_num(ex) `" `/ Used�� `" Used_Row(ex) `" `/ Used�� `" Used_col_num(ex) `" `/ ���ؿ� ����� `"  EndRows(ex, First_Col(ex)) `; ��ȿ������ 1��°���� ����� `n{;}ex.Range(`"b2`").End(-4121).Select `;��Ư������ ���� ���� -4121(xldown),-4162(xlup) `; ����ּ� Offset(��,��) `n
}

excel_Arr()
{
	SendInput, ex:=ComObjActive(`"Excel.Application`") `; �����ִ� ���� ex�� ���� `nex.sheets(`"DB`").select `; ��Ʈ ���á�  ��迭 Arr ���� �� ����� Arr[��,��] `nArr:=ex.Range(First_Col(ex) . First_Row(ex) . `"`:`" Last_Col(ex) . Last_Row(ex)).value `nnums:=EndRows(ex,1) `; X�� ����� `nnum:=EndRows(ex,1) - First_Row(ex) {+} 1 `; X�� �����-�迭��ġ `nMsgBox `% `"A����� `: `" nums `" `/ �迭�� Arr[num,3] : `" Arr[num,3] `n`; ex.Range(`"A`" . num).value = ex.cells(num,1).value = Arr[num,1] `n
}


chrome_auto()
{
	SendInput, Chrome:=new Chrome()`nPg:=Chrome.GetPage() `nPg.Call(`"Page.navigate`", {{}`"url`"`: `"https://naver.com`"{}}) `nPg.WaitForLoad() `n; �� Copy Selector ValueȰ�� or pg.sel �ڵ��Է� `npg.Evaluate(`"document.querySelectorAll('{#}query')[0].value='AHK'`") `npg.Evaluate(`"document.querySelectorAll('{#}search_btn')[0].click()`") `nPg.WaitForLoad() `n`;pg.Evaluate(`"document.querySelectorAll('X')[0].value = `" Chrome.Jxon_Dump(Var)) `nMsgBox, Ȯ�� �� �ڵ� ����˴ϴ�. `nPg.Call(`"Browser.close`") `nPg.Disconnect() `n
}

web_auto()
{
	SendInput, pwb:=WBGet() `; �������� {!}B `npwb.Navigate(`"www.naver.com`") `;�ּҿ��� `nwhile pwb.busy or pwb.ReadyState <>4 `nSleep, 100 `n`;ClickLink(pwb,Text:="Text") `;���ڸ�ũ Ŭ�� `n`;pwb.document.getElementByID("XX").click() `; Ŭ�� `n`;pwb.document.getElementByID("XX").Value :="XX" `;ID�� ���Է� `n`;pwb.document.getElementsByClassName("XX")[0].Value :="XX" `; Ŭ������ ���Է�, Name, TagName `n
}

ymd(var_date){
StringReplace, var,var_date, -,,All
return var
}

; flist;  �ֽ�Ʈ��  File_List("c:\") ���ϸ� / File_List("c:\",1) Ȯ��������, 2 Full
File_List(ByRef Dir, ByRef ext=0){  ; File_List("��θ�"[,01]) ; List_Arr[1]
	global List_Arr := []
	Loop, % Dir 	;~ Loop, % Dir . "*.*"
	{
		if(ext = 0)
		{
			StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
			List_Arr.Push(FileNameNoExt)
		}
		if (ext=1)
		{
			List_Arr.Push(A_LoopFileName) ; Ȯ���� ����
		}
		else
		{
			List_Arr.Push(A_LoopFileFullPath)
		}
	}
	return List_Arr
}


; �� ���̹� �α���
naver_login()
{
	Chrome:=new Chrome()
	Pg:=Chrome.GetPage()
	Pg.Call("Page.navigate", {"url": "https://naver.com"})
	Pg.WaitForLoad()
	Sleep, 200
	pg.Evaluate("document.querySelectorAll('#account > a > i')[0].click()") 
	Pg.WaitForLoad()	
	Sleep, 1000
	Send, {Tab 10}{Enter}
}


begin_ahk()  ; �ʱ⼼��
{
	SendInput, {#}Singleinstance Force `; ������ ���� �������� `n{#}NoEnv `; ȯ�溯�� ���� `nSendMode Input `; �ӵ�, ������ ��õ `nSetWorkingDir `%A_ScriptDir`%  `; ���� �۾����� ���� `nCoordMode, Pixel, Screen    `; ��üȭ��  �̹��� ���� `nCoordMode, Mouse, Screen `; ��üȭ�� ���콺 `nSetFormat,FLOAT,0.0  `; �Ҽ��� 6�ڸ� ����(�Ʒ��ٰ� �Բ�) `nvar{+}{=}0 `n
}

Auto()
{
	SendInput, `; 1. ��ǥ   Ŭ�� :                   Ŭ����ġ �̵� ��  ALT{+}1 `n`; 2. �̹��� Ŭ��: �׸�ĸ�ġ�Ŭ����ġ �̵� ��  ALT{+}2 `n`; 3. �۾�â Ȱ��ȭ : �۾��� â Ŭ�� ��  ALT{+}3 `n`; 4.    `"    �ε���� :        `"        Ŭ�� ��  ALT{+}4 `n`; 5.    `"    �̵��»� :        `"        Ŭ�� ��  ALT{+}5 `n`; 6. �ȼ� Ŭ�� : {^}{+}q(�ȼ��� ���) �� {^}{+}w(Ŭ�� ��ġ) `n`; 7. ��� Ŭ�� : {^}q(���� ��ǥ��ġ) �� {^}w(Ŭ�� ��ġ) `n
}