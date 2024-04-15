#NoEnv
#SingleInstance, Force
SendMode Input
SetTitleMatchMode, 2				; 제목 일부만
SetWorkingDir %A_ScriptDir%	; Ensures a consistent starting directory.
CoordMode, Pixel,    Screen		; 이미지, 화면
CoordMode, Mouse, Screen		; 마우스, 화면
SetFormat,FLOAT,0.0					; 엑셀 소숫점 6자리 X
var+=0
global Title
global X2
; ================================

alt1(ByRef X1, ByRef Y1){		; Alt+1(!1) ■ 좌표 클릭
	MouseGetPos, X1, Y1
	EditorSelect_EngMode()	; 편집기 선택 및 영어모드
	SendInput, Click_XY(%X1%, %Y1%) `; `nSleep, 1000 `n
}

; Alt+2(!2) ■ 이미지 클릭 ※img_click(8, 9,"X.png",5)←5초 찾기
alt2(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2){
	MouseGetPos, X2, Y2  ; 마우스 현재위치 값 얻기
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
}


alt3(){  ; Alt+3(!3) ■ Title창 활성화 : 맨 앞으로
	WinGetActiveTitle, WTitle
	EditorSelect_EngMode()
	SendInput, WinActivate, %WTitle% `; Title창 활성화 `nSleep, 200 `n ; 안정성 UP
}

alt4(){  ; Alt+4(!4) ■ Title창이 열릴 때까지 대기
	WinGetTitle, WTitle, a  ; 활성창 Title을 WTitle에 저장 
	EditorSelect_EngMode()
	SendInput, 작업창대기("%WTitle%") `; 나타날 때까지 `nSleep, 200 `n
}

alt5(){  ; Alt+5(!5) ■  Title창 이동  0,0(좌상단) [,Width, Height] 작업창이동
	WinGetTitle, WTitle, a
	EditorSelect_EngMode()
	SendInput, WinMove, %WTitle%,,0,0 `; ,W,H생략 `n ; 좌상단
}

get_pos(ByRef X1, ByRef Y1){  ; ■ 현좌표 얻기(X1,Y1)
	MouseGetPos, X1, Y1
}

get_pos_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2){  ; ■ 상대좌표 클릭
	MouseGetPos, X2, Y2  ; X1, Y1과의 상대좌표 값 얻기
	EditorSelect_EngMode()
	aa:=X2-X1
	bb:=Y2-Y1
	SendInput, MouseClick, Left, %aa%, %bb%,1,,,R{space} `; `nSleep, 500 `n
}

get_pixel(ByRef X1, ByRef Y1){  ; ■ 현좌표 및 픽셀값 얻기
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
		MouseMove,0,5,,relative ; 아래로 5pixel 내림
		Sleep, 100
	}
} 

get_pixel_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2){  ; ^+W■ 픽셀 클릭 → 상대위치 클릭
	MouseGetPos, X2, Y2
	MouseMove, 40, 40,,Relative
	aa:=X2-X1
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, pixel_click(%aa%,%bb%,`"{Ctrl down}{v}{Ctrl up}`") `; 픽셀클릭{End}
	Return
}


Capture_PNG(){  ; ■ 그림캡쳐
	sPATH := A_WorkingDir . "\PIC"	; 작업폴더 아래  PIC 폴더 
	if (not FileExist(sPath))					; PIC 폴더 없다면 생성
		FileCreateDir, %sPATH%			; 폴더 생성
	InputBox,OutputVar,■ 파일명(.png 생략) 입력,※ 같은 파일 있을 경우 덮어씀 `n`n  ★ 이미지 클릭명령 : 마우스 위치 후  Alt`+2,,,,,,,,파일명
	name := A_WorkingDir "\PIC\" OutputVar ".png" ; 저장경로 파일이름
	Send, #+s	; ■ Win+Shift+S → 사각 설정 전제
	KeyWait, LButton, D	; Mouse 왼쪽버튼 누를때까지 대기
	KeyWait, LButton, U	; Mouse 왼쪽버튼 땔때까지 대기
	sleep, 200
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
}
 
Open_Workingdir(){	; Alt+D(!D) ■ 작업 열기
	IfWinNotExist, ahk_class CabinetWClass
		Run, %A_WorkingDir%\
	WinActivate, ahk_class CabinetWClass
}

Open_Iwb2(){	; Alt+B(!B) ■ 웹자동화 (IE열고 실행)
	IfWinNotExist, iWB2 Learner
		run, %A_ScriptDir%\lib\iWB2.exe
	IfWinExist, iWB2 Learner
		WinActivate, iWB2 Learner
	IfWinNotExist, ahk_class NotifyIconOverflowWindow
		run, %A_ScriptDir%\lib\iWB2_Writer.exe
}
	
send_enter(){
	WinGetActiveTitle, Title_name ; 활성화된 윈타이틀 가져옴
	ret := IME_CHECK(Title_name)
	if (ret = 1){
		SendInput, {vk15sc138}
	} 
	SendInput, Send, {{}enter{}}{left 7}
}

Open_TEST_EXCEL(){
	IfWinNotExist, TEST_EXCEL
	{
		Run, %A_WorkingDir%\TEST\TEST_EXCEL.xlsm ; 엑셀파일 열어(Run)
		WinWaitActive, TEST_EXCEL ; Title창이 활성화될 때까지  대기
	}
	IfWinExist, TEST_EXCEL
		WinActivate, TEST_EXCEL
	Reload
}

;===============================================

EditorSelect_EngMode(){		;  ■ 편집기 선택 및 영어모드 ------------------
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

IME_CHECK(WinTitle){  ; 한영모드
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
}  ; End ■ 편집기 선택 및 영어모드 -----------------------------------


; ■ 이미지 관련(!2)
img_coordinate(ByRef F_name){	; ■ 이미지 좌표값 얻기 !2(Alt+2)
	global X1, Y1
	start_time := A_TickCount  ; 시작시간 - 소요 시간
	Img_Dir := A_ScriptDir "\pic\" F_name ;~ Img_Dir := "*30 " A_ScriptDir "\pic\" F_name
	Loop {	
	ImageSearch, X1, Y1, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir	;~ if (X1 <> ""){
		if (ErrorLevel = 0){
			break
		}
		if ((A_index = 1) or (A_index = 5) or (A_index = 10) or (A_index = 15)){
			MouseMove,10,50,,relative ; 마우스 방해 x
		}
		end_time := (A_TickCount - start_time)
		if (end_time >= 5000){  ; 5초간 이미지 못찾으면 종료 후 메시지 출력
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


; ^+q  ■ 픽셀 클릭 관련 (기본10초 대기)
pixel_click(ByRef ax, ByRef ay, ByRef fpixel, ByRef ntime=10){ 
	start_time := A_TickCount  ; 시작시간(소요시간 측정)
	while(true){
		PixelSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,fpixel, , Fast RGB
		if (vx <> ""){
			vx := vx + ax
			vy := vy + ay   ;~ MouseClick, Left, %vx%, %vy% 
			MouseMove, %vx%, %vy%
			Click, Down
			Sleep, 300
			Click, Up
			break
		}
		if ((A_index = 10) or (A_index = 30) or (A_index = 50))	
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
	MouseMove, %px%, %py%
	Click, Down
	Sleep, 300
	Click, Up
}

Save_Reload(){  ;  ■ 저장 다시로드
	EditorSelect_EngMode()
	Send, {CtrlDown}s{CtrlUp} ; Ctrl+S(^s)
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


;=============================================

; ■■ Pointer to Open IE Window
WBGet(WinTitle="ahk_class IEFrame", Svr#=1){
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
	

;============================================

; ■■ 엑셀 함수  ■■ https://www.the-automator.com/excel-and-autohotkey
First_Row_original(xlname){  ; ■ 첫행수(원래) : First_Row(객체명)
   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
}

First_Row(xlname){  ; ■ Used 첫행수 : First_Row(객체명)
   Loop {  ; Used열의 첫행은 빈셀이 아니라는 전제 (자료있음)
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



;============================================
; How to save image in clipboard.  클립보드 이미지 저장방법
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=94345
;============================================
/* 사용법 : 원하는 내용 클립보드 저장 후 아래코드 실행
hBM := CB_hBMP_Get()  
If ( hBM ) { ;~ sFile := A_ScriptDir "\\" A_Now ".png"
	sFile := A_ScriptDir "\\" "xxx.png"
	GDIP("Startup")
	SavePicture(hBM, sFile) 
	GDIP("Shutdown")
	DllCall( "DeleteObject", "Ptr",hBM )
	If FileExist(sFile)
		SoundBeep
}  
*/

CB_hBMP_Get() {                                        ; By SKAN on D297 @ bit.ly/2L81pmP
Local OK := [0,0,0,0]
	OK.1 := DllCall( "OpenClipboard", "Ptr",0 )
  OK.2 := OK.1 ? DllCall( "IsClipboardFormatAvailable", "UInt",8 ) : 0  ; CF_BITMAP
  OK.3 := OK.2 ? DllCall( "GetClipboardData", "UInt", 2, "Ptr" )   : 0
  OK.4 := OK.1 ? DllCall( "CloseClipboard" ) : 0  
Return OK.3 ? DllCall( "CopyImage", "Ptr",OK.3, "Int",0, "Int",0, "Int",0, "UInt",0x200C, "Ptr" )
          + ( ErrorLevel := 0 ) : ( ErrorLevel := !OK.2 ? 1 : 2 ) >> 2          
}

SavePicture(hBM, sFile) {                            ; By SKAN on D293 @ bit.ly/2L81pmP 
Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
  E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
  E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
  NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
  E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
  E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
} 

GDIP(C:="Startup") {                                  ; By SKAN on D293 @ bit.ly/2L81pmP
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
}  ; End Save image in clipboard



;=======================================

; ■ 네이버 로그인
naver_login(){
	Chrome:=new Chrome()
	Pg:=Chrome.GetPage()
	Pg.Call("Page.navigate", {"url": "https://naver.com"})
	Pg.WaitForLoad()
	Sleep, 200
	pg.Evaluate("document.querySelectorAll('#account > a > i')[0].click()") 
	Pg.WaitForLoad()	
	Sleep, 1000
	Send, {Tab 10}{Enter}
	chrome =
	pg =
}


begin_ahk(){  ; 초기세팅
	SendInput, {#}Singleinstance Force `; 미종료 상태 새로켜짐 `n{#}NoEnv `; 환경변수 무시 `nSendMode Input `; 속도, 안전성 추천 `nSetWorkingDir `%A_ScriptDir`%  `; 현재 작업폴더 기준 `n
}


; ■■ 핫스트링 설정 ■■
excel_Opened(){  ; ex_open; 열린엑셀
	SendInput, ex:=ComObjActive(`"Excel.Application`") `;열려있는엑셀 ex로 선언 `nex.sheets(`"DB`").select `;시트명 확인★★ `nMsgBox, `% `"첫행 `" First_Row(ex) `" `/ 끝행 `" Last_Row(ex) `" `/ 첫열 `" First_Col(ex) `" `/ 끝열 `" Last_Col(ex) `" `/ 첫열수 `" First_Col_num(ex) `" `/ 끝열수 `" Last_Col_num(ex) `" `/ Used행 `" Used_Row(ex) `" `/ Used열 `" Used_col_num(ex) `" `/ 기준열 끝행수 `"  EndRows(ex, First_Col(ex)) `; 유효범위의 1번째열의 끝행수 `n{;}ex.Range(`"b2`").End(-4121).Select `;★특정셀의 끝행 선택 -4121(xldown),-4162(xlup) `n
}

excel_Open_file(){ ; ex; 기존 엑셀 열기
	SendInput Path := A_ScriptDir `"\TEST\TEST_EXCEL.xlsm`" `; 경로포함 `;Path := `"C:\XX.xlsm`" `nex:=ComObjCreate(`"Excel.Application`") `nex.visible:=True `;보이기 `nex.Workbooks.Open(Path) `; path 열기 `nex := ComObjActive(`"Excel.Application`") `nex.sheets("DB").select  `; 시트 선택 `nex.DisplayAlerts := false `; 저장 시 확인X `nSleep, 3000 `n`;ex.ActiveWorkbook.Saveas(A_ScriptDir . `"\123.xlsx`") `; 다름이름 저장 `n`;ex.ActiveWorkbook.Save() `; 같은 이름 저장 시 `nex.Quit `; 종료 `n
}

excel_Arr(){
	SendInput, ex:=ComObjActive(`"Excel.Application`") `; 열려있는 엑셀 ex로 선언 `nex.sheets(`"DB`").select `; 시트 선택★  ↓배열 Arr 선언 → 사용은 Arr[행,열] `nArr:=ex.Range(First_Col(ex) . First_Row(ex) . `"`:`" Last_Col(ex) . Last_Row(ex)).value `nnums:=EndRows(ex,1) `; X열 끝행수 `nnum:=EndRows(ex,1) - First_Row(ex) {+} 1 `; X열 끝행수-배열위치 `nMsgBox `% `"A끝행수 `: `" nums `" `/ 배열값 Arr[num,3] : `" Arr[num,3] `n`; ex.Range(`"A`" . num).value = ex.cells(num,1).value = Arr[num,1] `n
ex.Quit ; 종료
}

excel_New(){  ; ex_new; 새엑셀 생성, 편집, 저장
	SendInput, ex:=ComObjCreate(`"Excel.Application`") `;새엑셀 ex로 선언 `nex.Workbooks.Add  `; 새문서 `nex.range(`"A1`").value := 12300 `; 숫자입력 `nex.range(`"B2`").value := `"테스트 문자입력`" `; 문자입력 `nex.ActiveWorkbook.Saveas(A_ScriptDir . "\123_Test.xlsx") `;저장 `nex.DisplayAlerts := false `nex.Quit `;종료 `nMsgBox, 새엑셀 생성 완료 `n
}

chrome_auto(){
	SendInput, IfWinNotExist, ahk_exe chrome.exe `nChrome:=new Chrome()`nPg:=Chrome.GetPage() `nPg.Call(`"Page.navigate`", {{}`"url`"`: `"https://naver.com`"{}}) `;주소 열기 `nPg.WaitForLoad() `n; ■ Copy Selector Value활용 or pg.sel 자동입력 `npg.Evaluate(`"document.querySelectorAll('{#}query')[0].value='AHK'`") `npg.Evaluate(`"document.querySelectorAll('{#}search_btn')[0].click()`") `nPg.WaitForLoad() `;pg.Evaluate(`"document.querySelectorAll('X')[0].value = `" Chrome.Jxon_Dump(Var)) `nMsgBox, 확인 시 자동 종료 `nPg.Call(`"Browser.close`") `nPg.Disconnect() `n
}

web_auto(){  ; web; IE전용
	SendInput, pwb:=WBGet() `; 웹포인터 {!}B `npwb.Navigate(`"www.naver.com`") `;주소열기 `nwhile pwb.busy or pwb.ReadyState <>4 `nSleep, 100 `n`;ClickLink(pwb,Text:="Text") `;문자링크 클릭 `n
}

get_element(){  ; Alt+B(!b)에서 요소 제어 / getid;
	SendInput, pwb.document.getElementByID("XX").click() `; 클릭(ID) `n`;pwb.document.getElementByID("XX").Value :="X" `; 입력(ID) `n`;pwb.document.getElementsByClassName("XX")[0].Value :="X" `; Name, TagName `n`;Focus() `;checked := True `;innerText `;submit() `n`;pwb.document.parentWindow.frames("XX").document.all.tags("BODY")[0].document.getElementByID("XX").Click() `; 클릭(프레임) `n
}


;=======================================
; 기타 참고
;=======================================

Click_Png(ByRef fname,variance=0,ByRef XX=0,ByRef YY=0){
	scan := new ShinsImageScanClass() ;no title supplied so using
	name := A_WorkingDir "\PIC\" fname
	scan.Click_Image(name,variance,XX,YY) 
}

; 문제점 : 작업창 활성화 ?  TEST중
ControlClickL(ByRef px, ByRef py, ByRef Title){   ; 0.3초간 눌러주기
	SetControlDelay, 200
	ControlClick, x%px% y%py%, %Title%,,L,,D
	Sleep, 300  ; 없으면, 새창?
	ControlClick, x%px% y%py%, %Title%,,L,,U
	Sleep, 300
}


PostClick(ByRef px, ByRef py, ByRef Title){  ; TEST중
	 lparam:=px|py<<16          ; 좌표값 16진수로 받음
	PostMessage,0x201,1,%lparam%,,%Title% ; 누름
	sleep, 300
	PostMessage,0x202,0,%lparam%,,%Title% ; 떼기
	;~ PostMessage,0x201,1,%lparam%,Internet Explorer_Server1,%WTitle% ; 누름
	;~ sleep, 300
	;~ PostMessage,0x202,0,%lparam%,Internet Explorer_Server1,%WTitle% ; 떼기
	Sleep, 300   ;  0.3초 sleep ?
}

/*

^1::  ; ■ Ctrl+1 → ControlClick  ■ 비활성 좌표클릭 명령
WinGetActiveTitle, Title  ;~ Coordmode,mouse,relative  ; 창기준 마우스 좌표값
CoordMode, Pixel,    Relative   ; 이미지, 창기준
CoordMode, Mouse, Relative   ; 마우스, 창기준
mousegetpos,px,py            ; 마우스 좌표값을 얻어옵니다.
WinActivate, ahk_class SciTEWindow ; 편집창 활성화
EditorSelect_EngMode()
SendInput, ControlClickL(%px%, %py%, "%WTitle%") `n`;`~ PostClick(%px%, %py%, "%WTitle%") `n`;`~ ControlSend, , xx, %WTitle% `; 내용 입력 IE는 Internet Explorer_Server1 `n
return

^2::  ; Ctrl+2  ■ 비활성 이미지 클릭 =====
WinGetActiveTitle, Title
MouseGetPos, X2, Y2
fname := Clipboard ".png"
img_coordinate(fname) ; 이미지 좌표(X1,Y1) 구하기
aa:=X2-X1  ; 클릭 좌표 - 이미지 좌표
bb:=Y2-Y1
EditorSelect_EngMode()
SendInput, PostClick_png(%aa%`, %bb%, "%fname%" , "%Title%") `; 창제목 수정`n
return
