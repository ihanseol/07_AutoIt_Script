{  ; ��� �ʱ⼳�� ���   ^ (Ctrl)  + (Shift)   ! (Alt)   # (Win)
	#Include <MyFunction>					; �� �����Լ� �ص������ ����
	#Include lib/Chrome/Chrome.ahk	; ũ���Լ� ������ TEST���� ������˻� ����
	Gui, Font,  s11 cWhite, ���� ���	; sũ�� c�÷�, �۲�  �� GUI ��
	Gui, Color, 456789							; ����  �� ���� html color code / green, blue..
	Gui, Add, DropDownList, w65 h400 Choose1 vDrop, ����1|����2|����3|���� ; �߰�����
	Gui, Add, Button, x+10   w60	h26		, Google		; ��ư
	Gui, Add, Button, x+10       	h26		, ���̹�		; ��ư
	Gui, Add, Button, x+10       	h26		, ��Ʃ��		; ��ư
	Gui, Add, Text, x13			gLexec			, ���ࢺ		; Text,  g��
	Gui, Add, Text, x+10		gLedit			, ����			; Text,    "
	Gui, Add, Text, x+10		gLsload		, ����ε�	; Text,    "
	Gui, Add, Text, x+10		gLcapture	, �׸�ĸ��	; Text,    "
	Gui, Add, Text, x+10		gLquit			, ����X			; Text,    "
	Gui, +Alwaysontop -Caption		; �׻� �� ǥ��, ����� X
	Gui, Show, x1570 y10, AHK3		; x y w(width) h(height)
	return
	; ������� �ȵɶ�: lib/MyFunction.ahk���� Dual_img_coordinate(ByRef F_name)�� ������
}	; =========================================
; ��ǥŬ��(!1) / �̹���Ŭ��(!2) / â����(!3) / â���(!4) / â�̵�(!5)
; �ȼ�Ŭ��(^+Q,^+W) / ���Ŭ��(^q,^w) / �Է�(Q1) / ����(S1~)
; ^E (����) / ^R (����ε�) / ^G (�׸�ĸ��) / !D(����) / ex_new
; ===========================================

Lexec:		; �ڶ� ����
^Space::	; Ctrl+Space  ��  ListBox ���� ��
{
	Gui, Submit, NoHide	; GUI�� �б�(List_Box..)
	if(Drop = "����1") 		; Drop ���� ����1 �̸� ����
	{
		MsgBox,,, ����1 Ŭ��,1
		
	} 
	else if(Drop = "����2")	
	{
		MsgBox,,, ����2 Ŭ��,1
	} else if(Drop = "����3") 	{
		MsgBox,,, ����3 Ŭ��,1
	} else 
		Run, %A_ScriptDir%\lib\ReadMe.txt
}
Return

; ======================================

{  ; ��� ��ư Or �� ���� ���  GUI�� ��ư�� ����
	ButtonGoogle:  ; Button��ư��:   �� ��ư����
	Run, chrome.exe www.google.com
	return
	
	Button���̹�:
	Run, chrome.exe www.naver.com
	return
	
	Button��Ʃ��:
	Run, chrome.exe www.youtube.com/results?search_query=autohotkey
	return
	
	Lquit:        ; ��g�� �� ���� gLqui �� �����ߴٸ�  Lquit: ~ return �ʿ� 
	GuiClose:  ; x Ŭ�� ����
	ExitApp
}


; ======================================
; �Լ��� lib/MyFunction.ahk �� ���� �Լ��� ����Ǿ� ����.
; ũ���ڵ�ȭ�� �ʱ⼳���� 
;=======================================
{ ; ��� HotKey, HotStrings ��� ���� ��Ű �� �ֽ�Ʈ��
	
	^e::					; Ctrl+E  ��  ��Ű(����Ű)
	Ledit:				; ��g��  �� ����  gLedit �� �����ߴٸ�  Ledit: ~ return �ʿ� 
	EditorSelect_EngMode()  ; �Լ�
	Edit					; ����  	
	return
	
	^r::					; Ctrl+R   �� ���� + ����
	Lsload:			; ��g�� ����
	Save_Reload()	; �Լ� MyFunction.ahk
	return				; �׸�ĸ�Ĵ� �Ʒ� ��Ű �κ�
	
	^g::					; Ctrl+G �׸�ĸ��  ��� !2(Alt+2) ����
	Lcapture:		; ��g�� ����
	Capture_PNG()
	return	
	
	; �� HotStrings  �� 		:*:���::��ü�� ����
	:*:aaa::��{space}			; a�� 3�� �Է��ϸ� �ڵ����� �� �� ��ü��.
	:*:s1::Sleep, 1000{End}
	:*:s2::Sleep, 2000{End}
	:*:q1::Send, {{}enter{}}{left 7}
	:*:flist;::File_List("c:\*.*",0) `; FileList, 0 Fname,1 Ext, 2 Full `nMsgBox, % List_Arr.length() " /  " List_Arr[1] `n
	
	; �� HotKey �� 1�� ����� return ���ʿ�
	!1::alt1(X1,Y1)			; Alt+1 ��ǥ Ŭ�� 
	!2::alt2(X1,Y1,X2,Y2) ; Alt+2 �̹��� Ŭ�� img_click(8, 9,"X.png",7)��7��
	!3::alt3()					; Alt+3  Titleâ Ȱ��ȭ
	!4::alt4()					; Alt+4  Titleâ ����
	!5::alt5()					; Alt+5  Titleâ �̵�  0,0(X,Y) [,W, H] MoveWindow
	^q::get_pos(X1,Y1)							; ���콺 ��ǥ(X1, Y1) ���
	^w::get_pos_click(X1,Y1,X2,Y2)		; X1, Y1�� �����ġ Ŭ��
	^+q::get_pixel(X1,Y1)						; Ctrl+Shift+q Pixel ��ǥ �� �����
	^+w::get_pixel_click(X1,Y1,X2,Y2)	; Ctrl+Shift+W Pixel �����ġ Ŭ��
	#c::Run, %A_ScriptDir%\lib\Capture_Tool.ahk ; Win+C �� #L���콺
	!d::Open_Workingdir()						; Alt+d Open Directory
	!b::Open_Iwb2()								; Alt+b Web Automation(IE)
	
	:*:begin;::
	begin_ahk()
	return
	
	:*:ex_new;::  ; New Excel
	excel_New()
	return
	
	:*:ex_open;::  ; Open Excel file
	excel_Open_file()
	return
	
	:*:ex_opened;::  ; Opened Excel file
	excel_Opened()
	return
	
	:*:ex_arr;::  ; Excel Array
	excel_Arr()
	return
	
	:*:chrome;::  ; Chrome
	chrome_auto()
	return
	
	:*:web;::  ; �� iwb2(Alt+B) ; ������ IE ���� ���¿���
	web_auto()
	get_element()  ; �� iwb2(Alt+B) ; ��� ����
	return
	
	:*:clink;::ClickLink(PXL,Text="XX"){left 4}+{right 2}
}