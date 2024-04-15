{ ; ��� GUI ���� ���  ^ (Ctrl),  ! (Alt),  + (Shfit),  # (Win)
	#Include <FUNCTION> ; �� �����Լ�  \lib\FUNCTION.ahk ����
	Gui, Add, ListBox, x10 y5 w58 h55 Choose1 vList_Box, ����1|����2|����3|����
	Gui, Add, Button, x75 y5 w38 h50, �׸�ĸ��
	Gui, Add, Button, x120 y5 w55, �ӽ�1
	Gui, Add, Button, y+5 w55, �ӽ�2
	Gui, Add, Button, x180 y5 w55, ��������
	Gui Add, Text, x5 y65 w230 h5 +0x10  ; line
	Gui, Add, Button, x10 y70 w45, ����
	Gui, Add, Button, x+10 w55, ����ε�
	Gui, Add, Button, x+10 w45, ����
	Gui, Add, Button, x+10 w45, HELP
	Gui, +Alwaysontop
	Gui, Show, x1640 y15 w243 h100, �ڵ�ȭ
	Return
}

; ��ǥŬ��(!1) / �̹���Ŭ��(!2) / â����(!3) / â���(!4) / â�̵�(!5)
; �ȼ�Ŭ��(^+Q,^+W) / ���Ŭ��(^q,^w) / �Է�(Q1) / ����(S1~)
; ex_new; (������ ) / ex_read; (��������) / ex_open; (���� ����) / web; (IE) ��

^Space::        ; Ctrl+Space
Button����:  ; GUI ���� ��ư
{
	Gui, Submit, NoHide  ; GUI ������ �б� (List_Box �� ��)
	if(List_Box = "����1") {
		
	}
	
	else if(List_Box = "����2"){
		MsgBox, ����2 Ŭ��
	}
	else if(List_Box = "����3"){
		MsgBox, ����3 Ŭ��
	}
	else Run, %A_ScriptDir%\lib\AHK����.txt
}
Return


{  ; ��� GUI Control ���
	GuiClose:  ; GUI X
	ExitApp    ;  Exit Script
	
	^r::   ; Ctrl+r
	Button����ε�:
	Save_Reload() ; Edit + ����(^s) + �ٽ� �ε�(Reload)
	Return
	
	^e::   ; Ctrl+e
	Button����:
	Edit
	return
	
	ButtonHELP:  
	Run, http://ahkscript.github.io/ko/docs/AutoHotkey.htm ; official help
	;~ Run, http://autohotkeykr.sourceforge.net/docs/AutoHotkey.htm ; �系��
	Return
	
	Button�ӽ�1:
	MsgBox, �ӽ�1 Ŭ��
	return
	
	Button�׸�ĸ��:  ; Used Win+Shift+s
	Capture_PNG()
	Return
	
	Button��������:
	Open_TEST_EXCEL()
	return
}


{  ; ��� ��Ű HotKey ���
	!1::alt1(X1,Y1)  ; Alt+1 ��ǥ Ŭ�� 
	!2::alt2(X1,Y1,X2,Y2) ; Alt+2 �̹��� Ŭ�� img_click(8, 9,"X.png",5)��5�ʰ�
	!3::alt3()  ; Alt+3  Titleâ Ȱ��ȭ
	!4::alt4()  ; Alt+4  Titleâ ����
	!5::alt5()  ; Alt+5  Titleâ �̵�  0,0(X,Y) [,W, H] MoveWindow
	^q::get_pos(X1,Y1)   ; ���콺 ��ǥ(X1, Y1) ���
	^w::get_pos_click(X1,Y1,X2,Y2)  ; X1, Y1�� �����ġ Ŭ��
	^+q::get_pixel(X1,Y1)                ; Ctrl+Shift+q Pixel ��ǥ �� �����
	^+w::get_pixel_click(X1,Y1,X2,Y2) ; Ctrl+Shift+W Pixel �����ġ Ŭ��
	#c::Run, %A_ScriptDir%\lib\Capture_Tool.ahk ; Win+C �� #L���콺
	!d::Open_Workingdir()   ; Alt+d Open Directory
	!b::Open_Iwb2()             ; Alt+b Web Automation(IE)
	^/::Open_TEST_EXCEL() ; Ctrl+Shift+/ Open Excel Sample

	; ���  �ֽ�Ʈ�� HotStrings ���
	:*:aaa::��{space}              ;  aaa �� "��"  Replace HotStrings
	:*:s1::Sleep, 1000{End}    ; 1Second Sleep(ms)
	:*:s2::Sleep, 2000{End}    ; 2Second Sleep(ms)
	:*:s3::Sleep, 3000{End}    ; 3Second Sleep(ms)
	:*:fte;::find_text_enter("XX"){space 2}{;} text link Click{left 23}{ShiftDown}{right 2}{shiftup}
	:*:q1::   ; Enter + Move Positon
	send_enter()  ; Function call �� XX()
	Return
	:*:flist;::File_List("c:\*.*",0) `; FileList, 0Fname,1Ext,2Full `nMsgBox, % List_Arr.length() " /  " List_Arr[1] `n
	
	:*:ex_new;::  ; ���ο� ����
	excel_New()
	return
	
	:*:ex_read;:: ; ���� ���� ����
	excel_read()
	return
	
	:*:ex_open;::  ; �����ִ� ����
	excel_Open()
	return
	
	:*:chrome;::  ; ũ������
	chrome_auto()
	return
	
	:*:web;::  ; �� iwb2(Alt+B) ; ������ IE ���� ����
	web_auto()
	return
	
	:*:begin;::  ; �ʱ� ����
	begin_ahk()
	return
}