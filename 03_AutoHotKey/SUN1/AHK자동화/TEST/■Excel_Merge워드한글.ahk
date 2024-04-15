{   ; �� GUI Section  �� �Ƕ��� ������� ����
	#Singleinstance Force
	SendMode Input
	SetWorkingDir %A_ScriptDir% ; ���� �۾�����
	Gui Add, Edit, x10 y10 w320 h22 vFolder, %A_ScriptDir%\DB ;����
	Gui Add, Button, x+10 w60 h22, ��������
	Gui Add, Edit, x10 y45 w320 h22 vResult, %A_ScriptDir%\Excel_Merge.xlsx
	Gui Add, Button, x+10 w60 h22, ��������
	Gui Add, Text, x10 y75 w390 h2 +0x10 ; line
	Gui Add, Button, x10 w55 h25, ��������
	Gui Add, Button, x+10 w55 h25 vBtn_name, ��Ʈ����
	Gui Add, Text, x+10 w10 h25, �Ƣ�
	Gui Add, Button, x+10 w55 h25, ��������
	Gui Add, Button, x+10 w55 h25, �ѱ�����
	Gui Add, Text, x+10 w10 h25, �Ƣ�
	Gui Add, Button, x+10 w45 h25, �ʱ�ȭ
	Gui Add, Button,x+10 w30 h22, ����
	Gui, +Alwaysontop
	Gui Show, x1500 y20 w410 h120, Excel_Word_Hwp
	Return
}


{  ;���� GUI ���� ���� ����
	GuiClose:
	ExitApp

	Button��������: ; �� "��������" ��ư Ŭ���� ����
	{
		Gui, Submit, nohide
		FileSelectFolder, folder,,3 ; ��������  3
		if Folder = 
			MsgBox, ������ ���õ��� �ʾҽ��ϴ�.
		else
			GuiControl, , Folder, %folder%  ; �������� Folder ������
	}
	return ; ��� �����

	Button��������:
	{
		Gui, Submit, nohide
		FileSelectFile, filename,3,%A_ScriptDir% , �������� �����ϼ���, *.xlsx
		if filename = 
			MsgBox, ������ ���õ��� �ʾҽ��ϴ�.
		else
			GuiControl,, Result, %filename%  ; ���ϸ� Result ������ UPdate
	}
	return

	^e::
	Button����:
	Edit
	return

	^r::
	ButtonReload:
	Edit
	Sleep, 100
	Send, ^s
	Sleep, 100
	Reload
	return
}


Button�ʱ�ȭ:
{  ; �� ���� �ڷ� ����
	Gui, Submit, nohide
	IfWinExist, Excel_Merge    ; Titleâ Ȱ��ȭ
		ex := ComObjActive("Excel.Application")  ; �����ִ¿��� �����
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; ������ : ex.Workbooks.Add 
		ex.Workbooks.Open(Result)  ; �������� ���� FileSelectFile, path
	}	
	ex.Visible:=True
	Arr:=["WORD","HWP","EXCEL"]   ; �迭 �ʱⰪ ����
	loop, % Arr.length(){
		ex.sheets(Arr[A_Index]).select   ; �迭  A_index ��Ʈ ����
		ex.cells(1,1).select ; A1�� ����(���� ���ù��� �ʱ�ȭ)
		if (ex.range("A2").value != "")    ; A2 ������ �ִٸ�  ;ex.ActiveSheet.UsedRange.clear
			ex.ActiveSheet.Range("2:1000").delete ; 2������ 1000�� ����
		ex.Range("A1").select
	}
	WinActivate, Excel_Merge
	ex.ActiveWorkbook.Save() ; ����
	MsgBox,,, �ʱ�ȭ �Ϸ�, 1
	Reload	
}  ; End  �ʱ�ȭ
return


Button��������:   ; �� ������ ���� ����
{
	Gui, Submit, nohide
	;�� 01������ ���� ���� : �����ִ��� ������ Ȯ�� �� ex����
	IfWinExist, Excel_Merge   ; Titleâ �����ϸ� Ȱ��ȭ
		ex := ComObjActive("Excel.Application")  ; ex����
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; ex ����
		ex.Workbooks.Open(Result)  ; ���� ���� ; FileSelectFile, path
	}
	ex.Visible:=True ; ���̰�
	WinActivate, Excel_Merge ; âȰ��ȭ
	ex.sheets("EXCEL").select
	ex.Range("A1").select
	; �� 02 ������(ex1) ���� �� ������ ���� ��������(GUI ��)
	;~ Folder:= A_ScriptDir . "\DB\*.xlsx" ; ���� �� ȭ�ϼ��� / �������ý�
	;~ FileSelectFolder, folder,,3 ; ���� ����	;FileSelectFolder, folder,%A_ScriptDir%, 3
	ex1:=ComObjCreate("Excel.Application") ; ex1 ����(����)
	loop, %folder%\*.xlsx ; �Ǵ�  c:\*.xlsx ó�� ���� �Է�
	{
		ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ;���Ͽ���
		ex1.Visible:=False ; �Ⱥ��̰� 
		ex1.sheets(1).select  ; 1��° ��Ʈ ���� �ڡ�
		ex1.cells(1,1).select  ; A1�� ����
		if (A_index = 1)   ; ����ȿ����(���� )���� / 1��°�� �������
			Used_Rng(ex1, 1).Copy ; ��� 1�� 0�� + ���� ����
		else
			Used_Rng(ex1, 0).Copy ; ��� X ���븸 ����
		ex.Range("A" . Last_Row(ex) +1).Select ; A�� ���� + 1 ����
		ex.ActiveSheet.Paste ; �ٿ��ֱ�(^v)
		ex.cells(1,1).select
		ex1.Application.CutCopyMode:=false ; ������ ���� 
		ex1.Workbooks.Close ; �����ݱ�(ex1������)
	}
	ex1.Quit ; ex1 ���� ����
	ex.cells(1,1).select
	ex.Visible:=True
	ex=  ; �ʱ�ȭ
	ex1=
	MsgBox, ������ �������� ���� �Ϸ� `n`n 1��° ��Ʈ�� ���� �ڡ� ������ ���� ����
}
return

;==========================

Button��Ʈ����:   ; �� ���� �� ���������� ��� ��Ʈ ����
{
	Gui, Submit, nohide
	GuiControl,,Btn_name,������  ; ��Ʈ���� ��ư��  ������  ǥ��
	ex:=ComObjCreate("Excel.Application") ; ex ��������(����)
	ex.Workbooks.Add ; ���� ����
	ex.Visible:=true
	FileArr:=[] ; �� 02 ������ ���ϸ� �迭 ����
	loop, %folder%\*.xlsx 
	{
		StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
		FileArr.push(FileNameNoExt)
	}
	; �� 03 ���� �� �������� : C:\Users\USER\Downloads\samples
	ex1:=ComObjCreate("Excel.Application") ; ex1 ���� ����
	num:=1  ; ���ϸ���Ʈ�� ����
	loop, %folder%\*.xlsx 
	{
		ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ; ����
		ex1.Visible:=False
		if ((num=1) and (ex1.sheets.count = 1)) 
		{  ; �� 1ȸ�ݺ�, ��Ʈ 1�̸�
			ex1.sheets(num).cells.copy
			ex.ActiveSheet.name:=FileArr[num]
			ex.Activesheet.paste
			ex.Activecell.cells(1,1).select
			ex1.Application.CutCopyMode:=false
		}
		else if ((num =1) and (ex1.sheets.count != 1)) 
		{  ; ��1ȸ, ��Ʈ 2�� �̻��̸�
			loop, % ex1.sheets.count
			{
				if (A_index = 1)
				{
					ex1.sheets(1).cells.copy
					ex.ActiveSheet.name:=FileArr[num] "_" ex1.ActiveSheet.name "_" A_index
					ex.Activesheet.paste
					ex.Activecell.cells(1,1).select
					ex1.Application.CutCopyMode:=false
				}
				else
				{
					ex1.sheets(A_Index).cells.copy
					ex.Sheets.Add(ComObjMissing(), ex.Sheets(ex.Sheets.Count))
					ex.ActiveSheet.name:=FileArr[num] "_" ex1.ActiveSheet.name "_" A_index
					ex.Activesheet.paste
					ex.Activecell.cells(1,1).select
					ex1.Application.CutCopyMode:=false
				}
			}
		}
		else 
		{  ; ����Ʈ�� 2�� �̻�
			loop, % ex1.sheets.count 
			{
				ex.Sheets.Add(ComObjMissing(), ex.Sheets(ex.Sheets.Count)) ;��Ʈ+
				ex.ActiveSheet.name:=FileArr[num]  "_" ex1.sheets(A_index).name "_" A_Index
				ex1.sheets(A_Index).cells.copy
				ex.Activecell.select
				ex.Activesheet.paste
				ex1.Application.CutCopyMode:=false
			}
		}
		ex.Activecell.cells(1,1).select
		ex1.Workbooks.Close
		num++  ; 1�� ����
	}
	ex1.Quit
	
	; �� 02 ��Ʈ���� �ϱ�
	ex.sheets(1).select
	ex.sheets.add
	ex.Activesheet.name:="����"
	;��02 ��Ʈ ����
	loop, % ex.Sheets.Count ; ��Ʈ ���� �ݺ�
	{
		ex.sheets(A_index).select
		if (ex.ActiveSheet.name <>"����")
		{
			ex.Range("A1").select
			if (A_index = 2) ;1ȸ(����), 2ȸ �ݺ��̸�	; �� 03 ��ȿ���� ����
				Used_Rng(ex, 1).Copy ;�ڷ���� ����(1 ���O)
			else
				Used_Rng(ex, 0).Copy ;�ڷ���� ����(0 ���X)
			ex.sheets("����").select
			ex.Range("A" . Last_Row(ex)+1).select ; ������ġ(����+1)
			ex.ActiveSheet.paste
			ex.Application.CutCopyMode:=False
			ex.cells(1,1).select
		}
	}
	ex.cells(1,1).select
	ex=
	ex1=	;~ ex.ActiveSheet.Cells.Columns.AutoFit ; ���ʺ� �ڵ� ����
	GuiControl,,Btn_name,��Ʈ����
	MsgBox, ��Ʈ���� �Ϸ�  ������ �Ŀ����� ����
}
return


Button��������:     ; �� Word - Excel ���� ====
{
	Gui, Submit, nohide
	; �� 01���� �� ���տ��� ������� ------------------------------
	;~ Folder:= A_ScriptDir . "\DB\*.docx" ; ���� �� wordȭ��
	;~ expath:= A_WorkingDir . "\excel_word.xlsx" ; �������
	; �� 02������ ��������(sheet select) -----------------------------
	IfWinExist, Excel_Merge  ; Titleâ Ȱ��ȭ
		ex := ComObjActive("Excel.Application")  ; �����ִ¿��� ex
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")
		ex.Workbooks.Open(Result)  ; ���� ���� FileSelectFile, path
	}	
	ex.Visible:=True
	Sleep, 1000
	ex.sheets("WORD").select ; ������ ��Ʈ ����
	ex.cells(1,1).select
	Loop, %Folder%\*.docx
	{ 	; �� word ���� ����(��ȯ)
		run, %A_LoopFileFullPath%  ; ������ü���/���ϸ� ����
		WinWaitActive, ahk_exe WINWORD.EXE
		Sleep, 1000
		word_data_Add()  ; ��� word ����, ������ ���� ����, word �ݱ� ��
		row := ex.Sheets("WORD").UsedRange.Rows.Count + 1
		col :=1
		ex.Cells(row,col).Formula := "=row() -1" ; �� ������ ���� ����
		Loop, 13{  ; 13�� �ݺ�
			ex.Cells(row,col+A_index).value :=Arr[A_index]
		}
		ex.ActiveWorkbook.Save()
		sleep, 500
	} ; End loop
	MsgBox, ���幮�� ���� �۾���  �Ϸ�Ǿ����ϴ� `n`n�ඥ��������� ����
	Reload
} ; end �������� ����
return

word_data_Add() ; �� Function ;���� ����, ��������, ���� �ݱ� ��
{    ; ST ������(60) ���� 
	global
	Arr := []  ; �迭 ����
	; �迭 ù��° �ε�����  ��� �Ҵ��Ϸ��� Arr[1] := ��  / Arr.push("��") / ���� Arr.lenght()
	; �� �ڷ� Ŭ������ ����, �� ������ �Ҵ�
	WinActivate, ahk_exe WINWORD.EXE ; âȰ��ȭ
	Sleep, 1000
	SendInput, {CtrlDown}{PgUp}{CtrlUp} ; ��ó�� �̵�
	Sleep, 500
	Send, {Tab 2} ;�̸�ĭ �̵��ϸ� �ڵ���� ���õ�
	Arr.Push(Wclip_copy()) ; 1��  �̸�
	SendInput, {Tab 2} ; �������
	Arr.Push(Wclip_copy()) ; 1�̸�,2����
	SendInput, {Tab 4} ; ����
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����
	SendInput, {Tab 2} ;�ּ�
	addr := StrReplace(Wclip_copy(), "`r`n") ; ����(`n or `r) ���� 	
	addr := Trim(addr)  ; Trim(String,Chars]) ���� or Ư������ ����
	Arr.Push(addr) ; 1�̸�,2����,3����,4�ּ�,  ����
	SendInput, {Tab 2} ;�޴���
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����,4�ּ�,5HP,
	SendInput, {Tab 4} ;email
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,
	SendInput,{Tab 2} ; ȸ��
	buso := StrReplace(Wclip_copy(),"(ȸ���)")  ; (ȸ���)  ���ڿ�  ����
	buso := StrReplace(buso, "`r`n") ; 
	buso := Trim(buso) ; �¿� ����(��ĭ) ����
	Arr.Push(buso) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,
	SendInput, {Tab 2} ;fax
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,
	SendInput, {Tab 2} ;ȸ���ּ�
	busoaddr := StrReplace(Wclip_copy(), "(�ּ�)")  ;(�ּ�) X
	busoaddr := StrReplace(busoaddr, "`r`n")
	busoaddr := Trim(busoaddr)
	Arr.Push(busoaddr) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,9ȸ���ּ�,
	SendInput, {Tab 4} ; �Ի���
	cdate :=StrReplace(Wclip_copy(),".","-")
	Arr.Push(cdate) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,9ȸ���ּ�,10�Ի���
	SendInput, {Tab} ; ��
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,9ȸ���ּ�,10�Ի���,11��
	SendInput, {Tab} ;����
	Arr.Push(Wclip_copy()) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,9ȸ���ּ�,10�Ի���,11��,12����,
	SendInput, {Tab} ;
	sstart := Instr(Wclip_copy(),"�����մϴ�.") +7 ; �����մϴ�+7 ��ġ
	ssend := Instr(Clipboard, "��û��" ) - 1 ; ��û�� - 1 ��ġ
	length := (ssend - sstart) 
	sdate :=SubStr(Clipboard,sstart,length)
	sdate :=StrReplace(sdate,"`r" ) ; "`r`n" ; ���� ���X
	sdate :=StrReplace(sdate,"`n" )
	sdate :=StrReplace(sdate, "��" , "-" ) ; ���� -�� ����
	sdate :=StrReplace(sdate,"��", "-" )
	sdate :=StrReplace(sdate,"��" ) ; ��  
	sdate :=Trim(sdate) ; ��ĭ ����
	Arr.Push(sdate) ; 1�̸�,2����,3����,4�ּ�,5HP,6email,7ȸ��,8�ѽ�,9ȸ���ּ�,10�Ի���,11��,12����,13��¥
	Clipboard=
	Sendinput, {AltDown}{F4}{AltUp} ; �� Word �����ϱ�
	Sleep, 1000
}

Wclip_copy()
{
	Clipboard=
	Sendinput, {CtrlDown}c{CtrlUp} ; ���� ^c
	ClipWait, 2
	return Clipboard
}


;============================

Button�ѱ�����:    ; �� HWP - Excel ���� ==
{
	Gui, Submit, nohide
	; �� 01���� �� ���տ��� ������� - - - - - 
	;~ Folder:= A_ScriptDir . "\DB\*.hwp" ; ���� �� ȭ��
	;~ expath:= A_WorkingDir . "\excel_word.xlsx" ; �������
	; �� 02������ ��������(sheet select)- - - - 
	IfWinExist, Excel_Merge  ; Titleâ Ȱ��ȭ
		ex := ComObjActive("Excel.Application")
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; ������
		ex.Workbooks.Open(Result)  ; ���� ���� FileSelectFile, path
	}	
	ex.Visible:=True ;~ ex.Visible:=false
	ex.sheets("HWP").select   ; ������ ��Ʈ ����
	ex.range("A1").select
	Loop, %Folder%\*.hwp
	{ 	; �� HWP ���� ����(��ȯ) - - - - - - - - -
		Arr:=[]  ; �迭 �ʱⰪ ����
		row := ex.ActiveWorkbook.Sheets("hwp").UsedRange.Rows.Count + 1
		col :=1 ; ex.Cells(row,col).Formula := "=row() -1" ;�� ������ ����
		run, %A_LoopFileFullPath%   ; ������ü���/���ϸ� ����
		WinWait, ahk_exe Hwp.exe
		WinWaitActive, ahk_exe Hwp.exe
		Sleep, 500
		; �� ��� 2 : Arr �迭 Ȱ��
		{
			hwp_data_Arr()    ; ��� Func ��/�� ����, ��������, �ѱ� �ݱ� �� 
			Sleep, 100
			loop, % Arr.Length(){
				ex.Cells(row, A_Index+1).value := Arr[ A_index ]
			} ; end loop
		} ; end ���2
		ex.Cells(row,col).Formula := "=row() -1"  ; �� ������ ���� ����
		ex.ActiveWorkbook.Save()
	} ; end loop
	MsgBox,,, ���� ���� �۾���  �Ϸ�Ǿ����ϴ�., 2
	Reload
}
return

hwp_data_Arr() ; �� Function ;��/�� ����, ��������, ��/�� �ݱ� ��
{  ; ST ������(100) ���� 
	global
	WinActivate, ahk_exe Hwp.exe  ; âȰ��ȭ
	Sleep, 700
	SendInput, {CtrlDown}{PgUp}{CtrlUp} ; ��ó�� �̵�
	Sleep, 500
	SendInput, {Down} ;����
	Sleep, 300
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 1����
	Send, !{Right}!{Right}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 2�������
	SendInput, {Down}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 3�ּ�
	Send, !{Left}{Down}!{Right}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 4HP
	SendInput, !{Right 2}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 5����
	SendInput, {Down}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� / 6�̸���
	SendInput, {Down 2}
	Arr.Push(Hclip_copy()) ; �迭 Arr �� �߰� /7����
	Send, {AltDown}{F4}{AltUp} ; ����
}

; ���簪 ���� ����
Hclip_copy(){  ; ^a, ^c, Esc
	Clipboard =     ; Ŭ������ ����
	Send, {CtrlDown}a{CtrlUp} ; ���� ^A
	Sleep, 100
	Send, {CtrlDown}c{CtrlUp} ; ���� ^c
	ClipWait, 2
	Send, {Esc}
	Sleep, 150
	return Clipboard
}


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
