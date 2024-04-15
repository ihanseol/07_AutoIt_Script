; ■ 설정 및 GUI 
#Singleinstance Force ; 미종료 상태에서 새로 켜짐(중복된 프로세스 방지)
#NoEnv                  ; 환경변수 무시, 스크립트 효율↑
SendMode Input   ; 속도, 안전성 추천
SetWorkingDir %A_ScriptDir%  ; 현재 작업폴더 기준 
#Include %A_ScriptDir%\lib\Gdip_all.ahk ; 이미지 Lib
#Include %A_ScriptDir%\lib\Chrome\Chrome.ahk ; Chrome Lib
SetTitleMatchMode, 2  ; 타이틀 일부만
CoordMode, Pixel, Screen  ; 전체화면  이미지
CoordMode, Mouse, Screen ; 전체화면 마우스
SetFormat,FLOAT,0.0  ; 엑셀 소숫점 6자리 X
var+=0
; ================================

; Alt+1(!1) ■ 좌표 클릭
alt1(ByRef X1, ByRef Y1)
{
	MouseGetPos, X1, Y1
	EditorSelect_EngMode() ; 편집기 선택 및 영어모드
	SendInput, Click, %X1%, %Y1% `; `nSleep, 1000 `n
}

; Alt+2(!2) ■ 이미지 클릭 ※img_click(8, 9,"X.png",5)←5초 찾기
alt2(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2
	fname := Clipboard ".png"
	img_coordinate(fname) ; 이미지 좌표(X1,Y1) 구하기
	aa:=X2-X1  ; 클릭할 좌표값 - 이미지 좌표값
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, img_click(%aa%`, %bb%, "%fname%") `; 기본10초{End} `n
}

; Alt+3(!3) ■ Title창 활성화 : 맨 앞으로
alt3()
{
	WinGetActiveTitle, WTitle
	EditorSelect_EngMode()
	SendInput, WinActivate, %WTitle% `; Title창 활성화 `nSleep, 200 `n ; 안정성 UP
}

;  Alt+4(!4) ■ Title창이 열릴 때까지 대기
alt4()
{
	WinGetTitle, WTitle, a  ; 활성창 Title을 WTitle에 저장 
	EditorSelect_EngMode()
	SendInput, 작업창대기("%WTitle%") `; 나타날 때까지 `nSleep, 200 `n
}

; Alt+5(!5) ■  Title창 이동  0,0(좌상단) [,Width, Height] 작업창이동
alt5()
{
	WinGetTitle, WTitle, a
	EditorSelect_EngMode()
	SendInput, WinMove, %WTitle%,,0,0 `; ,W,H생략 `n ; 좌상단
}

; ■ 현좌표 얻기(X1,Y1)
get_pos(ByRef X1, ByRef Y1)
{
	MouseGetPos, X1, Y1
}

; ■ 상대좌표 클릭
get_pos_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2  ; X1, Y1과의 상대좌표 값 얻기
	EditorSelect_EngMode()
	aa:=X2-X1
	bb:=Y2-Y1
	SendInput, MouseClick, Left, %aa%, %bb%,1,,,R{space} `; `nSleep, 500 `n
}

; ■ 현좌표 및 픽셀값 얻기
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
		MouseMove,0,5,,relative ; 아래로 5pixel 내림
		Sleep, 100
	}
} 

; ^+W■ 픽셀 클릭 → 상대위치 클릭
get_pixel_click(ByRef X1, ByRef Y1, ByRef X2, ByRef Y2)
{
	MouseGetPos, X2, Y2
	MouseMove, 40, 40,,Relative
	aa:=X2-X1
	bb:=Y2-Y1
	EditorSelect_EngMode()
	SendInput, pixel_click(%aa%,%bb%,`"{Ctrl down}{v}{Ctrl up}`") `; 픽셀클릭{End}
	Return
}

Capture_PNG() ; ■ 그림캡쳐
{
	pToken := Gdip_Startup()
	sPATH := A_WorkingDir . "\PIC" ; 작업폴더 아래  PIC 폴더 
	if (not FileExist(sPath))           ; PIC 폴더 없다면 생성
		FileCreateDir, %sPATH%    ; 폴더 생성하라
	InputBox,OutputVar,■ 파일명(.png 생략) 입력,※ 같은 파일명이 있을 경우 덮어씁니다. `n`n  ★ 이미지 클릭명령 : 마우스 위치 후  Alt`+2,,,,,,,,파일명
	name := A_WorkingDir "\PIC\" OutputVar ".png" ; 저장경로 파일이름	;~ name := A_ScriptDir "\PIC\" OutputVar ".png" ; 저장경로 파일이름
	Send, #+s ; ■ Win+shift+s
	KeyWait, LButton, D  ; 왼쪽버튼 누를때까지 대기
	KeyWait, LButton, U  ; 왼쪽버튼 땔때까지 대기
	sleep, 100
	pBitmap := Gdip_CreateBitmapFromClipboard()
		Gdip_SaveBitmapToFile(pBitmap, name)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	sleep, 200
	Clipboard =
	Clipboard := OutputVar
	ClipWait, 2
	MsgBox,,,캡쳐 완료, 0.5
}
 
Open_Workingdir() ; Alt+D(!D) ■ 작업 열기
{
	IfWinNotExist, ahk_class CabinetWClass
		Run, %A_WorkingDir%\
	WinActivate, ahk_class CabinetWClass
}

Open_Iwb2() ; Alt+B(!B) ■ 웹자동화 (IE열고 실행)
{	
	IfWinNotExist, iWB2 Learner
		run, %A_ScriptDir%\lib\iWB2.exe
	IfWinExist, iWB2 Learner
		WinActivate, iWB2 Learner
	IfWinNotExist, ahk_class NotifyIconOverflowWindow
		run, %A_ScriptDir%\lib\iWB2_Writer.exe
}
	
; ■ 편집기 선택(전용편집기 or Notepad++) 및 Eng Mode
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
	WinGetActiveTitle, Title_name ; 활성화된 윈타이틀 가져옴
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
		Run, %A_WorkingDir%\TEST\TEST_EXCEL.xlsx ; 엑셀파일 열어(Run)
		WinWaitActive, TEST_EXCEL ; Title창이 활성화될 때까지  대기
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
		if (X1 <> "")	 ; X1 값이 있다면
			break        ; Loop 탈출
		if ((A_index = 10) or (A_index = 30) or (A_index = 100))
			MouseMove,1,50,,relative ; 마우스 방해 x
		Sleep, 100
	}
} 

; ■ !2 (Alt+2) : 이미지 클릭 / 기본 10초
img_click(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=15)
{
	start_time := A_TickCount  ; 시작시간 - 소요 시간
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
			MouseMove,1,50,,relative ; 마우스가 방해 X
		end_time := (A_TickCount - start_time)
		if (end_time >= ntime*1000)
		{
			MsgBox,,, %ntime% 초 그림찾기 실패, 1
			Break
		}
		Sleep, 100
	}
}

img_move(ByRef ax, ByRef ay, ByRef filename, ByRef ntime=10)
{
	start_time := A_TickCount  ; 시작시간 - 소요 시간
	Img_Dir := A_ScriptDir "\PIC\" filename
	while(true) 
	{
		ImageSearch, vx, vy, 0, 0, A_ScreenWidth, A_ScreenHeight,% Img_Dir
		if (vx <> "")	
		{
			vx := vx + ax
			vy := vy + ay
			MouseMove, %vx%, %vy%  ; 이동만
			break
		}
		if ((A_index = 20) or (A_index = 40) or (A_index = 70))
			MouseMove,1,50,,relative ; 마우스가 방해 X
		end_time := (A_TickCount - start_time)
		if (end_time >= ntime*1000)
		{
			MsgBox,,, %ntime% 초 그림찾기 실패, 1
			Break
		}
		Sleep, 100
	}
}

; ■ ^+q: 픽셀클릭(기본10초)
pixel_click(ByRef ax, ByRef ay, ByRef fpixel, ByRef ntime=10)
{
	start_time := A_TickCount  ; 시작시간(소요시간 측정)
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
			MsgBox,,, %ntime% 초 그림찾기 실패, 1
			Break
		}
		Sleep, 100
	} ; End while
} 

; ■ !4 (Alt+4) ■ 작업창대기
작업창대기(ByRef Title_name)
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

; ■ 천단위 표시 : -12,345  ; won Format_Number
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

; ■ var 값  클립보드 복사+붙어넣기
input_value(ByRef var)
{
	Clipboard =          ; 초기화
	Clipboard := var   ; 클립보드 넣기
	ClipWait, 2            ; 저장될 때까지 대기
	SendInput, {Ctrl Down}v{Ctrl Up}
}

; ■ 문자 검색후 엔터(^f) ; 테스트중
find_text_enter(ByRef ax)
{
	SendInput, {Ctrl Down}f{Ctrl Up}
	Sleep, 100
	SendInput, %ax%
	Send, {Esc}{Enter}	
}

; ■ OCR 숫자인식 함수보완
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
{  ; ■ 한영모드
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


;참고: https://www.the-automator.com/excel-and-autohotkey/  등
{ ; ■■ 엑셀 Excel Function  ■■
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
}


{ ; ■■ Pointer to Open IE Window ■■
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
	{ ; ■ iwb2 문자 링크 클릭
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
}  ; ■ Pointer to Open IE Window ■


; ■■ 핫스트링 설정 ■■

excel_New()  ; 새로운 엑셀 생성, 편집, 저장(현재 스크립트 폴더에)  ex_new; 
{
	SendInput, `;`■ New엑셀 생성, 입력, 저장(현재 스크립트 폴더에) `nex:=ComObjCreate(`"Excel.Application`") `;New엑셀 ex로 선언 `nex.Workbooks.Add  `; 새문서 생성 `nex.range(`"A1`").value := 12300 `; 숫자입력 `nex.range(`"B2`").value := `"테스트 문자입력`" `; 문자입력 `nex.DisplayAlerts := false `nex.ActiveWorkbook.Saveas(A_ScriptDir . "\123_Test.xlsx") `;저장 `nex.Quit `;종료 `nMsgBox, 새로운 엑셀이 생성되었습니다 `n
}

excel_read() ; 기존 엑셀 열기
{
	SendInput, `;`■ 기존 엑셀 열기 `npath := A_ScriptDir . `"\TEST\TEST_EXCEL.xlsx`" `; 스크립트 폴더내 엑셀파일 `nex := ComObjCreate(`"Excel.Application`") `; ex 선언 `nex.Workbooks.Open(path) `; 엑셀열기 `nex.Visible := true `; 보이기 `n`; ex.DisplayAlerts := false  `; 확인, 경고 X `n`; ex.ActiveWorkbook.Save() `; 같은이름 저장, 다른이름은 괄호내 `n`; ex.quit `; 종료 `n
}

excel_Open()  ; ex_open; 열린 엑셀 제어
{
	SendInput, `;`■ 이미 열려있는 엑셀 제어 `nex:=ComObjActive(`"Excel.Application`") `;`■열려있는엑셀 ex로 선언 `nex.sheets(`"DB`").select `;시트명 확인★★ `nMsgBox, `% `"첫행 `" First_Row(ex) `" `/ 끝행 `" Last_Row(ex) `" `/ 첫열 `" First_Col(ex) `" `/ 끝열 `" Last_Col(ex) `" `/ 첫열수 `" First_Col_num(ex) `" `/ 끝열수 `" Last_Col_num(ex) `" `/ Used행 `" Used_Row(ex) `" `/ Used열 `" Used_col_num(ex) `" `/ 기준열 끝행수 `"  EndRows(ex, First_Col(ex)) `; 유효범위의 1번째열의 끝행수 `n{;}ex.Range(`"b2`").End(-4121).Select `;★특정셀의 끝행 선택 -4121(xldown),-4162(xlup) `; 상대주소 Offset(행,열) `n
}

excel_Arr()
{
	SendInput, ex:=ComObjActive(`"Excel.Application`") `; 열려있는 엑셀 ex로 선언 `nex.sheets(`"DB`").select `; 시트 선택★  ↓배열 Arr 선언 → 사용은 Arr[행,열] `nArr:=ex.Range(First_Col(ex) . First_Row(ex) . `"`:`" Last_Col(ex) . Last_Row(ex)).value `nnums:=EndRows(ex,1) `; X열 끝행수 `nnum:=EndRows(ex,1) - First_Row(ex) {+} 1 `; X열 끝행수-배열위치 `nMsgBox `% `"A끝행수 `: `" nums `" `/ 배열값 Arr[num,3] : `" Arr[num,3] `n`; ex.Range(`"A`" . num).value = ex.cells(num,1).value = Arr[num,1] `n
}


chrome_auto()
{
	SendInput, Chrome:=new Chrome()`nPg:=Chrome.GetPage() `nPg.Call(`"Page.navigate`", {{}`"url`"`: `"https://naver.com`"{}}) `nPg.WaitForLoad() `n; ■ Copy Selector Value활용 or pg.sel 자동입력 `npg.Evaluate(`"document.querySelectorAll('{#}query')[0].value='AHK'`") `npg.Evaluate(`"document.querySelectorAll('{#}search_btn')[0].click()`") `nPg.WaitForLoad() `n`;pg.Evaluate(`"document.querySelectorAll('X')[0].value = `" Chrome.Jxon_Dump(Var)) `nMsgBox, 확인 시 자동 종료됩니다. `nPg.Call(`"Browser.close`") `nPg.Disconnect() `n
}

web_auto()
{
	SendInput, pwb:=WBGet() `; 웹포인터 {!}B `npwb.Navigate(`"www.naver.com`") `;주소열기 `nwhile pwb.busy or pwb.ReadyState <>4 `nSleep, 100 `n`;ClickLink(pwb,Text:="Text") `;문자링크 클릭 `n`;pwb.document.getElementByID("XX").click() `; 클릭 `n`;pwb.document.getElementByID("XX").Value :="XX" `;ID로 값입력 `n`;pwb.document.getElementsByClassName("XX")[0].Value :="XX" `; 클래스로 값입력, Name, TagName `n
}

ymd(var_date){
StringReplace, var,var_date, -,,All
return var
}

; flist;  핫스트링  File_List("c:\") 파일명만 / File_List("c:\",1) 확장자포함, 2 Full
File_List(ByRef Dir, ByRef ext=0){  ; File_List("경로명"[,01]) ; List_Arr[1]
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
			List_Arr.Push(A_LoopFileName) ; 확장자 포함
		}
		else
		{
			List_Arr.Push(A_LoopFileFullPath)
		}
	}
	return List_Arr
}


; ■ 네이버 로그인
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


begin_ahk()  ; 초기세팅
{
	SendInput, {#}Singleinstance Force `; 미종료 상태 새로켜짐 `n{#}NoEnv `; 환경변수 무시 `nSendMode Input `; 속도, 안전성 추천 `nSetWorkingDir `%A_ScriptDir`%  `; 현재 작업폴더 기준 `nCoordMode, Pixel, Screen    `; 전체화면  이미지 기준 `nCoordMode, Mouse, Screen `; 전체화면 마우스 `nSetFormat,FLOAT,0.0  `; 소숫점 6자리 예방(아래줄과 함께) `nvar{+}{=}0 `n
}

Auto()
{
	SendInput, `; 1. 좌표   클릭 :                   클릭위치 이동 →  ALT{+}1 `n`; 2. 이미지 클릭: 그림캡쳐→클릭위치 이동 →  ALT{+}2 `n`; 3. 작업창 활성화 : 작업할 창 클릭 →  ALT{+}3 `n`; 4.    `"    로딩대기 :        `"        클릭 →  ALT{+}4 `n`; 5.    `"    이동좌상 :        `"        클릭 →  ALT{+}5 `n`; 6. 픽셀 클릭 : {^}{+}q(픽셀값 얻기) → {^}{+}w(클릭 위치) `n`; 7. 상대 클릭 : {^}q(기존 좌표위치) → {^}w(클릭 위치) `n
}