{  ; ��� �ʱ⼳�� ���   ^ (Ctrl)  + (Shift)   ! (Alt)   # (Win)
	#NoEnv											; ȯ�溯�� ����, ȿ����
	#Singleinstance Force						; ���μ��� �ߺ� ����
	#Include lib/Chrome/Chrome.ahk	; ũ�� �̻��� �ּ�ó���ڡ�
	SendMode Input							; �ӵ�, ��������
	SetTitleMatchMode, 2					; ���� �Ϻθ�
	SetWorkingDir %A_ScriptDir%		; �۾��������� 
	CoordMode, Pixel,    Screen			; �̹���, ȭ��
	CoordMode, Mouse, Screen			; ���콺, ȭ�� ;-----------------
	Gui, Font,  s11 cWhite , ���� ���	; sũ�� c�÷�, �۲�  �� GUI ��
	Gui, Color, 24085B							; ����/ ���� html color code / green, blue..
	Gui, Add, DropDownList,y10 w65 h350 Choose1 vDrop, ����1|����2|����3|����
	Gui, Add, Button, x+10 w60	h27				, Google		; ��ư
	Gui, Add, Button, x+10			h27				, ���̹�		; ��ư
	Gui, Add, Button, x+10			h27				, ��Ʃ��		; ��ư
	Gui, Add, Text, x10					gLexec			, ���ࢺ		; Text, g��
	Gui, Add, Text, x+10				gLedit			, ����			; Text,   "
	Gui, Add, Text, x+10				gLsload		, ����ε�	; Text,   "
	Gui, Add, Text, x+10				gLcapture 	,�׸�ĸ��		; Text,   "
	Gui, Add, Text, x+10				gLquit			, ����X			; Text,   "
	Gui, +Alwaysontop -Caption	; �׻� �� ǥ��, ����� X
	Gui, Show, x1600 y20, One		; x y w(width) h(height) ��ĭ ��� ;~ global Title
	return
	; ������� �ȵɶ� : Dual_img_coordinate() ������
}
; ��ǥŬ��(!1) / �̹���Ŭ��(!2) / â����(!3) / â���(!4) / â�̵�(!5)
; �ȼ�Ŭ��(^+Q,^+W) / ���Ŭ��(^q,^w) / �Է�(Q1) / ����(S1~)
; ^E (����) / ^R (����ε�) / ^G (�׸�ĸ��) / !D(����) / ex_new
;-------------------------------------------------------------------

Lexec:			; ��g��: gLexec g�� ����Ǹ� Lexec: �ݵ�� �ʿ�
^Space::		; Ctrl+Space�� ����  ��  DropDownList�� ���� ��
{
	Gui, Submit, NoHide	; GUI�� �б�
	if(Drop = "����1") {
		MsgBox,,, ����1 Ŭ��,1
		
	}
	else if(Drop = "����2"){
		MsgBox,,, ����2 Ŭ��,2
	}else if(Drop = "����3"){
		MsgBox,,, ����3 Ŭ��,2
	}else{
		Run, %A_ScriptDir%\lib\ReadMe.txt
	}
}
Return

;-------------------------------------------------------------------

{  ; ��� ��ư(��) ���� ���  GUI�� ��ư�� ����
	ButtonGoogle:	; Button��ư��: �� ��ư����
	Run, chrome.exe www.google.com
	return
	
	Button���̹�:
	Run, chrome.exe www.naver.com
	return
	
	Button��Ʃ��:
	Run, chrome.exe www.youtube.com/results?search_query=autohotkey
	return
	
	Lquit:			; g�� ����
	GuiClose:	; x Ŭ�� ����
	ExitApp
	
	^e::				; Ctrl+E  ��  ��Ű
	Ledit:			; g�� ����
	EditorSelect_EngMode()  ; �Լ�
	Edit				; ����  	
	return
	
	^r::				; Ctrl+R   �� ���� + ����
	Lsload:		; g�� ����
	Save_Reload()   ; �Լ�
	return
	; �׸�ĸ�Ĵ� �Ʒ� ��Ű �κ�(^g)
}

;-------------------------------------------------------------------

{ ; ��� HotKey, HotStrings ���
	
	; �� HotStrings  ��   :*:���::��ü�� ����
	:*:aaa::��{space}
	:*:s1::Sleep, 1000{End}
	:*:s2::Sleep, 2000{End}
	:*:q1::Send, {{}enter{}}{left 7}
	:*:flist;::send, File_List("C:\", ext=0)
	
	; �� HotKey ��   
	!d::Run, %A_ScriptDir%	; Alt+D �۾����� ����  ��1�� ��� return ���ʿ�
	!b::									; Alt+B(!B) �� ���ڵ�ȭ (IE���� ����)
	IfWinNotExist, iWB2 Learner
		run, %A_ScriptDir%\lib\iWB2.exe
	IfWinExist, iWB2 Learner
		WinActivate, iWB2 Learner
	IfWinNotExist, ahk_class NotifyIconOverflowWindow
		run, %A_ScriptDir%\lib\iWB2_Writer.exe
	return


	!1::		; Alt+1 �� ��ǥ Ŭ�� => MouseClick ���� �ذ�(0.2�� ����)
	EditorSelect_EngMode()
	MouseGetPos, X1, Y1	; ���콺 ��ǥ ���
	SendInput, Click_XY(%X1%, %Y1%) `; `nSleep, 500 `n
	return
	
	!2::		; Alt+2  �� �̹��� Ŭ�� =====
	MouseGetPos, X2, Y2
	fname := Clipboard ".png"
	if (X2 > A_ScreenWidth)	; ���� ���콺 ��ġ X2 ���� �ָ���� x�������� ũ��
		Dual_img_coordinate(fname)	; �̹��� ��ǥ(X1,Y1) ��� - ���
	else
		img_coordinate(fname)	;�̹��� ��ǥ(X1,Y1) ��� - �ָ����
	if (X1 <>""){
		aa:=X2-X1	; Ŭ���� ��ǥ�� - �̹��� ��ǥ��
		bb:=Y2-Y1
		EditorSelect_EngMode()
		if(X2 > A_ScreenWidth)	; ���� ���콺 ��ġ X2���� �� ������� x���� ���� ũ��
			SendInput, Dual_img_click(%aa%`, %bb%, "%fname%") `; �⺻10��{End} `n
		else
			SendInput, img_click(%aa%`, %bb%, "%fname%") `; �⺻10��{End} `n
	}
	else
		MsgBox,,, �̹��� ��ã��,1
	return


	!3::		; Alt+3  �� Titleâ Ȱ��ȭ �� ���� ������ =====
	WinGetActiveTitle, Title
	EditorSelect_EngMode()
	SendInput, WinActivate, %Title% `; Titleâ Ȱ��ȭ `nSleep, 200 `n
	return
	
	!4::		;  Alt+4  �� Titleâ ��� (����(Ȱ��ȭ) ������) =====
	WinGetTitle, Title, a  ; Ȱ��â�� Title�� WTitle�� ���� 
	EditorSelect_EngMode()
	SendInput, �۾�â���("%Title%") `; ��Ÿ�� ������ `nSleep, 200 `n
	return
	
	!5::		; Alt+5  ��  Titleâ �̵�  0,0(�»��) [,Width, Height] =====
	WinGetTitle, Title, a
	EditorSelect_EngMode()
	SendInput, WinMove, %Title%,,0,0 `; ,W,H���� `n
	return	

	^+q::	; �� �ȼ��� ��� (Ctrl+Shift+q) =====
	MouseGetPos, X1, Y1
	PixelGetColor, F_color, %X1%, %Y1%, RGB
	Clipboard=
	Clipboard = %F_color%
	ClipWait, 2
	while(true){
		PixelSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight, %F_color%, , Fast RGB
		if (X1 <> ""){
			MsgBox,,,% F_color, 0.5
			break
		}
		MouseMove,0,5,,relative
		Sleep, 100
	}
	return

	^+w::	; �� �ȼ� ���� �����ġ Ŭ�� ��� (^+w) =====
	MouseGetPos, X2, Y2
	MouseMove, 40, 40,,Relative
	aa:=X2-X1
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, pixel_click(%aa%,%bb%,`"{Ctrl down}{v}{Ctrl up}`") `; �ȼ�Ŭ��{End}
	Return	
	
	^q::		; �� ����ǥ ���(X1,Y1)  Ctrl+q
	MouseGetPos, X1, Y1
	return

	^w::		; �� �����ǥ Ŭ��  Ctrl+w
	MouseGetPos, X2, Y2  ; X1, Y1���� �����ǥ �� ���
	EditorSelect_EngMode()
	aa:=X2-X1
	bb:=Y2-Y1
	Sleep, 150
	SendInput, MouseClick, Left, %aa%, %bb%,1,,,R{space} `; `nSleep, 500 `n
	return

	^g::				; Ctrl+G �׸�ĸ��  ��� !2(Alt+2) ����
	Lcapture:	; �ٶ� ����
	sPATH := A_WorkingDir . "\PIC"	; �۾����� �Ʒ�  PIC ���� 
	if (not FileExist(sPath))					; PIC ���� ���ٸ� ����
		FileCreateDir, %sPATH%		; ���� ����
	InputBox,OutputVar,�� ���ϸ�(.png ����) �Է�,�� ���� ���� ���� ��� ��� `n`n  �� �̹��� Ŭ����� : ���콺 ��ġ ��  Alt`+2,,,,,,,,���ϸ�
	name := A_WorkingDir "\PIC\" OutputVar ".png" ; ������ �����̸�
	Send, #+s					; �� Win+Shift+S �� �簢 ���� ����
	KeyWait, LButton, D	; Mouse ���ʹ�ư ���������� ���
	KeyWait, LButton, U	; Mouse ���ʹ�ư �������� ���
	sleep, 200					; ��������  ������ �ڡڡ�
	hBM := CB_hBMP_Get()  
	If ( hBM ) {  ;~ sFile := A_ScriptDir "\\" A_Now ".png"
		sFile := name	;~ sFile := A_ScriptDir "\\" "xxx.png"
		GDIP("Startup")
		SavePicture(hBM, sFile) 
		GDIP("Shutdown")
		DllCall( "DeleteObject", "Ptr",hBM ) ;~ If FileExist(sFile) 	;~ SoundBeep
    }       
	Clipboard =
	Clipboard := OutputVar
	ClipWait, 2
	MsgBox,,,ĸ�� �Ϸ�, 0.5
	return
	
	;  ��� ��Ÿ �ֽ�Ʈ��(HotStrings) : ������(ex_new;), �����ִ¿���(ex_open;), ũ��(chrome;), IE web�ڵ�ȭ(web;) ��
	:*:ex_new;::ex:=ComObjCreate(`"Excel.Application`") `;������ ex�� ���� `nex.Workbooks.Add  `; ������ `nex.range(`"A1`").value := 12300 `; �����Է� `nex.range(`"B2`").value := `"�׽�Ʈ �����Է�`" `; �����Է� `nex.ActiveWorkbook.Saveas(A_ScriptDir . "\123_Test.xlsx") `;���� `nex.DisplayAlerts := false `nex.Quit `;���� `nMsgBox, ������ ���� �Ϸ� `n

	:*:ex_open;::ex:=ComObjActive(`"Excel.Application`") `;�����ִ¿��� ex�� ���� `nex.sheets(`"DB`").select `;��Ʈ�� Ȯ�Ρڡ� `nMsgBox, `% `"ù�� `" First_Row(ex) `" `/ ���� `" Last_Row(ex) `" `/ ù�� `" First_Col(ex) `" `/ ���� `" Last_Col(ex) `" `/ ù���� `" First_Col_num(ex) `" `/ ������ `" Last_Col_num(ex) `" `/ Used�� `" Used_Row(ex) `" `/ Used�� `" Used_col_num(ex) `" `/ ���ؿ� ����� `"  EndRows(ex, First_Col(ex)) `; ��ȿ������ 1��°���� ����� `n{;}ex.Range(`"b2`").End(-4121).Select `;��Ư������ ���� ���� -4121(xldown),-4162(xlup) `n
	
	:*:chrome;::IfWinNotExist, ahk_exe chrome.exe `nChrome:=new Chrome()`nPg:=Chrome.GetPage() `nPg.Call(`"Page.navigate`", {{}`"url`"`: `"https://naver.com`"{}}) `;�ּ� ���� `nPg.WaitForLoad() `n; �� Copy Selector ValueȰ�� or pg.sel �ڵ��Է� `npg.Evaluate(`"document.querySelectorAll('{#}query')[0].value='AHK'`") `npg.Evaluate(`"document.querySelectorAll('{#}search_btn')[0].click()`") `nPg.WaitForLoad() `;pg.Evaluate(`"document.querySelectorAll('X')[0].value = `" Chrome.Jxon_Dump(Var)) `nMsgBox, Ȯ�� �� �ڵ� ���� `nPg.Call(`"Browser.close`") `nPg.Disconnect() `n	
	
	; �� ������ Alt+B(!b)���� ��� ���� / getid;
	:*:web;::pwb:=WBGet() `; �������� {!}B `npwb.Navigate(`"www.naver.com`") `;�ּҿ��� `nwhile pwb.busy or pwb.ReadyState <>4 `nSleep, 100 `n`;ClickLink(pwb,Text:="Text") `;���ڸ�ũ Ŭ�� `npwb.document.getElementByID("XX").click() `; Ŭ��(ID) `n`;pwb.document.getElementByID("XX").Value :="X" `; �Է�(ID) `n`;pwb.document.getElementsByClassName("XX")[0].Value :="X" `; Name, TagName `n`;Focus() `;checked := True `;innerText `;submit() `n`;pwb.document.parentWindow.frames("XX").document.all.tags("BODY")[0].document.getElementByID("XX").Click() `; Ŭ��(������) `n
	
	:*:begin;::{#}Singleinstance Force `; ������ ���� �������� `n{#}NoEnv `; ȯ�溯�� ���� `nSendMode Input `; �ӵ�, ������ ��õ `nSetWorkingDir `%A_ScriptDir`%  `; ���� �۾����� ���� `n
}

;-------------------------------------------------------------------

{  ; ��� �Լ����� ��� 
	
	{  ; ��� �����Լ�
		EditorSelect_EngMode(){		; �� ������ ���� �� ������ --------
			ifwinexist, ahk_exe SciTE.exe
				WinActivate, ahk_exe SciTE.exe
			ifwinexist, ahk_class Notepad++
				WinActivate, ahk_class Notepad++
			WinGetActiveTitle, Title_name
			ret := IME_CHECK(Title_name) ; Eng Mode
			if (ret = 1)
				Send, {vk15sc138}
			Sleep, 150  ; �� �Լ� ���� Sendinput ���� ����
		}
		
		IME_CHECK(WinTitle){		; �ѿ����
			WinGet,hWnd,ID,%WinTitle%
			Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
		}
		
		Send_ImeControl(DefaultIMEWnd, wParam, lParam){
			DetectSave := A_DetectHiddenWindows       
			DetectHiddenWindows,ON                          
			 SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
			if (DetectSave <> A_DetectHiddenWindows)
				DetectHiddenWindows,%DetectSave%
			Return ErrorLevel
		}
		
		ImmGetDefaultIMEWnd(hWnd){
			return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
		}	; End �� ������ ���� �� ������ ----------------------------------
		
		;-------------------------------------------------------------------------
		
		; �� �̹��� ��ǥ�� ���  !2(Alt+2) ����
		img_coordinate(ByRef F_name){	; �� �̹��� ��ǥ�� ��� !2(Alt+2)
			global X1, Y1
			start_time := A_TickCount  ; ���۽ð� - �ҿ� �ð�
			Img_Dir := A_ScriptDir "\pic\" F_name ;~ Img_Dir := "*30 " A_ScriptDir "\pic\" F_name
			Loop {	
			ImageSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir	;~ if (X1 <> ""){
				if (ErrorLevel = 0){
					break
				}
				if ((A_index = 1) or (A_index = 3) or (A_index = 5) or (A_index = 10)){
					MouseMove,10,50,,relative ; ���콺 ���� x
				}
				end_time := (A_TickCount - start_time)
				if (end_time >= 3000){
					Break
					MsgBox, �̹��� ã�� ���� `n`n�׸�ĸ�� ������ �ּ�ȭ�Ͽ� �ٽ� �õ��ϰų� `n`n�׷��� �ȵǸ� �ٸ� �̹����� �õ��� ������
				}
				Sleep, 100
			}
		}
		
		; �� ��������� ��� ����
		Dual_img_coordinate(ByRef F_name){  ; �� �̹��� ��ǥ�� ��� !2(Alt+2) �ص������ ����
			global X1, Y1
			start_time := A_TickCount  ; ���۽ð� - �ҿ� �ð�
			Img_Dir := A_ScriptDir "\PIC\" F_name
			Loop {
				ImageSearch, X1, Y1, A_ScreenWidth, 0, A_ScreenWidth * 2, A_ScreenHeight,% Img_Dir ;�� �ָ���� x��2��?
				;~ ImageSearch, X1, Y1, �θ����X��, 0, �θ���ͳ�x��, �θ���ͳ�Y��,% Img_Dir ;�� �ȵ� ��� ����
				if (ErrorLevel = 0){
					break
				}
				if ((A_index = 1) or (A_index = 5) or (A_index = 10) or (A_index = 15)){
					MouseMove,10,50,,relative ; ���콺 ���� x
				}
				end_time := (A_TickCount - start_time)
				if (end_time >= 5000){
					Break
					MsgBox, �̹��� ã�� ���� `n`n�׸�ĸ�� ������ �ּ�ȭ�Ͽ� �ٽ� �õ��ϰų� `n`n�׷��� �ȵǸ� �ٸ� �̹����� �õ��� ������
				}
				Sleep, 100
			}
		}
		
		
		; �� !2 (Alt+2)  �� �̹��� Ŭ�� / �⺻ 10��
		img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10){
			start_time := A_TickCount  ; ���۽ð� - �ҿ� �ð�
			Img_Dir := A_ScriptDir "\PIC\" filename	;~ Img_Dir :=  "*30 " A_ScriptDir "\PIC\" filename
			num:=0
			while(true){
				if (X2 > 1920)  ; �� FHD ����
					ImageSearch, vx, vy, 0, 0, 3840, A_ScreenHeight, % Img_Dir  ; 1920*2=3840
				else
					ImageSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight, % Img_Dir
				if (vx <> ""){
					vx := vx + ax
					vy := vy + ay
					MouseMove, %vx%, %vy%
					Click, Down
					Sleep, 300
					Click, Up
					break
				}
				if ((A_index = 10) or (A_index = 30) or (A_index = 50))
					MouseMove,1,50,,relative ; ���콺�� ���� X
				end_time := (A_TickCount - start_time)
				if (end_time >= ntime*1000){
					MsgBox,,, %ntime% �� �׸�ã�� ����, 1
					Break
				}
				if (A_index >= 5){
					Img_Dir :=  "*" num " " A_ScriptDir "\PIC\" filename
					num++
				}
				Sleep, 100
			}
		}
		
		; �� !2 (Alt+2)  �� �̹��� Ŭ�� / �⺻ 10�� ��Dual ��������� ���
		Dual_img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10){
			start_time := A_TickCount   ; ���۽ð� - �ҿ� �ð�
			Img_Dir := A_ScriptDir "\PIC\" filename
			num:=0
			while(true){
				ImageSearch, vx, vy,  A_ScreenWidth, 0, A_ScreenWidth * 2, A_ScreenHeight, % Img_Dir  ; �� �����,�θ���� �ػ� ���� ����
				;~ ImageSearch, vx, vy, �ָ���ͳ�x��, 0, �θ���ͳ�x��, �θ���ͳ�y��, % Img_Dir  ; �� �ʿ�� ���� ����
				if (vx <> ""){
					vx := vx + ax
					vy := vy + ay
					MouseMove, %vx%, %vy%
					Click, Down
					Sleep, 300
					Click, Up
					break
				}
				if ((A_index = 10) or (A_index = 30) or (A_index = 50))
					MouseMove,1,50,,relative
				end_time := (A_TickCount - start_time)
				if (end_time >= ntime*1000){
					MsgBox,,, %ntime% �� �׸�ã�� ����, 1
					Break
				}
				if (A_index >= 5){
					Img_Dir :=  "*" num " " A_ScriptDir "\PIC\" filename
					num++
				}
				Sleep, 100
			}
		}	;  End �� �̹��� ��ǥ�� ���  !2(Alt+2) ���� -------------
		
		;----------------------------------------------------------------
		
		; ^+q  �� �ȼ� Ŭ�� ���� (�⺻10�� ���)
		pixel_click(ByRef ax, ByRef ay, ByRef fpixel, ByRef ntime=10){ 
			start_time := A_TickCount  ; ���۽ð�(�ҿ�ð� ����)
			while(true){
				PixelSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,fpixel, , Fast RGB
				if (vx <> ""){
					vx := vx + ax
					vy := vy + ay ;~ MouseClick, Left, %vx%, %vy% 
					MouseMove, %px%,%py% 	
					Sleep, 100	
					Click, Down	
					Sleep, 300	
					Click, Up
					;~ MouseClick, Left, %vx% , %vy%, , , D
					;~ Sleep, 350 ; Ŭ�� ���� ����
					;~ MouseClick, Left, %vx% , %vy%, , , U
					break
				}
				if ((A_index = 10) or (A_index = 20) or (A_index = 50))	
					MouseMove,1,30,,relative
				end_time := A_TickCount - start_time
				if (end_time >= ntime*1000){
					MsgBox,,, %ntime% �� �׸�ã�� ����, 1
					Break
				}
				Sleep, 100
			}
		} 

		�۾�â���(ByRef Title_name){  ; !4 (Alt+4)  �� �۾�â ���
			WinWait, %Title_name%
			WinWaitActive, %Title_name%
			loop {
				IfWinExist, %Title_name%  
				{
					WinActivate, %Title_name%
					Sleep, 100
					break
				}
				Sleep, 100
			}
		}
		
		Click_XY(ByRef px, ByRef py){  ; �� Click ��� ���� ����(0.2�ʰ� ������)
			MouseMove, %px%,%py% 	
			Sleep, 100	
			Click, Down	
			Sleep, 300	
			Click, Up
			;~ MouseClick,Left,%px%,%py%,,,D
			;~ Sleep, 300
			;~ MouseClick,Left,%px%,%py%,,,U
		}
		
		Save_Reload(){  ;  �� ���� �ٽ÷ε�
			EditorSelect_EngMode()
			Send, ^s
			Sleep, 150
			reload	
		}
		
		won(Amount){   ; �� õ���� ǥ�� : -12,345  ; won Format_Number
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
		
		input_value(ByRef var){  ; �� var ��  Ŭ������ ����+�پ�ֱ�
			Clipboard =           ; �ʱ�ȭ
			Clipboard := var    ; Ŭ������ �ֱ�
			ClipWait, 2            ; ����� ������ ���
			SendInput, {Ctrl Down}v{Ctrl Up}
		}
		
		find_text_enter(ByRef ax){  ; �� ���� �˻��� ����(^F)
			SendInput, {Ctrl Down}f{Ctrl Up}
			Sleep, 300
			SendInput, %ax%
			Sleep, 150
			Send, {Esc}
			Sleep, 150
			Send, {Enter}	
		}
		
		ocr_num(ByRef var){ 	; �� OCR �����ν� �Լ�����
		   var := strreplace(var,"O",0)
		   var := strreplace(var,"I",1)
		   var := strreplace(var,",")
		   var := strreplace(var," ")
		   var := strreplace(var,"`r`n",,All)
		   var := var * 1
		   Return var
		}
		
		ymd(var_date){  ;  �� ����� ���̱� 20220101 �� ���α׷� ��¥�Է� ���
			StringReplace, var,var_date, -,,All
			return var
		}
		
		;  �� flist;  File_List("c:\") ���ϸ� / File_List("c:\",1) Ȯ��������, 2 Full
		File_List(ByRef Dir, ByRef ext=0){  ; File_List("��θ�"[,01]) ; List_Arr[1]
			global List_Arr := []
			Loop, % Dir {	;~ Loop, % Dir . "*.*"
				if(ext = 0){
					StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
					List_Arr.Push(FileNameNoExt)
				}else if(ext=1){
					List_Arr.Push(A_LoopFileName) ; Ȯ���� ����
				}else{
					List_Arr.Push(A_LoopFileFullPath)
				}
			}
			return List_Arr
		}
		
		WBGet(WinTitle="ahk_class IEFrame", Svr#=1){   ; ��� Pointer to Open IE Window
		   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
				, IID := "{0002DF05-0000-0000-C000-000000000046}"
		   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
		   if (ErrorLevel != "FAIL"){
			  lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
			  if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
				 DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
				 return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
			  }
		   }
		}
		
		ClickLink(PXL,Text=""){  ; ��  iwb2 ���� ��ũ Ŭ��
			ComObjError(false)
			Links := PXL.Document.Links
			Loop % Links.Length
			   If (Links[A_Index-1].InnerText = Text ){
				  Links[A_Index-1].Click()
				  break
			   }
			Sleep, 200
			ComObjError(True)
		}
	}

	; -------------------------------------------------------------------------------

	{  ; ��� ���� �Լ� https://www.the-automator.com/excel-and-autohotkey
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
	}  ; End  �� ���� ���� �Լ�
	
	; -------------------------------------------------------------------------------
	
	{  ; ��� �̹��� How to save image in clipboard. Ŭ������ �̹��� ����
		; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=94345
		/* ���� : ���ϴ� ���� Ŭ������ ���� �� �Ʒ��ڵ� ����
		hBM := CB_hBMP_Get()  
		If ( hBM ) { ;~ sFile := A_ScriptDir "\\" A_Now ".png"
			sFile := A_ScriptDir "\\" "xx.png"
			GDIP("Startup")
			SavePicture(hBM, sFile) 
			GDIP("Shutdown")
			DllCall( "DeleteObject", "Ptr",hBM )
			If FileExist(sFile)
				SoundBeep
		}  
		*/
		
		CB_hBMP_Get() {					; By SKAN on D297 @ bit.ly/2L81pmP
		Local OK := [0,0,0,0]
			OK.1 := DllCall( "OpenClipboard", "Ptr",0 )
		  OK.2 := OK.1 ? DllCall( "IsClipboardFormatAvailable", "UInt",8 ) : 0  ; CF_BITMAP
		  OK.3 := OK.2 ? DllCall( "GetClipboardData", "UInt", 2, "Ptr" )   : 0
		  OK.4 := OK.1 ? DllCall( "CloseClipboard" ) : 0  
		Return OK.3 ? DllCall( "CopyImage", "Ptr",OK.3, "Int",0, "Int",0, "Int",0, "UInt",0x200C, "Ptr" )
				  + ( ErrorLevel := 0 ) : ( ErrorLevel := !OK.2 ? 1 : 2 ) >> 2          
		}
		
		SavePicture(hBM, sFile) {		; By SKAN on D293 @ bit.ly/2L81pmP 
		Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
		Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
		  E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
		  E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
		  NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
		  E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
		  E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
		Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
		} 
		
		GDIP(C:="Startup") {		; By SKAN on D293 @ bit.ly/2L81pmP
		  Static SI:=Chr(!(VarSetCapacity(Si,24,0)>>16)), pToken:=0, hMod:=0, Res:=0, AOK:=0
		  If (AOK := (C="Startup" and pToken=0) Or (C<>"Startup" and pToken<>0))  {
			  If (C="Startup") {
					   hMod := DllCall("LoadLibrary", "Str","gdiplus.dll", "Ptr")
					   Res  := DllCall("gdiplus\GdiplusStartup", "PtrP",pToken, "Ptr",&SI, "UInt",0)
			  } Else { 
					   Res  := DllCall("gdiplus\GdiplusShutdown", "Ptr",pToken )
					   DllCall("FreeLibrary", "Ptr",hMod),   hMod:=0,   pToken:=0
		   }}  
		Return (AOK ? !Res : Res:=0)    
		}
	}  ; End Save image in clipboard

}


;~ ^t::		; �� OCR �����ν� - ���� ���� �ʿ�
;~ MouseGetPos, X2, Y2
;~ EditorSelect_EngMode()
;~ aa:=X1 - X2
;~ bb:=Y1 - Y2
;~ SendInput, ocr_text := GetOCR(%X2%, %Y2%, %aa%, %bb%){space}{enter}
;~ SendInput, ocr_num(ocr_text){enter}
;~ sendinput, ocr_text < 0{left 12};{end}{enter}
;~ return