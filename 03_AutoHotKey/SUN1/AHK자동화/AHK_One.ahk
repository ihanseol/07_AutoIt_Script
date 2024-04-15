{  ; ■■ 초기설정 ■■   ^ (Ctrl)  + (Shift)   ! (Alt)   # (Win)
	#NoEnv											; 환경변수 무시, 효율↑
	#Singleinstance Force						; 프로세스 중복 방지
	#Include lib/Chrome/Chrome.ahk	; 크롬 미사용시 주석처리★★
	SendMode Input							; 속도, 안전성↑
	SetTitleMatchMode, 2					; 제목 일부만
	SetWorkingDir %A_ScriptDir%		; 작업폴더기준 
	CoordMode, Pixel,    Screen			; 이미지, 화면
	CoordMode, Mouse, Screen			; 마우스, 화면 ;-----------------
	Gui, Font,  s11 cWhite , 맑은 고딕	; s크기 c컬러, 글꼴  ※ GUI ↓
	Gui, Color, 24085B							; 배경색/ 구글 html color code / green, blue..
	Gui, Add, DropDownList,y10 w65 h350 Choose1 vDrop, 연습1|연습2|연습3|참고
	Gui, Add, Button, x+10 w60	h27				, Google		; 버튼
	Gui, Add, Button, x+10			h27				, 네이버		; 버튼
	Gui, Add, Button, x+10			h27				, 유튜브		; 버튼
	Gui, Add, Text, x10					gLexec			, 실행▶		; Text, g라벨
	Gui, Add, Text, x+10				gLedit			, 편집			; Text,   "
	Gui, Add, Text, x+10				gLsload		, 저장로드	; Text,   "
	Gui, Add, Text, x+10				gLcapture 	,그림캡쳐		; Text,   "
	Gui, Add, Text, x+10				gLquit			, 종료X			; Text,   "
	Gui, +Alwaysontop -Caption	; 항상 위 표시, 제목바 X
	Gui, Show, x1600 y20, One		; x y w(width) h(height) 한칸 띄기 ;~ global Title
	return
	; 듀얼모니터 안될때 : Dual_img_coordinate() 값수정
}
; 좌표클릭(!1) / 이미지클릭(!2) / 창선택(!3) / 창대기(!4) / 창이동(!5)
; 픽셀클릭(^+Q,^+W) / 상대클릭(^q,^w) / 입력(Q1) / 슬립(S1~)
; ^E (편집) / ^R (저장로드) / ^G (그림캡쳐) / !D(폴더) / ex_new
;-------------------------------------------------------------------

Lexec:			; ★g라벨: gLexec g라벨 선언되면 Lexec: 반드시 필요
^Space::		; Ctrl+Space로 실행  ←  DropDownList값 선택 후
{
	Gui, Submit, NoHide	; GUI값 읽기
	if(Drop = "연습1") {
		MsgBox,,, 연습1 클릭,1
		
	}
	else if(Drop = "연습2"){
		MsgBox,,, 연습2 클릭,2
	}else if(Drop = "연습3"){
		MsgBox,,, 연습3 클릭,2
	}else{
		Run, %A_ScriptDir%\lib\ReadMe.txt
	}
}
Return

;-------------------------------------------------------------------

{  ; ■■ 버튼(라벨) 설정 ■■  GUI의 버튼과 연결
	ButtonGoogle:	; Button버튼명: ■ 버튼역할
	Run, chrome.exe www.google.com
	return
	
	Button네이버:
	Run, chrome.exe www.naver.com
	return
	
	Button유튜브:
	Run, chrome.exe www.youtube.com/results?search_query=autohotkey
	return
	
	Lquit:			; g라벨 설정
	GuiClose:	; x 클릭 종료
	ExitApp
	
	^e::				; Ctrl+E  ■  핫키
	Ledit:			; g라벨 설정
	EditorSelect_EngMode()  ; 함수
	Edit				; 편집  	
	return
	
	^r::				; Ctrl+R   ■ 저장 + 갱신
	Lsload:		; g라벨 설정
	Save_Reload()   ; 함수
	return
	; 그림캡쳐는 아래 핫키 부분(^g)
}

;-------------------------------------------------------------------

{ ; ■■ HotKey, HotStrings ■■
	
	; ■ HotStrings  ■   :*:약어::대체할 내용
	:*:aaa::■{space}
	:*:s1::Sleep, 1000{End}
	:*:s2::Sleep, 2000{End}
	:*:q1::Send, {{}enter{}}{left 7}
	:*:flist;::send, File_List("C:\", ext=0)
	
	; ■ HotKey ■   
	!d::Run, %A_ScriptDir%	; Alt+D 작업폴더 열기  ※1줄 명령 return 불필요
	!b::									; Alt+B(!B) ■ 웹자동화 (IE열고 실행)
	IfWinNotExist, iWB2 Learner
		run, %A_ScriptDir%\lib\iWB2.exe
	IfWinExist, iWB2 Learner
		WinActivate, iWB2 Learner
	IfWinNotExist, ahk_class NotifyIconOverflowWindow
		run, %A_ScriptDir%\lib\iWB2_Writer.exe
	return


	!1::		; Alt+1 ■ 좌표 클릭 => MouseClick 오류 해결(0.2초 누름)
	EditorSelect_EngMode()
	MouseGetPos, X1, Y1	; 마우스 좌표 얻기
	SendInput, Click_XY(%X1%, %Y1%) `; `nSleep, 500 `n
	return
	
	!2::		; Alt+2  ■ 이미지 클릭 =====
	MouseGetPos, X2, Y2
	fname := Clipboard ".png"
	if (X2 > A_ScreenWidth)	; 현재 마우스 위치 X2 값이 주모니터 x끝값보다 크면
		Dual_img_coordinate(fname)	; 이미지 좌표(X1,Y1) 얻기 - 듀얼
	else
		img_coordinate(fname)	;이미지 좌표(X1,Y1) 얻기 - 주모니터
	if (X1 <>""){
		aa:=X2-X1	; 클릭할 좌표값 - 이미지 좌표값
		bb:=Y2-Y1
		EditorSelect_EngMode()
		if(X2 > A_ScreenWidth)	; 현재 마우스 위치 X2값이 주 모니터의 x끝값 보다 크면
			SendInput, Dual_img_click(%aa%`, %bb%, "%fname%") `; 기본10초{End} `n
		else
			SendInput, img_click(%aa%`, %bb%, "%fname%") `; 기본10초{End} `n
	}
	else
		MsgBox,,, 이미지 못찾음,1
	return


	!3::		; Alt+3  ■ Title창 활성화 ★ 가장 앞으로 =====
	WinGetActiveTitle, Title
	EditorSelect_EngMode()
	SendInput, WinActivate, %Title% `; Title창 활성화 `nSleep, 200 `n
	return
	
	!4::		;  Alt+4  ■ Title창 대기 (열릴(활성화) 때까지) =====
	WinGetTitle, Title, a  ; 활성창을 Title을 WTitle에 저장 
	EditorSelect_EngMode()
	SendInput, 작업창대기("%Title%") `; 나타날 때까지 `nSleep, 200 `n
	return
	
	!5::		; Alt+5  ■  Title창 이동  0,0(좌상단) [,Width, Height] =====
	WinGetTitle, Title, a
	EditorSelect_EngMode()
	SendInput, WinMove, %Title%,,0,0 `; ,W,H생략 `n
	return	

	^+q::	; ■ 픽셀값 얻기 (Ctrl+Shift+q) =====
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

	^+w::	; ■ 픽셀 기준 상대위치 클릭 명령 (^+w) =====
	MouseGetPos, X2, Y2
	MouseMove, 40, 40,,Relative
	aa:=X2-X1
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, pixel_click(%aa%,%bb%,`"{Ctrl down}{v}{Ctrl up}`") `; 픽셀클릭{End}
	Return	
	
	^q::		; ■ 현좌표 얻기(X1,Y1)  Ctrl+q
	MouseGetPos, X1, Y1
	return

	^w::		; ■ 상대좌표 클릭  Ctrl+w
	MouseGetPos, X2, Y2  ; X1, Y1과의 상대좌표 값 얻기
	EditorSelect_EngMode()
	aa:=X2-X1
	bb:=Y2-Y1
	Sleep, 150
	SendInput, MouseClick, Left, %aa%, %bb%,1,,,R{space} `; `nSleep, 500 `n
	return

	^g::				; Ctrl+G 그림캡쳐  ■■ !2(Alt+2) 관련
	Lcapture:	; ☆라벨 정의
	sPATH := A_WorkingDir . "\PIC"	; 작업폴더 아래  PIC 폴더 
	if (not FileExist(sPath))					; PIC 폴더 없다면 생성
		FileCreateDir, %sPATH%		; 폴더 생성
	InputBox,OutputVar,■ 파일명(.png 생략) 입력,※ 같은 파일 있을 경우 덮어씀 `n`n  ★ 이미지 클릭명령 : 마우스 위치 후  Alt`+2,,,,,,,,파일명
	name := A_WorkingDir "\PIC\" OutputVar ".png" ; 저장경로 파일이름
	Send, #+s					; ■ Win+Shift+S → 사각 설정 전제
	KeyWait, LButton, D	; Mouse 왼쪽버튼 누를때까지 대기
	KeyWait, LButton, U	; Mouse 왼쪽버튼 땔때까지 대기
	sleep, 200					; 오류날때  값조정 ★★★
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
	MsgBox,,,캡쳐 완료, 0.5
	return
	
	;  ■■ 기타 핫스트링(HotStrings) : 새엑셀(ex_new;), 열려있는엑셀(ex_open;), 크롬(chrome;), IE web자동화(web;) 등
	:*:ex_new;::ex:=ComObjCreate(`"Excel.Application`") `;새엑셀 ex로 선언 `nex.Workbooks.Add  `; 새문서 `nex.range(`"A1`").value := 12300 `; 숫자입력 `nex.range(`"B2`").value := `"테스트 문자입력`" `; 문자입력 `nex.ActiveWorkbook.Saveas(A_ScriptDir . "\123_Test.xlsx") `;저장 `nex.DisplayAlerts := false `nex.Quit `;종료 `nMsgBox, 새엑셀 생성 완료 `n

	:*:ex_open;::ex:=ComObjActive(`"Excel.Application`") `;열려있는엑셀 ex로 선언 `nex.sheets(`"DB`").select `;시트명 확인★★ `nMsgBox, `% `"첫행 `" First_Row(ex) `" `/ 끝행 `" Last_Row(ex) `" `/ 첫열 `" First_Col(ex) `" `/ 끝열 `" Last_Col(ex) `" `/ 첫열수 `" First_Col_num(ex) `" `/ 끝열수 `" Last_Col_num(ex) `" `/ Used행 `" Used_Row(ex) `" `/ Used열 `" Used_col_num(ex) `" `/ 기준열 끝행수 `"  EndRows(ex, First_Col(ex)) `; 유효범위의 1번째열의 끝행수 `n{;}ex.Range(`"b2`").End(-4121).Select `;★특정셀의 끝행 선택 -4121(xldown),-4162(xlup) `n
	
	:*:chrome;::IfWinNotExist, ahk_exe chrome.exe `nChrome:=new Chrome()`nPg:=Chrome.GetPage() `nPg.Call(`"Page.navigate`", {{}`"url`"`: `"https://naver.com`"{}}) `;주소 열기 `nPg.WaitForLoad() `n; ■ Copy Selector Value활용 or pg.sel 자동입력 `npg.Evaluate(`"document.querySelectorAll('{#}query')[0].value='AHK'`") `npg.Evaluate(`"document.querySelectorAll('{#}search_btn')[0].click()`") `nPg.WaitForLoad() `;pg.Evaluate(`"document.querySelectorAll('X')[0].value = `" Chrome.Jxon_Dump(Var)) `nMsgBox, 확인 시 자동 종료 `nPg.Call(`"Browser.close`") `nPg.Disconnect() `n	
	
	; ■ 웹제어 Alt+B(!b)에서 요소 제어 / getid;
	:*:web;::pwb:=WBGet() `; 웹포인터 {!}B `npwb.Navigate(`"www.naver.com`") `;주소열기 `nwhile pwb.busy or pwb.ReadyState <>4 `nSleep, 100 `n`;ClickLink(pwb,Text:="Text") `;문자링크 클릭 `npwb.document.getElementByID("XX").click() `; 클릭(ID) `n`;pwb.document.getElementByID("XX").Value :="X" `; 입력(ID) `n`;pwb.document.getElementsByClassName("XX")[0].Value :="X" `; Name, TagName `n`;Focus() `;checked := True `;innerText `;submit() `n`;pwb.document.parentWindow.frames("XX").document.all.tags("BODY")[0].document.getElementByID("XX").Click() `; 클릭(프레임) `n
	
	:*:begin;::{#}Singleinstance Force `; 미종료 상태 새로켜짐 `n{#}NoEnv `; 환경변수 무시 `nSendMode Input `; 속도, 안전성 추천 `nSetWorkingDir `%A_ScriptDir`%  `; 현재 작업폴더 기준 `n
}

;-------------------------------------------------------------------

{  ; ■■ 함수설정 ■■ 
	
	{  ; ■■ 각종함수
		EditorSelect_EngMode(){		; ■ 편집기 선택 및 영어모드 --------
			ifwinexist, ahk_exe SciTE.exe
				WinActivate, ahk_exe SciTE.exe
			ifwinexist, ahk_class Notepad++
				WinActivate, ahk_class Notepad++
			WinGetActiveTitle, Title_name
			ret := IME_CHECK(Title_name) ; Eng Mode
			if (ret = 1)
				Send, {vk15sc138}
			Sleep, 150  ; 본 함수 다음 Sendinput 오류 예방
		}
		
		IME_CHECK(WinTitle){		; 한영모드
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
		}	; End ■ 편집기 선택 및 영어모드 ----------------------------------
		
		;-------------------------------------------------------------------------
		
		; ■ 이미지 좌표값 얻기  !2(Alt+2) 관련
		img_coordinate(ByRef F_name){	; ■ 이미지 좌표값 얻기 !2(Alt+2)
			global X1, Y1
			start_time := A_TickCount  ; 시작시간 - 소요 시간
			Img_Dir := A_ScriptDir "\pic\" F_name ;~ Img_Dir := "*30 " A_ScriptDir "\pic\" F_name
			Loop {	
			ImageSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir	;~ if (X1 <> ""){
				if (ErrorLevel = 0){
					break
				}
				if ((A_index = 1) or (A_index = 3) or (A_index = 5) or (A_index = 10)){
					MouseMove,10,50,,relative ; 마우스 방해 x
				}
				end_time := (A_TickCount - start_time)
				if (end_time >= 3000){
					Break
					MsgBox, 이미지 찾기 실패 `n`n그림캡쳐 범위를 최소화하여 다시 시도하거나 `n`n그래도 안되면 다른 이미지로 시도해 보세요
				}
				Sleep, 100
			}
		}
		
		; ■ 듀얼모니터의 경우 주의
		Dual_img_coordinate(ByRef F_name){  ; ■ 이미지 좌표값 얻기 !2(Alt+2) ※듀얼모니터 가정
			global X1, Y1
			start_time := A_TickCount  ; 시작시간 - 소요 시간
			Img_Dir := A_ScriptDir "\PIC\" F_name
			Loop {
				ImageSearch, X1, Y1, A_ScreenWidth, 0, A_ScreenWidth * 2, A_ScreenHeight,% Img_Dir ;■ 주모니터 x값2배?
				;~ ImageSearch, X1, Y1, 부모니터X값, 0, 부모니터끝x값, 부모니터끝Y값,% Img_Dir ;■ 안될 경우 수정
				if (ErrorLevel = 0){
					break
				}
				if ((A_index = 1) or (A_index = 5) or (A_index = 10) or (A_index = 15)){
					MouseMove,10,50,,relative ; 마우스 방해 x
				}
				end_time := (A_TickCount - start_time)
				if (end_time >= 5000){
					Break
					MsgBox, 이미지 찾기 실패 `n`n그림캡쳐 범위를 최소화하여 다시 시도하거나 `n`n그래도 안되면 다른 이미지로 시도해 보세요
				}
				Sleep, 100
			}
		}
		
		
		; ■ !2 (Alt+2)  ■ 이미지 클릭 / 기본 10초
		img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10){
			start_time := A_TickCount  ; 시작시간 - 소요 시간
			Img_Dir := A_ScriptDir "\PIC\" filename	;~ Img_Dir :=  "*30 " A_ScriptDir "\PIC\" filename
			num:=0
			while(true){
				if (X2 > 1920)  ; ■ FHD 기준
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
					MouseMove,1,50,,relative ; 마우스가 방해 X
				end_time := (A_TickCount - start_time)
				if (end_time >= ntime*1000){
					MsgBox,,, %ntime% 초 그림찾기 실패, 1
					Break
				}
				if (A_index >= 5){
					Img_Dir :=  "*" num " " A_ScriptDir "\PIC\" filename
					num++
				}
				Sleep, 100
			}
		}
		
		; ■ !2 (Alt+2)  ■ 이미지 클릭 / 기본 10초 ※Dual 듀얼모니터의 경우
		Dual_img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10){
			start_time := A_TickCount   ; 시작시간 - 소요 시간
			Img_Dir := A_ScriptDir "\PIC\" filename
			num:=0
			while(true){
				ImageSearch, vx, vy,  A_ScreenWidth, 0, A_ScreenWidth * 2, A_ScreenHeight, % Img_Dir  ; ■ 듀얼주,부모니터 해상도 동일 가정
				;~ ImageSearch, vx, vy, 주모니터끝x값, 0, 부모니터끝x값, 부모니터끝y값, % Img_Dir  ; ■ 필요시 직접 수정
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
					MsgBox,,, %ntime% 초 그림찾기 실패, 1
					Break
				}
				if (A_index >= 5){
					Img_Dir :=  "*" num " " A_ScriptDir "\PIC\" filename
					num++
				}
				Sleep, 100
			}
		}	;  End ■ 이미지 좌표값 얻기  !2(Alt+2) 관련 -------------
		
		;----------------------------------------------------------------
		
		; ^+q  ■ 픽셀 클릭 관련 (기본10초 대기)
		pixel_click(ByRef ax, ByRef ay, ByRef fpixel, ByRef ntime=10){ 
			start_time := A_TickCount  ; 시작시간(소요시간 측정)
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
					;~ Sleep, 350 ; 클릭 오류 예방
					;~ MouseClick, Left, %vx% , %vy%, , , U
					break
				}
				if ((A_index = 10) or (A_index = 20) or (A_index = 50))	
					MouseMove,1,30,,relative
				end_time := A_TickCount - start_time
				if (end_time >= ntime*1000){
					MsgBox,,, %ntime% 초 그림찾기 실패, 1
					Break
				}
				Sleep, 100
			}
		} 

		작업창대기(ByRef Title_name){  ; !4 (Alt+4)  ■ 작업창 대기
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
		
		Click_XY(ByRef px, ByRef py){  ; ■ Click 명령 오류 예방(0.2초간 누르기)
			MouseMove, %px%,%py% 	
			Sleep, 100	
			Click, Down	
			Sleep, 300	
			Click, Up
			;~ MouseClick,Left,%px%,%py%,,,D
			;~ Sleep, 300
			;~ MouseClick,Left,%px%,%py%,,,U
		}
		
		Save_Reload(){  ;  ■ 저장 다시로드
			EditorSelect_EngMode()
			Send, ^s
			Sleep, 150
			reload	
		}
		
		won(Amount){   ; ■ 천단위 표시 : -12,345  ; won Format_Number
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
		
		input_value(ByRef var){  ; ■ var 값  클립보드 복사+붙어넣기
			Clipboard =           ; 초기화
			Clipboard := var    ; 클립보드 넣기
			ClipWait, 2            ; 저장될 때까지 대기
			SendInput, {Ctrl Down}v{Ctrl Up}
		}
		
		find_text_enter(ByRef ax){  ; ■ 문자 검색후 엔터(^F)
			SendInput, {Ctrl Down}f{Ctrl Up}
			Sleep, 300
			SendInput, %ax%
			Sleep, 150
			Send, {Esc}
			Sleep, 150
			Send, {Enter}	
		}
		
		ocr_num(ByRef var){ 	; ■ OCR 숫자인식 함수보완
		   var := strreplace(var,"O",0)
		   var := strreplace(var,"I",1)
		   var := strreplace(var,",")
		   var := strreplace(var," ")
		   var := strreplace(var,"`r`n",,All)
		   var := var * 1
		   Return var
		}
		
		ymd(var_date){  ;  ■ 년월일 붙이기 20220101 ← 프로그램 날짜입력 방식
			StringReplace, var,var_date, -,,All
			return var
		}
		
		;  ■ flist;  File_List("c:\") 파일명만 / File_List("c:\",1) 확장자포함, 2 Full
		File_List(ByRef Dir, ByRef ext=0){  ; File_List("경로명"[,01]) ; List_Arr[1]
			global List_Arr := []
			Loop, % Dir {	;~ Loop, % Dir . "*.*"
				if(ext = 0){
					StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
					List_Arr.Push(FileNameNoExt)
				}else if(ext=1){
					List_Arr.Push(A_LoopFileName) ; 확장자 포함
				}else{
					List_Arr.Push(A_LoopFileFullPath)
				}
			}
			return List_Arr
		}
		
		WBGet(WinTitle="ahk_class IEFrame", Svr#=1){   ; ■■ Pointer to Open IE Window
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
		
		ClickLink(PXL,Text=""){  ; ■  iwb2 문자 링크 클릭
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

	{  ; ■■ 엑셀 함수 https://www.the-automator.com/excel-and-autohotkey
		First_Row_original(xlname){  ; ■ 첫행수(원래) : First_Row(객체명)
		   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
		}
		
		First_Row(xlname){  ; ■ Used 첫행수 : First_Row(객체명)
		   Loop { ; Used열의 첫행은 빈셀이 아니라는 전제 (자료있음)
				if (xlname.Cells(A_index, First_Col_Num(xlname)).value <> ""){
					end_numbers := A_index  ; 마지막 Row 갯수
					break
				}
			}
			return end_numbers
		}
		
		Last_Row(xlname){  ; ■ 마지막 행수 (원본): Last_Row(객체명)
			if  (Last_Row_original(xlname)=1) or (Last_Row_original(ex)=1)
				return 1
			var:=xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
			Loop { ; Used 끝행  7개 셀 중  비어있지 않은 셀이 있다면  멈추고  행수 반환
				if (xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,1).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,2).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,3).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,4).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,5).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,6).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,7).value <>""){
					end_numbers := var - A_index  + 1 ; 마지막 Row 갯수
					break
				}
			}
			return end_numbers
		}

		Last_Row_original(xlname){  ; ■ 마지막 행수 (원본): Last_Row(객체명)
			return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
		}
		
		Used_Row(xlname){  ; ■ Used행수 : Used_Row(객체명)
			return xlname.ActiveSheet.UsedRange.Rows.Count
		}
		
		First_Col_Num(xlname){ ; ■ 첫번째 칼럼 number
		   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		}
		
		Last_Col_Num(xlname){ ; ■ 마지막 칼럼  number
			return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
		}
		
		Used_Col_Num(xlname){ ; ■ Used 마지막 칼럼  number
			return xlname.ActiveSheet.UsedRange.Columns.Count 
		}
		
		First_Col(xlname){  ; ■ 첫번째 칼럼  alpabet
			FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
			IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
				Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
		}
		
		; ■ 사용된 범위 : 1이면  처음부터, 0이면 헤더 제외
		Used_Rng(xlname,Header=1){   ; Used_Rng(ex,1) ; Use header to include first row
			if(Last_Row_original(xlname)=1)
				return xlname.Range("1:1")  ; 이게 ....
		IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
		IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
		}
		
		Last_Col(xlname){ ; ■ 마지막 칼럼 alpabet : Last_Col(객체명)
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
		
		; ■ 열의 끝행수 → EndRows(ex, 1) ; 1열(A)의 끝행수
		EndRows(ByRef xlname, ByRef col_num=1){
			num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; 사용범위 끝행수
			Loop {
				if (xlname.Cells(num - A_index, col_num).value <> ""){
					end_numbers := num - A_index  ; 마지막 Row 갯수
					break
				}
			}
			return end_numbers
		}
	}  ; End  ■ 엑셀 관련 함수
	
	; -------------------------------------------------------------------------------
	
	{  ; ■■ 이미지 How to save image in clipboard. 클립보드 이미지 저장
		; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=94345
		/* 사용법 : 원하는 내용 클립보드 저장 후 아래코드 실행
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


;~ ^t::		; ■ OCR 문자인식 - 추후 보완 필요
;~ MouseGetPos, X2, Y2
;~ EditorSelect_EngMode()
;~ aa:=X1 - X2
;~ bb:=Y1 - Y2
;~ SendInput, ocr_text := GetOCR(%X2%, %Y2%, %aa%, %bb%){space}{enter}
;~ SendInput, ocr_num(ocr_text){enter}
;~ sendinput, ocr_text < 0{left 12};{end}{enter}
;~ return