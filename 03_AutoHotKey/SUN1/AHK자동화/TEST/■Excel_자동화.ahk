{  ; ■ 기본설정 ■  F5키 → GUI창 Show : 자동화 가능 ※ 이미지<픽셀<단축키 순
	#Singleinstance Force
	#NoEnv
	SendMode Input
	SetTitleMatchMode, 2  ; 일부만
	SetWorkingDir %A_ScriptDir%
	SetFormat,FLOAT,0.0  ; 엑셀 정수로, 소숫점X(1.000000)
	var+=0
	Gui, Add, Button, x10 y5 w60, 샘플열기   ; 1행1열
	Gui, Add, Button, y+5 w60, 웹폼입력
	Gui, Add, Button, x75 y5 w60, 메시지창   ; 1행2열
	Gui, Add, Button, y+5 w60, 메모쓰기
	Gui, Add, Button, x140 y5 w60, 엑셀한글 ; 1행3열
	Gui, Add, Button, y+5 w60, 엑셀반복
	Gui, Add, Edit, x20 y65 w25 h17 +Center v횟수,1 ; 반복 횟수
	Gui, Add, Text, x+3 y67 w10 h17, 회
	Gui, Add, Button, x75 y60 w60, 편집
	Gui, Add, Button, x+5 w60, 저장로드
	Gui, +Alwaysontop
	Gui, Show, x1480 y0 w215 h93, Excel활용
	return
	
	GuiClose:     ; GUI창 닫으면 (X 클릭) 종료
	ExitApp
	
	^e::
	Button편집:      ; gui창 "갱신/중지" 버튼
	Edit
	return
	
	^r::
	Button저장로드:      ; gui창 "갱신/중지" 버튼
	Edit
	Sleep, 100
	Send, {CtrlDown}s{CtrlUp} ; 저장
	Sleep, 100
	Reload  ; 다시 로드
	return
}


Button샘플열기:  ; 엑셀, 한글, web  ========
{   ; ■ 엑셀, 한글, 웹 샘플  열기  %A_ScriptDir%\DB
	Run, C:\Program Files\Internet Explorer\iexplore.exe %A_ScriptDir%\TEST_WEB.html
	IfWinNotExist, TEST_HWP누름틀.hwp
		Run, %A_ScriptDir%\TEST_HWP누름틀.hwp
	IfWinExist, TEST_HWP누름틀.hwp
		WinActivate, TEST_HWP누름틀.hwp
	IfWinNotExist, TEST_HWP.hwp
		Run, %A_ScriptDir%\TEST_HWP.hwp
	IfWinExist, TEST_HWP.hwp
		WinActivate, TEST_HWP.hwp
	IfWinNotExist, TEST_EXCEL  ; ■ 엑셀 불러오기
		Run, %A_ScriptDir%\TEST_EXCEL.xlsm
	IfWinExist, TEST_EXCEL
		WinActivate, TEST_EXCEL
	WinWaitActive, TEST_EXCEL
	Sleep, 500
	Reload   ; 재로딩,  XL함수 로딩
}
return

; ■ WebPage 웹페이지 관리 =============
Button웹폼입력:  ; 웹페이지 입력
{
	Gui, Submit, NoHide ; GUI값 읽기
	ex := ComObjActive("Excel.Application") ; 열려있는 엑셀 ex
	ex.sheets("DB").select      ; 작업시트 선택
	WinActivate, TEST_WEB.html ;창활성화
	Sleep, 200
	loop, %횟수% { ; ■ 횟수 변수
		A_endRow:=EndRows(ex,1)  ; A열  끝행(작업기준)
		pwb := WBGet() ; ■ 포인터 선언/ IWB2
		pwb.document.getElementByID("fname").Value:=ex.Range("C"A_endRow).value ; ■ 계약명
		pwb.document.getElementByID("uname").Value:=ex.Range("D"A_endRow).value ; ■ 업체명
		pwb.document.getElementByID("sumname").Value:=ex.Range("E"A_endRow).value ; ■ 계약금액
		pwb.document.getElementByID("datename").Value:=ex.Range("F"A_endRow).value ; ■ 일시
		pwb.document.getElementByID("partname").Value:=ex.Range("G"A_endRow).value ; ■ 감독부서
		if ex.range("B"A_endRow).value = "공사"                         ; ■ 공사구분
			pwb.document.getElementByID("male").checked :=1
		if ex.range("B"A_endRow).value = "용역"
			pwb.document.getElementByID("female").checked :=1
		if ex.range("B"A_endRow).value = "물품"
			pwb.document.getElementByID("other").checked :=1
		pwb.document.getElementByID("rhksso").checked :=1   ; ■ 관내구분
		Sleep, 700
		pwb.document.GetElementsByTagName("INPUT")[10].click()
		Sleep, 300
		ex.Range("A"A_endRow+1):="=row()-1"
	}
MsgBox,,, IWB2 활용하기 필요시 반복횟수 지정 가능,1.5
}
return


Button메시지창:  ; ■ 메시지창 입력  =======
{   ; ■ DB 셀범위(배열) 선언 후 메시지창으로 내용 보기
	WinActivate,  ahk_exe EXCEL.EXE ;창 활성화
	ex := ComObjActive("Excel.Application") ; 열려있는 엑셀 ex로 선언
	ex.sheets("DB").select  ; 작업시트 선택
	Anum:=EndRows(ex,1)  ; A열  끝행(작업기준)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; 작업범위 Arr[행,열]
	data=  ; 초기화
	loop, %Anum% {  ; ■ MsgBox 표시하기
		data.=Arr[A_index, 1] . "/" . Arr[A_index, 2] "/" . Arr[A_index, 3] "/" . Arr[A_index, 4] "/" . Arr[A_index, 5] "/" . Arr[A_index, 6] "/" . Arr[A_index, 7] "`n"
	} 
	MsgBox,,작업 완료, % data "`n ※ DB시트 배열 활용"
}
return

Button메모쓰기: ; ■ 메모장에  셀값 입력 ====
{
	WinActivate, ahk_exe EXCEL.EXE ;창 활성화
	ex := ComObjActive("Excel.Application")
	ex.sheets("DB").select    ; 작업시트 선택
	Anum:=EndRows(ex,1)  ; A열  끝행(작업기준)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; 작업범위 Arr[행,열]
	Run, notepad.exe  ; 노트패드 실행
	Sleep, 1000
	SendInput, ■ A열 연번갯수 반복 (Arr활용){enter}
	SendInput, {= 40}{enter}
	Loop, %Anum% {
		Loop_num:=A_Index
		Loop, % Used_col_num(ex) {  ; 사용된 열의 수
			SendInput, % Arr[Loop_num, A_Index] " "
		}
		SendInput, {enter}
	}
	MsgBox, 노트패드 입력하기 종료 `! `n`n 확인을 누르면 자동 종료
	WinClose, 메모장
	WinWaitActive, 메모장
	Send, n
	return
}


; ■■■ 엑셀_한글 연계는  다양한 방법이 있음

Button엑셀한글:
{
	; ■ 배열 + 문자검색 이동 후 입력
	WinActivate,  TEST_EXCEL
	ex := ComObjActive("Excel.Application") ; 열린엑셀 ex 선언
	ex.sheets("DB").select     ; 작업시트 선택
	A_num:=EndRows(ex,1)  ; A열  끝행 (작업 기준행)
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; Arr[행,열] 배열선언
	WinActivate,  TEST_HWP.hwp ; ■ HWP  활성화
	Sleep, 500
	SendInput, ^{PGUP} ; 문서 처음으로 이동
	Sleep, 300
	검색이동("문서번호")     ; ## 문서번호 검색이동
	Sleep, 200
	SendInput, !{right 2}^{a}
	Sleep, 100
	input_value(Arr[A_num,6]) ;~ var:=Arr[A갯수,6] ; clip_copy(var)
	Sleep, 100
	검색이동("제    목")          ; ## 제목 검색이동
	Sleep, 100
	SendInput, !{right}^{a}
	Sleep, 100
	input_value(Arr[A_num,3])
	Sleep, 100
	검색이동("1. 소")  ; ## 소요금액 검색이동
	Sleep, 100
	SendInput, !{right}^{a}
	Sleep, 100
	dd := won(Arr[A_num,5])  ; 천원표시(,)
	Sleep, 100
	SendInput, 금%dd%원
	Sleep, 100
	SendInput, ^{PGUP}
	ex.sheets("DB").cells(A_num+1, 1) := "=row()-1"
	MsgBox,,,작업완료  ※ 배열 `n`nA열 끝행 기준
	
}
return


Button엑셀반복:   ; ■  누름틀 부분활용 : 다소 안정적 ■■■ ===
{
	Gui, Submit, NoHide       ; GUI 읽기(반복 횟수)
	WinActivate,  TEST_EXCEL	
	Sleep, 300
	ex := ComObjActive("Excel.Application") ; 열린엑셀 제어
	ex.sheets("DB").select      ; 작업시트 선택
	Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; Arr[행,열] 배열
	loop, %횟수%  
	{
		WinActivate, TEST_HWP누름틀.hwp
		Sleep, 500
		Send, ^{PGUP}
		Sleep, 200
		Send, !g!r{tab}누름틀{enter} ; 왜 안되지?
		Sleep, 200
		send, {right}{ShiftDown}{End}{Left}{ShiftUp}
		Sleep, 100
		SendInput, % ex.Range("F" . EndRows(ex,1)).value  ; ■ 일자 입력 
		Sleep, 100
		SendInput, {right}
		Sleep, 200
		Send, !g!r{tab}누름틀{enter}{right}{ShiftDown}{End}{Left}{ShiftUp}
		Sleep, 100
		Clipboard:=ex.Range("C" . EndRows(ex,1)).value
		Sleep, 200
		SendInput, {CtrlDown}v{CtrlUp}      ;  ■ 제목 입력
		Sleep, 100
		SendInput, {Right} 
		Sleep, 100
		Send, !g!r{tab}누름틀{enter}{right}{ShiftDown}{End}{Left}{ShiftUp}
		dd := won(ex.Range("E" EndRows(ex,1)).value)  ; 천원표시(,)
		Sleep, 100
		SendInput, 금%dd%원  ; ■ 소요금액 
		Sleep, 100
		SendInput,^{PGUP}
		Sleep, 100
		ex.Range("A" EndRows(ex,1) +1):="=ROW()-1" ; A끝행+1
	}
	MsgBox,,,한/글 누름틀(^KE) → 안정적, 1.5
}
return
	


; First_Row(ex), Last_Row(ex), First_Col(ex), Last_Col(ex), EndRows(ex,1)
 { ; Excel Function
	First_Row(xlname)
	{  ; 첫행수 : First_Row(객체명)
	   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
	}

	Last_Row(xlname)
	{  ; 마지막 행수 : Last_Row(객체명)
		return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
	}
	
	Used_Row(xlname)
	{  ; Used행수 : Used_Row(객체명)
		return xlname.ActiveSheet.UsedRange.Rows.Count
	}
	
	First_Col_Num(xlname)
	{ ;  첫번째 칼럼 number
	   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
	}
	
	Last_Col_Num(xlname)
	{ ;  마지막 칼럼  number
		return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
	}
	
	Used_Col_Num(xlname)
	{ ;  Used 마지막 칼럼  number
		return xlname.ActiveSheet.UsedRange.Columns.Count 
	}
	
	First_Col(xlname)
	{  ; 첫번째 칼럼  alpabet
		FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
			Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
	}
	
	; 유효범위(사용된)  : 1이면  처음부터, 0이면 헤더 제외
	Used_Rng(xlname,Header=1)
	{   ; Used_Rng(ex1,Header:=1) ;Use header to include/skip first row
		IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
		IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
	}
	
	Last_Col(xlname)
	{ ; 마지막 칼럼 alpabet : Last_Col(객체명)
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
	
	; 열의 끝행수 → EndRows(ex, 1) ; 1열(A)의 끝행수
	EndRows(ByRef xlname, ByRef col_num=1)
	{
		num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; 사용범위 끝행수=endRow
		Loop 
		{
			if (xlname.Cells(num - A_index, col_num).value <> "")
			{
				end_numbers := num - A_index  ; 마지막 Row 갯수
				break
			}
		}
		return end_numbers
	}
}


{ ; ■ Pointer to Open IE Window ■
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
	{ ; ■ iwb2 문자 링크 클릭
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
}  ; ■ Pointer to Open IE Window ■

; 작업창이 나타날(로딩) 때까지 대기
 작업창대기(ByRef Title_name)
 {
	WinWait, %Title_name%
	WinWaitActive, %Title_name%
	loop	
	{
		IfWinExist, %Title_name% 
		{
			WinActivate, %Title_name%
			Sleep, 200  ; 추가 안정성 향상
			break
		}
		Sleep, 100
	}
}

; ■ Ctrl+F로  문자검색 이동만  / 기존 사용
검색이동(ByRef var)
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

; ■ var 값  클립보드 복사+붙어넣기  / 한영혼합 입력시 오류 예방
input_value(ByRef var)
{
	Clipboard =         ; 클립보드 비우기
	Clipboard := var  ; 클립보드에 변수var 값 넣기
	ClipWait, 2           ; 클립보드에 저장될 때까지 대기
	SendInput, {Ctrl Down}v{Ctrl Up}  ; Ctrl+V  붙여넣기
}

; ■ 천단위 표시 : -12,345  ; ■ won Format_Number
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
