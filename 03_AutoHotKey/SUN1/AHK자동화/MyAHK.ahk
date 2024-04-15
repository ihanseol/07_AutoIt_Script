{  ; ■■ 초기설정 ■■   ^ (Ctrl)  + (Shift)   ! (Alt)   # (Win)
	#Include <MyFunction>					; ■ 각종함수 ※듀얼모니터 포함
	#Include lib/Chrome/Chrome.ahk	; 크롬함수 사용법은 TEST폴더 맞춤법검사 참고
	Gui, Font,  s11 cWhite, 맑은 고딕	; s크기 c컬러, 글꼴  ※ GUI ↓
	Gui, Color, 456789							; 배경색  ※ 구글 html color code / green, blue..
	Gui, Add, DropDownList, w65 h400 Choose1 vDrop, 연습1|연습2|연습3|참고 ; 추가수정
	Gui, Add, Button, x+10   w60	h26		, Google		; 버튼
	Gui, Add, Button, x+10       	h26		, 네이버		; 버튼
	Gui, Add, Button, x+10       	h26		, 유튜브		; 버튼
	Gui, Add, Text, x13			gLexec			, 실행▶		; Text,  g라벨
	Gui, Add, Text, x+10		gLedit			, 편집			; Text,    "
	Gui, Add, Text, x+10		gLsload		, 저장로드	; Text,    "
	Gui, Add, Text, x+10		gLcapture	, 그림캡쳐	; Text,    "
	Gui, Add, Text, x+10		gLquit			, 종료X			; Text,    "
	Gui, +Alwaysontop -Caption		; 항상 위 표시, 제목바 X
	Gui, Show, x1570 y10, AHK3		; x y w(width) h(height)
	return
	; 듀얼모니터 안될때: lib/MyFunction.ahk에서 Dual_img_coordinate(ByRef F_name)의 값수정
}	; =========================================
; 좌표클릭(!1) / 이미지클릭(!2) / 창선택(!3) / 창대기(!4) / 창이동(!5)
; 픽셀클릭(^+Q,^+W) / 상대클릭(^q,^w) / 입력(Q1) / 슬립(S1~)
; ^E (편집) / ^R (저장로드) / ^G (그림캡쳐) / !D(폴더) / ex_new
; ===========================================

Lexec:		; ★라벨 설정
^Space::	; Ctrl+Space  ←  ListBox 선택 후
{
	Gui, Submit, NoHide	; GUI값 읽기(List_Box..)
	if(Drop = "연습1") 		; Drop 값이 연습1 이면 실행
	{
		MsgBox,,, 연습1 클릭,1
		
	} 
	else if(Drop = "연습2")	
	{
		MsgBox,,, 연습2 클릭,1
	} else if(Drop = "연습3") 	{
		MsgBox,,, 연습3 클릭,1
	} else 
		Run, %A_ScriptDir%\lib\ReadMe.txt
}
Return

; ======================================

{  ; ■■ 버튼 Or 라벨 설정 ■■  GUI의 버튼과 연결
	ButtonGoogle:  ; Button버튼명:   ■ 버튼역할
	Run, chrome.exe www.google.com
	return
	
	Button네이버:
	Run, chrome.exe www.naver.com
	return
	
	Button유튜브:
	Run, chrome.exe www.youtube.com/results?search_query=autohotkey
	return
	
	Lquit:        ; ★g라벨 ※ 만약 gLqui 라벨 선언했다면  Lquit: ~ return 필요 
	GuiClose:  ; x 클릭 종료
	ExitApp
}


; ======================================
; 함수는 lib/MyFunction.ahk 에 각종 함수가 선언되어 있음.
; 크롬자동화는 초기설정에 
;=======================================
{ ; ■■ HotKey, HotStrings ■■ 각종 핫키 및 핫스트링
	
	^e::					; Ctrl+E  ■  핫키(단축키)
	Ledit:				; ★g라벨  ※ 만약  gLedit 라벨 선언했다면  Ledit: ~ return 필요 
	EditorSelect_EngMode()  ; 함수
	Edit					; 편집  	
	return
	
	^r::					; Ctrl+R   ■ 저장 + 갱신
	Lsload:			; ★g라벨 설정
	Save_Reload()	; 함수 MyFunction.ahk
	return				; 그림캡쳐는 아래 핫키 부분
	
	^g::					; Ctrl+G 그림캡쳐  ■■ !2(Alt+2) 관련
	Lcapture:		; ☆g라벨 정의
	Capture_PNG()
	return	
	
	; ■ HotStrings  ■ 		:*:약어::대체할 내용
	:*:aaa::■{space}			; a를 3번 입력하면 자동으로 ■ 로 대체됨.
	:*:s1::Sleep, 1000{End}
	:*:s2::Sleep, 2000{End}
	:*:q1::Send, {{}enter{}}{left 7}
	:*:flist;::File_List("c:\*.*",0) `; FileList, 0 Fname,1 Ext, 2 Full `nMsgBox, % List_Arr.length() " /  " List_Arr[1] `n
	
	; ■ HotKey ■ 1줄 명령은 return 불필요
	!1::alt1(X1,Y1)			; Alt+1 좌표 클릭 
	!2::alt2(X1,Y1,X2,Y2) ; Alt+2 이미지 클릭 img_click(8, 9,"X.png",7)←7초
	!3::alt3()					; Alt+3  Title창 활성화
	!4::alt4()					; Alt+4  Title창 대기★
	!5::alt5()					; Alt+5  Title창 이동  0,0(X,Y) [,W, H] MoveWindow
	^q::get_pos(X1,Y1)							; 마우스 좌표(X1, Y1) 얻기
	^w::get_pos_click(X1,Y1,X2,Y2)		; X1, Y1의 상대위치 클릭
	^+q::get_pixel(X1,Y1)						; Ctrl+Shift+q Pixel 좌표 및 값얻기
	^+w::get_pixel_click(X1,Y1,X2,Y2)	; Ctrl+Shift+W Pixel 상대위치 클릭
	#c::Run, %A_ScriptDir%\lib\Capture_Tool.ahk ; Win+C → #L마우스
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
	
	:*:web;::  ; ■ iwb2(Alt+B) ; 웹제어 IE 켜진 상태에서
	web_auto()
	get_element()  ; ■ iwb2(Alt+B) ; 요소 선택
	return
	
	:*:clink;::ClickLink(PXL,Text="XX"){left 4}+{right 2}
}