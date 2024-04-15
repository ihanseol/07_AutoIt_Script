{   ; ■ GUI Section  ※ 맨땅에 헤딩아재 참고
	#Singleinstance Force
	SendMode Input
	SetWorkingDir %A_ScriptDir% ; 현재 작업폴더
	Gui Add, Edit, x10 y10 w320 h22 vFolder, %A_ScriptDir%\DB ;폴더
	Gui Add, Button, x+10 w60 h22, 폴더선택
	Gui Add, Edit, x10 y45 w320 h22 vResult, %A_ScriptDir%\Excel_Merge.xlsx
	Gui Add, Button, x+10 w60 h22, 저장파일
	Gui Add, Text, x10 y75 w390 h2 +0x10 ; line
	Gui Add, Button, x10 w55 h25, 엑셀병합
	Gui Add, Button, x+10 w55 h25 vBtn_name, 시트취합
	Gui Add, Text, x+10 w10 h25, ▒▒
	Gui Add, Button, x+10 w55 h25, 워드취합
	Gui Add, Button, x+10 w55 h25, 한글취합
	Gui Add, Text, x+10 w10 h25, ▒▒
	Gui Add, Button, x+10 w45 h25, 초기화
	Gui Add, Button,x+10 w33 h25, 편집
	Gui, +Alwaysontop
	Gui Show, x1500 y20 w410 h120, Excel_Word_Hwp
	Return
}


{  ;■■■ GUI 설정 관련 ■■■
	GuiClose:
	ExitApp

	Button폴더선택: ; ■ "폴더선택" 버튼 클릭시 실행
	{
		Gui, Submit, nohide
		FileSelectFolder, folder,,3 ; 폴더선택  3
		if Folder = 
			MsgBox, 폴더가 선택되지 않았습니다.
		else
			GuiControl, , Folder, %folder%  ; 폴더명을 Folder 변수로
	}
	return ; 명령 종료시

	Button저장파일:
	{
		Gui, Submit, nohide
		FileSelectFile, filename,3,%A_ScriptDir% , 엑셀파일 선택하세요, *.xlsx
		if filename = 
			MsgBox, 파일이 선택되지 않았습니다.
		else
			GuiControl,, Result, %filename%  ; 파일명 Result 변수에 UPdate
	}
	return

	^e::
	Button편집:
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


Button초기화:
{  ; ■ 기존 자료 삭제
	Gui, Submit, nohide
	IfWinExist, Excel_Merge    ; Title창 활성화
		ex := ComObjActive("Excel.Application")  ; 열려있는엑셀 제어시
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; 새엑셀 : ex.Workbooks.Add 
		ex.Workbooks.Open(Result)  ; 저장파일 열기 FileSelectFile, path
	}	
	ex.Visible:=True
	Arr:=["WORD","HWP","EXCEL"]   ; 배열 초기값 설정
	loop, % Arr.length(){
		ex.sheets(Arr[A_Index]).select   ; 배열  A_index 시트 선택
		ex.cells(1,1).select ; A1셀 선택(기존 선택범위 초기화)
		if (ex.range("A2").value != "")    ; A2 셀값이 있다면  ;ex.ActiveSheet.UsedRange.clear
			ex.ActiveSheet.Range("2:1000").delete ; 2열부터 1000열 삭제
		ex.Range("A1").select
	}
	WinActivate, Excel_Merge
	ex.ActiveWorkbook.Save() ; 저장
	MsgBox,,, 초기화 완료, 1
	Reload	
}  ; End  초기화
return


Button엑셀병합:   ; ■ 폴더내 엑셀 취합
{
	Gui, Submit, nohide
	;■ 01취합할 엑셀 열기 : 열려있는지 유무를 확인 후 ex선언
	IfWinExist, Excel_Merge   ; Title창 존재하면 활성화
		ex := ComObjActive("Excel.Application")  ; ex선언
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; ex 선언
		ex.Workbooks.Open(Result)  ; 파일 열기 ; FileSelectFile, path
	}
	ex.Visible:=True ; 보이게
	WinActivate, Excel_Merge ; 창활성화
	ex.sheets("EXCEL").select
	ex.Range("A1").select
	; ◆ 02 새엑셀(ex1) 생성 및 폴더내 파일 순차실행(GUI 값)
	;~ Folder:= A_ScriptDir . "\DB\*.xlsx" ; 폴더 및 화일선택 / 수동선택시
	;~ FileSelectFolder, folder,,3 ; 폴더 선택	;FileSelectFolder, folder,%A_ScriptDir%, 3
	ex1:=ComObjCreate("Excel.Application") ; ex1 생성(선언)
	loop, %folder%\*.xlsx ; 또는  c:\*.xlsx 처럼 직접 입력
	{
		ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ;파일열기
		ex1.Visible:=False ; 안보이게 
		ex1.sheets(1).select  ; 1번째 시트 선택 ★★
		ex1.cells(1,1).select  ; A1셀 선택
		if (A_index = 1)   ; ◆유효범위(셀값 )복사 / 1번째는 헤더포함
			Used_Rng(ex1, 1).Copy ; 헤더 1유 0무 + 범위 복사
		else
			Used_Rng(ex1, 0).Copy ; 헤더 X 내용만 복사
		ex.Range("A" . Last_Row(ex) +1).Select ; A열 끝줄 + 1 선택
		ex.ActiveSheet.Paste ; 붙여넣기(^v)
		ex.cells(1,1).select
		ex1.Application.CutCopyMode:=false ; 복사모드 해제 
		ex1.Workbooks.Close ; 문서닫기(ex1실행중)
	}
	ex1.Quit ; ex1 엑셀 종료
	ex.cells(1,1).select
	ex.Visible:=True
	ex=  ; 초기화
	ex1=
	MsgBox, 폴더내 엑셀파일 병합 완료 `n`n 1번째 시트만 병합 ★★ 수정시 선택 가능
}
return


Button시트취합:   ; ■ 폴더 내 엑셀파일의 모든 시트 취합
{
	Gui, Submit, nohide
	GuiControl,,Btn_name,실행중  ; 시트취합 버튼명  실행중  표시
	ex:=ComObjCreate("Excel.Application") ; ex 엑셀생성(선언)
	ex.Workbooks.Add ; 문서 생성
	ex.Visible:=true
	FileArr:=[] ; ■ 02 폴더내 파일명만 배열 선언
	loop, %folder%\*.xlsx 
	{
		StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
		FileArr.push(FileNameNoExt)
	}
	; ■ 03 폴더 내 순차실행 : C:\Users\USER\Downloads\samples
	ex1:=ComObjCreate("Excel.Application") ; ex1 엑셀 생성
	num:=1  ; 파일리스트와 연계
	loop, %folder%\*.xlsx 
	{
		ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ; 열기
		ex1.Visible:=False
		if ((num=1) and (ex1.sheets.count = 1)) 
		{  ; ■ 1회반복, 시트 1이면
			ex1.sheets(num).cells.copy
			ex.ActiveSheet.name:=FileArr[num]
			ex.Activesheet.paste
			ex.Activecell.cells(1,1).select
			ex1.Application.CutCopyMode:=false
		}
		else if ((num =1) and (ex1.sheets.count != 1)) 
		{  ; ■1회, 시트 2개 이상이면
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
		{  ; ■■시트가 2개 이상
			loop, % ex1.sheets.count 
			{
				ex.Sheets.Add(ComObjMissing(), ex.Sheets(ex.Sheets.Count)) ;시트+
				ex.ActiveSheet.name:=FileArr[num]  "_" ex1.sheets(A_index).name "_" A_Index
				ex1.sheets(A_Index).cells.copy
				ex.Activecell.select
				ex.Activesheet.paste
				ex1.Application.CutCopyMode:=false
			}
		}
		ex.Activecell.cells(1,1).select
		ex1.Workbooks.Close
		num++  ; 1씩 증가
	}
	ex1.Quit
	
	; ■ 02 시트병합 하기
	ex.sheets(1).select
	ex.sheets.add
	ex.Activesheet.name:="병합"
	;◆02 시트 취합
	loop, % ex.Sheets.Count ; 시트 갯수 반복
	{
		ex.sheets(A_index).select
		if (ex.ActiveSheet.name <>"병합")
		{
			ex.Range("A1").select
			if (A_index = 2) ;1회(병합), 2회 반복이면	; ◆ 03 유효범위 복사
				Used_Rng(ex, 1).Copy ;자료범위 복사(1 헤더O)
			else
				Used_Rng(ex, 0).Copy ;자료범위 복사(0 헤더X)
			ex.sheets("병합").select
			ex.Range("A" . Last_Row(ex)+1).select ; 복사위치(끝행+1)
			ex.ActiveSheet.paste
			ex.Application.CutCopyMode:=False
			ex.cells(1,1).select
		}
	}
	ex.cells(1,1).select
	ex=
	ex1=	;~ ex.ActiveSheet.Cells.Columns.AutoFit ; 열너비 자동 조정
	GuiControl,,Btn_name,시트취합
	MsgBox, 시트취합 완료  엑셀의 파워쿼리 권장
}
return


Button워드취합:     ; ■ Word - Excel 연계 ====
{
	Gui, Submit, nohide
	; ■ 01폴더 및 취합엑셀 경로정의 ------------------------------
	;~ Folder:= A_ScriptDir . "\DB\*.docx" ; 폴더 및 word화일
	;~ expath:= A_WorkingDir . "\excel_word.xlsx" ; 대상파일
	; ■ 02취합할 엑셀열기(sheet select) -----------------------------
	IfWinExist, Excel_Merge  ; Title창 활성화
		ex := ComObjActive("Excel.Application")  ; 열려있는엑셀 ex
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")
		ex.Workbooks.Open(Result)  ; 파일 열기 FileSelectFile, path
	}
	ex.Visible:=True
	ex.sheets("WORD").select ; 취합할 시트 선택
	ex.cells(1,1).select
	Loop, %Folder%\*.docx  ; ■ word 문서 열기(순환)
	{
		run, %A_LoopFileFullPath%  ; 파일전체경로/파일명 실행
		WinWait, ahk_exe WINWORD.EXE
		WinWaitActive, ahk_exe WINWORD.EXE
		Sleep, 500
		word_data_Add()  ; ■ 함수 : Word 열고, 배열 저장
		WinClose, ahk_exe WINWORD.EXE  ; ■ Word 종료
		row := ex.Sheets("WORD").UsedRange.Rows.Count + 1 ; 끝행+1
		ex.Cells(row,1).Formula := "=row() -1" ; ■ 변수값 엑셀 저장
		Loop, 13 {  ; 13번 반복
			ex.Cells(row,1+A_index).value :=Arr[A_index] ; Arr배열값
		}
		ex.ActiveWorkbook.Save()
		sleep, 200
	} ; End loop
	MsgBox,,, 워드 취합 완료, 2
	Reload
}
return


word_data_Add() ; ■ 함수 : 위드 열어 원하는 값 배열로 저장
{
	global  Arr ; 전역변수 선언 ↔ 지역변수(함수 내에서만 사용)
	Arr := []  ; 배열 선언(초기화) ★
	WinActivate, ahk_exe WINWORD.EXE ; 창활성화
	Sleep, 500
	SendInput, {CtrlDown}{PgUp}{CtrlUp} ; 맨처음 이동
	Sleep, 300
	Send, {Tab 2} ; 이름칸 이동 → 내용 자동블록 선택
	; ■ 클립보드 복사 후 배열 저장 : Arr.Push("값")
	;  - 배열 첫번째 저장 Arr[1] := 값 or Arr.Push("값") / 갯수 Arr.lenght()
	Arr.Push(Wclip_copy()) ; Arr 배열에 이름값 저장(Push) ← Wclip_copy() 함수는 블록내용을 복사하여  클립보드에 저장 ※ 한영시 깨짐 방지 등
	Send, {Tab 2} ; 생년월일 칸
	Arr.Push(Wclip_copy()) ; Arr 배열 추가 (생년월일) 
	Send, {Tab 4} ; 성별 칸
	Arr.Push(Wclip_copy()) ; Arr 배열추가(성별)
	Send, {Tab 2}  ; 주소 칸
	addr := StrReplace(Wclip_copy(), "`r`n") ; 엔터(`n or `r) 제거 	
	addr := Trim(addr)  ; Trim(String,Chars]) 공백 or 특정문자 제거
	Arr.Push(addr)
	Send, {Tab 2} ; 휴대폰 칸
	Arr.Push(Wclip_copy())
	Send, {Tab 4} ; email 칸
	Arr.Push(Wclip_copy())
	Send, {Tab 2} ; 회사 칸
	buso := StrReplace(Wclip_copy(),"(회사명)")  ; (회사명)  문자열  제거
	buso := StrReplace(buso, "`r`n") ; 
	buso := Trim(buso) ; 좌우 공백(빈칸) 제거
	Arr.Push(buso)
	Sleep, 100
	Send, {Tab 2} ; fax 칸
	Arr.Push(Wclip_copy())
	Send, {Tab 2} ; 회사주소 칸
	busoaddr := StrReplace(Wclip_copy(), "(주소)")  ; (주소) X
	busoaddr := StrReplace(busoaddr, "`r`n")
	busoaddr := Trim(busoaddr)
	Arr.Push(busoaddr)
	Sleep, 100
	Send, {Tab 4} ; 입사일 칸
	cdate :=StrReplace(Wclip_copy(),".","-")
	Arr.Push(cdate)
	Send, {Tab} ; 팀 칸
	Arr.Push(Wclip_copy())
	Send, {Tab} ;직급 칸
	Arr.Push(Wclip_copy())
	Send, {Tab} ; 서약~ 칸
	sstart := Instr(Wclip_copy(),"서약합니다.") +7 ; 서약합니다+7 위치
	ssend := Instr(Clipboard, "신청인" ) - 1 ; 신청인 - 1 위치
	length := (ssend - sstart) 
	sdate :=SubStr(Clipboard,sstart,length)
	sdate :=StrReplace(sdate,"`r" ) ; "`r`n" ; 동시 사용X
	sdate :=StrReplace(sdate,"`n" )
	sdate :=StrReplace(sdate, "년" , "-" ) ; 년은 -로 변경
	sdate :=StrReplace(sdate,"월", "-" )
	sdate :=StrReplace(sdate,"일" ) ; 일  
	sdate :=Trim(sdate) ; 빈칸 제거
	Sleep, 100
	Arr.Push(sdate) ; 1이름, 2생일, 3성별, 4주소, 5HP, 6email, 7회사, 8팩스, 9회사주소, 10입사일, 11팀, 12직급, 13날짜
	Sleep, 100
}

Wclip_copy() ;  Ctrl+c 로 클립보드에 저장
{
	Clipboard=
	Sendinput, {CtrlDown}c{CtrlUp} ; 복사 ^c
	ClipWait, 2
	Sleep, 100
	return Clipboard
}

;============================

Button한글취합:    ; ■ HWP - Excel 연계 ==
{
	Gui, Submit, nohide
	; ■ 01취합할 엑셀열기(sheet select)- - - - 
	IfWinExist, Excel_Merge  ; Title창 활성화
		ex := ComObjActive("Excel.Application")
	IfWinNotExist, Excel_Merge
	{
		ex := ComObjCreate("Excel.Application")  ; 새엑셀
		ex.Workbooks.Open(Result)  ; 파일 열기 FileSelectFile, path
	}	
	ex.Visible:=True ;~ ex.Visible:=false
	ex.sheets("HWP").select   ; 취합할 시트 선택
	ex.range("A1").select
	; ■ 02 한/글 순차적으로 열고, 자료 배열 저장 후 엑셀에 쓰기
	Loop, %Folder%\*.hwp  	; ■ HWP 문서 열기(순환) - - - - - -
	{
		Arr:=[]  ; 배열 초기값 설정
		row := ex.ActiveWorkbook.Sheets("hwp").UsedRange.Rows.Count + 1 ; 끝행+1
		run, %A_LoopFileFullPath%   ;  ■ 한/글 실행(파일전체경로+파일명)
		WinWait, ahk_exe Hwp.exe
		WinWaitActive, ahk_exe Hwp.exe
		Sleep, 1000
		hwp_data_Arr()  ; ■ 함수 : 한/글 열고, Arr 배열저장
		loop, % Arr.Length() { ; Arr 배열값 엑셀에 쓰기
			ex.Cells(row, A_Index+1).value := Arr[ A_index ]
			ex.Cells(row,1).Formula := "=row() -1"  ; ■ A열 셀값 저장
		}
		WinClose, ahk_exe Hwp.exe  ; ■ 한/글 닫기
		ex.ActiveWorkbook.Save()
	} ; end loop
	MsgBox,,, 문서 취합 작업이  완료되었습니다., 2
	Reload
}
return

hwp_data_Arr() ; ■ Function ;한/글 열고, 변수저장, 한/글 닫기 ■
{
	global
	WinActivate, ahk_exe Hwp.exe  ; 창활성화
	Sleep, 500
	SendInput, {CtrlDown}{PgUp}{CtrlUp} ; 맨처음 이동
	Sleep, 500
	SendInput, {Down} ;성명
	Sleep, 500
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 1성명
	Send, !{Right}!{Right}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 2생년월일
	SendInput, {Down}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 3주소
	Send, !{Left}{Down}!{Right}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 4HP
	SendInput, !{Right 2}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 5직위
	SendInput, {Down}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 / 6이메일
	SendInput, {Down 2}
	Arr.Push(Hclip_copy()) ; 배열 Arr 에 추가 /7참고
}

; 복사값 변수 설정
Hclip_copy(){  ; ^a, ^c, Esc
	Clipboard =     ; 클립보드 비우기
	Send, {CtrlDown}a{CtrlUp} ; 선택 ^A
	Sleep, 100
	Send, {CtrlDown}c{CtrlUp} ; 선택 ^c
	ClipWait, 2
	Send, {Esc}
	Sleep, 200
	return Clipboard
}


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
