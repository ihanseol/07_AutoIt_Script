{  ; �� �⺻���� ��  F5Ű �� GUIâ Show : �ڵ�ȭ ���� �� �̹���<�ȼ�<����Ű ��
	#Singleinstance Force
	#NoEnv
	SendMode Input
	SetTitleMatchMode, 2  ; �Ϻθ�
	SetWorkingDir %A_ScriptDir%
	SetFormat,FLOAT,0.0  ; ���� ������, �Ҽ���X(1.000000)
	var+=0
	Gui, Add, Button, x10 y5 w60, ���ÿ���   ; 1��1��
	Gui, Add, Button, y+5 w60, �����Է�
	Gui, Add, Button, x75 y5 w60, �޽���â   ; 1��2��
	Gui, Add, Button, y+5 w60, �޸𾲱�
	Gui, Add, Button, x140 y5 w60, �����ѱ� ; 1��3��
	Gui, Add, Button, y+5 w60, �����ݺ�
	Gui, Add, Edit, x20 y65 w25 h17 +Center vȽ��,1 ; �ݺ� Ƚ��
	Gui, Add, Text, x+3 y67 w10 h17, ȸ
	Gui, Add, Button, x75 y60 w60, ����
	Gui, Add, Button, x+5 w60, ����ε�
	Gui, +Alwaysontop
	Gui, Show, x1480 y0 w215 h93, ExcelȰ��
	return
	
	GuiClose:     ; GUIâ ������ (X Ŭ��) ����
	ExitApp
	
	^e::
	Button����:      ; guiâ "����/����" ��ư
	Edit
	return
	
	^r::
	Button����ε�:      ; guiâ "����/����" ��ư
	Edit
	Sleep, 100
	Send, {CtrlDown}s{CtrlUp} ; ����
	Sleep, 100
	Reload  ; �ٽ� �ε�
	return
}


Button���ÿ���:  ; ����, �ѱ�, web  ========
{   ; �� ����, �ѱ�, �� ����  ����  %A_ScriptDir%\DB
	Run, C:\Program Files\Internet Explorer\iexplore.exe %A_ScriptDir%\TEST_WEB.html
	IfWinNotExist, TEST_HWP����Ʋ.hwp
		Run, %A_ScriptDir%\TEST_HWP����Ʋ.hwp
	IfWinExist, TEST_HWP����Ʋ.hwp
		WinActivate, TEST_HWP����Ʋ.hwp
	IfWinNotExist, TEST_HWP.hwp
		Run, %A_ScriptDir%\TEST_HWP.hwp
	IfWinExist, TEST_HWP.hwp
		WinActivate, TEST_HWP.hwp
	IfWinNotExist, TEST_EXCEL  ; �� ���� �ҷ�����
		Run, %A_ScriptDir%\TEST_EXCEL.xlsm
	IfWinExist, TEST_EXCEL
		WinActivate, TEST_EXCEL
	WinWaitActive, TEST_EXCEL
	Sleep, 500
	Reload   ; ��ε�,  XL�Լ� �ε�
}
return

; �� WebPage �������� ���� =============
Button�����Է�:  ; �������� �Է�
{
	Gui, Submit, NoHide ; GUI�� �б�
	ex := ComObjActive("Excel.Application") ; �����ִ� ���� ex
	ex.sheets("DB").select      ; �۾���Ʈ ����
	WinActivate, TEST_WEB.html ;âȰ��ȭ
	Sleep, 200
	loop, %Ƚ��% { ; �� Ƚ�� ����
		A_endRow:=EndRows(ex,1)  ; A��  ����(�۾�����)
		pwb := WBGet() ; �� ������ ����/ IWB2
		pwb.document.getElementByID("fname").Value:=ex.Range("C"A_endRow).value ; �� ����
		pwb.document.getElementByID("uname").Value:=ex.Range("D"A_endRow).value ; �� ��ü��
		pwb.document.getElementByID("sumname").Value:=ex.Range("E"A_endRow).value ; �� ���ݾ�
		pwb.document.getElementByID("datename").Value:=ex.Range("F"A_endRow).value ; �� �Ͻ�
		pwb.document.getElementByID("partname").Value:=ex.Range("G"A_endRow).value ; �� �����μ�
		if ex.range("B"A_endRow).value = "����"                         ; �� ���籸��
			pwb.document.getElementByID("male").checked :=1
		if ex.range("B"A_endRow).value = "�뿪"
			pwb.document.getElementByID("female").checked :=1
		if ex.range("B"A_endRow).value = "��ǰ"
			pwb.document.getElementByID("other").checked :=1
		pwb.document.getElementByID("rhksso").checked :=1   ; �� ��������
		Sleep, 700
		pwb.document.GetElementsByTagName("INPUT")[10].click()
		Sleep, 300
		ex.Range("A"A_endRow+1):="=row()-1"
	}
MsgBox,,, IWB2 Ȱ���ϱ� �ʿ�� �ݺ�Ƚ�� ���� ����,1.5
}
return


Button�޽���â:  ; �� �޽���â �Է�  =======
{   ; �� DB ������(�迭) ���� �� �޽���â���� ���� ����
	WinActivate,  ahk_exe EXCEL.EXE ;â Ȱ��ȭ
	ex := ComObjActive("Excel.Application") ; �����ִ� ���� ex�� ����
	ex.sheets("DB").select  ; �۾���Ʈ ����
	Anum:=EndRows(ex,1)  ; A��  ����(�۾�����)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; �۾����� Arr[��,��]
	data=  ; �ʱ�ȭ
	loop, %Anum% {  ; �� MsgBox ǥ���ϱ�
		data.=Arr[A_index, 1] . "/" . Arr[A_index, 2] "/" . Arr[A_index, 3] "/" . Arr[A_index, 4] "/" . Arr[A_index, 5] "/" . Arr[A_index, 6] "/" . Arr[A_index, 7] "`n"
	} 
	MsgBox,,�۾� �Ϸ�, % data "`n �� DB��Ʈ �迭 Ȱ��"
}
return

Button�޸𾲱�: ; �� �޸��忡  ���� �Է� ====
{
	WinActivate, ahk_exe EXCEL.EXE ;â Ȱ��ȭ
	ex := ComObjActive("Excel.Application")
	ex.sheets("DB").select    ; �۾���Ʈ ����
	Anum:=EndRows(ex,1)  ; A��  ����(�۾�����)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; �۾����� Arr[��,��]
	Run, notepad.exe  ; ��Ʈ�е� ����
	Sleep, 1000
	SendInput, �� A�� �������� �ݺ� (ArrȰ��){enter}
	SendInput, {= 40}{enter}
	Loop, %Anum% {
		Loop_num:=A_Index
		Loop, % Used_col_num(ex) {  ; ���� ���� ��
			SendInput, % Arr[Loop_num, A_Index] " "
		}
		SendInput, {enter}
	}
	MsgBox, ��Ʈ�е� �Է��ϱ� ���� `! `n`n Ȯ���� ������ �ڵ� ����
	WinClose, �޸���
	WinWaitActive, �޸���
	Send, n
	return
}


; ���� ����_�ѱ� �����  �پ��� ����� ����

Button�����ѱ�:
{
	; �� �迭 + ���ڰ˻� �̵� �� �Է�
	WinActivate,  TEST_EXCEL
	ex := ComObjActive("Excel.Application") ; �������� ex ����
	ex.sheets("DB").select     ; �۾���Ʈ ����
	A_num:=EndRows(ex,1)  ; A��  ���� (�۾� ������)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; Arr[��,��] �迭����
	WinActivate,  TEST_HWP.hwp ; �� HWP  Ȱ��ȭ
	Sleep, 500
	SendInput, ^{PGUP} ; ���� ó������ �̵�
	Sleep, 300
	�˻��̵�("������ȣ")     ; ## ������ȣ �˻��̵�
	Sleep, 200
	SendInput, !{right 2}^{a}
	Sleep, 100
	input_value(Arr[A_num,6]) ;~ var:=Arr[A����,6] ; clip_copy(var)
	Sleep, 100
	�˻��̵�("��    ��")          ; ## ���� �˻��̵�
	Sleep, 100
	SendInput, !{right}^{a}
	Sleep, 100
	input_value(Arr[A_num,3])
	Sleep, 100
	�˻��̵�("1. ��")  ; ## �ҿ�ݾ� �˻��̵�
	Sleep, 100
	SendInput, !{right}^{a}
	Sleep, 100
	dd := won(Arr[A_num,5])  ; õ��ǥ��(,)
	Sleep, 100
	SendInput, ��%dd%��
	Sleep, 100
	SendInput, ^{PGUP}
	ex.sheets("DB").cells(A_num+1, 1) := "=row()-1"
	MsgBox,,,�۾��Ϸ�  �� �迭 `n`nA�� ���� ����
	
}
return


Button�����ݺ�:   ; ��  ����Ʋ �κ�Ȱ�� : �ټ� ������ ���� ===
{
	Gui, Submit, NoHide       ; GUI �б�(�ݺ� Ƚ��)
	WinActivate,  TEST_EXCEL	
	Sleep, 300
	ex := ComObjActive("Excel.Application") ; �������� ����
	ex.sheets("DB").select      ; �۾���Ʈ ����
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; Arr[��,��] �迭
	loop, %Ƚ��%  
	{
		WinActivate, TEST_HWP����Ʋ.hwp
		Sleep, 500
		Send, ^{PGUP}
		Sleep, 200
		Send, !g!r{tab}����Ʋ{enter} ; �� �ȵ���?
		Sleep, 200
		send, {right}{ShiftDown}{End}{Left}{ShiftUp}
		Sleep, 100
		SendInput, % ex.Range("F" . EndRows(ex,1)).value  ; �� ���� �Է� 
		Sleep, 100
		SendInput, {right}
		Sleep, 200
		Send, !g!r{tab}����Ʋ{enter}{right}{ShiftDown}{End}{Left}{ShiftUp}
		Sleep, 100
		Clipboard:=ex.Range("C" . EndRows(ex,1)).value
		Sleep, 200
		SendInput, {CtrlDown}v{CtrlUp}      ;  �� ���� �Է�
		Sleep, 100
		SendInput, {Right} 
		Sleep, 100
		Send, !g!r{tab}����Ʋ{enter}{right}{ShiftDown}{End}{Left}{ShiftUp}
		dd := won(ex.Range("E" EndRows(ex,1)).value)  ; õ��ǥ��(,)
		Sleep, 100
		SendInput, ��%dd%��  ; �� �ҿ�ݾ� 
		Sleep, 100
		SendInput,^{PGUP}
		Sleep, 100
		ex.Range("A" EndRows(ex,1) +1):="=ROW()-1" ; A����+1
	}
	MsgBox,,,��/�� ����Ʋ(^KE) �� ������, 1.5
}
return
	


; First_Row(ex), Last_Row(ex), First_Col(ex), Last_Col(ex), EndRows(ex,1)
 { ; Excel Function
	First_Row(xlname)
	{  ; ù��� : First_Row(��ü��)
	   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
	}

	Last_Row(xlname)
	{  ; ������ ��� : Last_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
	}
	
	Used_Row(xlname)
	{  ; Used��� : Used_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count
	}
	
	First_Col_Num(xlname)
	{ ;  ù��° Į�� number
	   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
	}
	
	Last_Col_Num(xlname)
	{ ;  ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
	}
	
	Used_Col_Num(xlname)
	{ ;  Used ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count 
	}
	
	First_Col(xlname)
	{  ; ù��° Į��  alpabet
		FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
			Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
	}
	
	; ��ȿ����(����)  : 1�̸�  ó������, 0�̸� ��� ����
	Used_Rng(xlname,Header=1)
	{   ; Used_Rng(ex1,Header:=1) ;Use header to include/skip first row
		IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
		IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
	}
	
	Last_Col(xlname)
	{ ; ������ Į�� alpabet : Last_Col(��ü��)
		LastCol:=Last_Col_Num(xlname)	 ; + First_Col_num(xlname) -1
		IfLessOrEqual,LastCol,26, Return, (Chr(64+LastCol))
			Else IfGreater,LastCol,26, return, Chr((LastCol-1)/26+64) . Chr(mod((LastCol- 1),26)+65)
	}
	
	String_To_Number(Column)
	{ ;~ String_To_Number("ab")
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
	
	; ���� ����� �� EndRows(ex, 1) ; 1��(A)�� �����
	EndRows(ByRef xlname, ByRef col_num=1)
	{
		num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; ������ �����=endRow
		Loop 
		{
			if (xlname.Cells(num - A_index, col_num).value <> "")
			{
				end_numbers := num - A_index  ; ������ Row ����
				break
			}
		}
		return end_numbers
	}
}


{ ; �� Pointer to Open IE Window ��
	WBGet(WinTitle="ahk_class IEFrame", Svr#=1) 
	{  ;// based on ComObjQuery docs
	   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
			, IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
	;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
	   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
	   if (ErrorLevel != "FAIL") 
	   {
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
	   If (Links[A_Index-1].InnerText = Text ) 
	   { ; search for Text
		  Links[A_Index-1].Click() ;click it when you find it
		  break
	   }
	Sleep, 300
	ComObjError(True)
	}
}  ; �� Pointer to Open IE Window ��

; �۾�â�� ��Ÿ��(�ε�) ������ ���
 �۾�â���(ByRef Title_name)
 {
	WinWait, %Title_name%
	WinWaitActive, %Title_name%
	loop	
	{
		IfWinExist, %Title_name% 
		{
			WinActivate, %Title_name%
			Sleep, 200  ; �߰� ������ ���
			break
		}
		Sleep, 100
	}
}

; �� Ctrl+F��  ���ڰ˻� �̵���  / ���� ���
�˻��̵�(ByRef var)
{
	Clipboard:=
	Clipboard:=var
	ClipWait, 2
	SendInput, {Ctrl Down}f{Ctrl Up}
	Sleep, 100
	SendInput, {Ctrl Down}{v}{Ctrl Up}{Enter}
	Sleep, 100
	SendInput, {Esc 2}
}

; �� var ��  Ŭ������ ����+�پ�ֱ�  / �ѿ�ȥ�� �Է½� ���� ����
input_value(ByRef var)
{
	Clipboard =         ; Ŭ������ ����
	Clipboard := var  ; Ŭ�����忡 ����var �� �ֱ�
	ClipWait, 2           ; Ŭ�����忡 ����� ������ ���
	SendInput, {Ctrl Down}v{Ctrl Up}  ; Ctrl+V  �ٿ��ֱ�
}

; �� õ���� ǥ�� : -12,345  ; �� won Format_Number
won(byref Amount) 
{
	StringReplace Amount, Amount, - 
	IfEqual ErrorLevel,0, SetEnv Sign,- 
	Loop Parse, Amount, . 
		If (A_Index = 1) { 
			len := StrLen(A_LoopField) 
			Loop Parse, A_LoopField
				If (Mod(len-A_Index,3) = 0 and A_Index != len) 
					x = %x%%A_LoopField%, 
				Else x = %x%%A_LoopField% 
			} Else Return Sign x   "." A_LoopField 
		Return Sign x 
}
