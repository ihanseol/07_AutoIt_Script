{ ; ■■ GUI 설정 ■■  ^ (Ctrl),  ! (Alt),  + (Shfit),  # (Win)
	#Include <FUNCTION> ; ■ 각종함수  \lib\FUNCTION.ahk 참고
	Gui, Add, ListBox, x10 y5 w58 h55 Choose1 vList_Box, 연습1|연습2|연습3|참고
	Gui, Add, Button, x75 y5 w38 h50, 그림캡쳐
	Gui, Add, Button, x120 y5 w55, 임시1
	Gui, Add, Button, y+5 w55, 임시2
	Gui, Add, Button, x180 y5 w55, 엑셀샘플
	Gui Add, Text, x5 y65 w230 h5 +0x10  ; line
	Gui, Add, Button, x10 y70 w45, 실행
	Gui, Add, Button, x+10 w55, 저장로드
	Gui, Add, Button, x+10 w45, 편집
	Gui, Add, Button, x+10 w45, HELP
	Gui, +Alwaysontop
	Gui, Show, x1640 y15 w243 h100, 자동화
	Return
}

; 좌표클릭(!1) / 이미지클릭(!2) / 창선택(!3) / 창대기(!4) / 창이동(!5)
; 픽셀클릭(^+Q,^+W) / 상대클릭(^q,^w) / 입력(Q1) / 슬립(S1~)
; ex_new; (새엑셀 ) / ex_read; (기존열기) / ex_open; (열린 엑셀) / web; (IE) 등

^Space::        ; Ctrl+Space
Button실행:  ; GUI 실행 버튼
{
	Gui, Submit, NoHide  ; GUI 설정값 읽기 (List_Box 값 등)
	if(List_Box = "연습1") {
		
	}
	
	else if(List_Box = "연습2"){
		MsgBox, 연습2 클릭
	}
	else if(List_Box = "연습3"){
		MsgBox, 연습3 클릭
	}
	else Run, %A_ScriptDir%\lib\AHK참고.txt
}
Return


{  ; ■■ GUI Control ■■
	GuiClose:  ; GUI X
	ExitApp    ;  Exit Script
	
	^r::   ; Ctrl+r
	Button저장로드:
	Save_Reload() ; Edit + 저장(^s) + 다시 로드(Reload)
	Return
	
	^e::   ; Ctrl+e
	Button편집:
	Edit
	return
	
	ButtonHELP:  
	Run, http://ahkscript.github.io/ko/docs/AutoHotkey.htm ; official help
	;~ Run, http://autohotkeykr.sourceforge.net/docs/AutoHotkey.htm ; 사내망
	Return
	
	Button임시1:
	MsgBox, 임시1 클릭
	return
	
	Button그림캡쳐:  ; Used Win+Shift+s
	Capture_PNG()
	Return
	
	Button엑셀샘플:
	Open_TEST_EXCEL()
	return
}


{  ; ■■ 핫키 HotKey ■■
	!1::alt1(X1,Y1)  ; Alt+1 좌표 클릭 
	!2::alt2(X1,Y1,X2,Y2) ; Alt+2 이미지 클릭 img_click(8, 9,"X.png",5)←5초간
	!3::alt3()  ; Alt+3  Title창 활성화
	!4::alt4()  ; Alt+4  Title창 대기★
	!5::alt5()  ; Alt+5  Title창 이동  0,0(X,Y) [,W, H] MoveWindow
	^q::get_pos(X1,Y1)   ; 마우스 좌표(X1, Y1) 얻기
	^w::get_pos_click(X1,Y1,X2,Y2)  ; X1, Y1의 상대위치 클릭
	^+q::get_pixel(X1,Y1)                ; Ctrl+Shift+q Pixel 좌표 및 값얻기
	^+w::get_pixel_click(X1,Y1,X2,Y2) ; Ctrl+Shift+W Pixel 상대위치 클릭
	#c::Run, %A_ScriptDir%\lib\Capture_Tool.ahk ; Win+C → #L마우스
	!d::Open_Workingdir()   ; Alt+d Open Directory
	!b::Open_Iwb2()             ; Alt+b Web Automation(IE)
	^/::Open_TEST_EXCEL() ; Ctrl+Shift+/ Open Excel Sample

	; ■■  핫스트링 HotStrings ■■
	:*:aaa::■{space}              ;  aaa → "■"  Replace HotStrings
	:*:s1::Sleep, 1000{End}    ; 1Second Sleep(ms)
	:*:s2::Sleep, 2000{End}    ; 2Second Sleep(ms)
	:*:s3::Sleep, 3000{End}    ; 3Second Sleep(ms)
	:*:fte;::find_text_enter("XX"){space 2}{;} text link Click{left 23}{ShiftDown}{right 2}{shiftup}
	:*:q1::   ; Enter + Move Positon
	send_enter()  ; Function call ← XX()
	Return
	:*:flist;::File_List("c:\*.*",0) `; FileList, 0Fname,1Ext,2Full `nMsgBox, % List_Arr.length() " /  " List_Arr[1] `n
	
	:*:ex_new;::  ; 새로운 엑셀
	excel_New()
	return
	
	:*:ex_read;:: ; 기존 엑셀 열기
	excel_read()
	return
	
	:*:ex_open;::  ; 열려있는 엑셀
	excel_Open()
	return
	
	:*:chrome;::  ; 크롬제어
	chrome_auto()
	return
	
	:*:web;::  ; ■ iwb2(Alt+B) ; 웹제어 IE 켜진 상태
	web_auto()
	return
	
	:*:begin;::  ; 초기 설정
	begin_ahk()
	return
}