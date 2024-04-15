■ AutoHotKey ■ ^(Ctrl)  /  !(Alt)  / +(Shift)  / #(Win로고키)
※ Msgbox, Click, Send, Sleep, Run,  WinActivate, WinWait, WinWaitActive 등

♣ 초기 설정
#Singleinstance Force ; 미종료상태 새로 켜기
#NoEnv ; 환경변수 무시, 효율↑
SendMode Input ; 속도, 안전성 추천
SetWorkingDir %A_ScriptDir% ; 현재 작업폴더 기준 
^r::Reload ; 핫키는 ^t:: ~명령어~ Retrun  / Button버튼명: ~ 명령어 ~ Return

♣ 참고사항
 1. 작업할 창을 활성화한 후 명령 실행  ※ !3(Alt+3) 작업창 활성화 명령문 입력

 2. Run 실행 또는 클릭 후 Win창이나, 웹페이지 로딩 등 소요시간(sleep) 조절
  - sleep 주거나 또는 Win명령, 이미지서치 등을 활용하여 다음 작업 계속

 3. 좌표 클릭 오류 시 : 작업창 활성화(!3) 후 작업, 또는 창위치 변할 땐 좌상단 고정(!5) 

 4. 이미지 클릭 오류 시 : 선명한 이미지로 대체, 캡쳐 범위는 최소화, 픽셀클릭(^+Q,^+W)
    ※ 오류: 이미지 클릭(화면 및 해상도 변경 시) , 좌표 클릭(화면 확대, 창위치 변동시)

 5. Element > Win명령 > 단축키 > 픽셀 > 이미지 > 좌표 순으로 정확도 높음

 6. 엑셀 빈줄로 시작할 경우 끝행수 오류 발생 시 :  ex_open; (핫스트링 확인)
    - 첫행 First_Row(ex)     / 끝행 Last_Row(ex) / 첫열 First_Col(ex) / 끝열 Last_Col(ex)
      A끝행 EndRows(ex,2) / 끝행 endRow ?                               / 끝열 endCol ?
      ex.Range("a1").End(-4121).Select ; A끝행 xlDown(-4121), xlup(-4162) ★
      ex.Range("a1").End(-4121).offset(1,0).value := "=ROW()-1" ; 끝행 + 1 셀값 입력

      ※ 1열의 끝행수 + 1
      NextRow := ex.ActiveSheet.Cells(ex.Rows.Count, 1).End(-4162).Row + 1
      NextRow := ex.Cells(ex.Rows.Count, 1).End(-4162).Row + 1 ; -4126 xlup
      MsgBox, % ex.ActiveSheet.Cells(ex.Rows.Count, 1).End(-4162).Row + 1 ; xlup

    ex := ComobjActive("Excel.application")
    ex.run("매크로이름")

 7. 파일리스트 배열 활용 : flist; 
  File_List("c:\*.*",0) ; 0기본(파일명만), 1(확장자 포함), 2(전체경로 포함)
  MsgBox, % List_Arr.length() "개 / 1번값: " List_Arr[1] 

input_value(ex.range("A3").value)   ; ■ 셀값 클립보드 입력 ※ 한영 혼용자료 깨짐 방지
StringReplace, var,% ex.Activecell.value, -,,All  ; ■ 날짜(yyyy-mm-dd)에서 "-" 제거

★ 웹제어(IE), 크롬(pg.sel), 맞춤법 검사, 정해진 시간, 
    웹클릭, Python 함수, OCR 문자, Notepad++ Autohotkey 개발환경

; 관리자 권한 실행(처음) ?
if (not A_IsAdmin) { 
    Run *RunAs "%A_ScriptFullPath%" 
    ExitApp 
} 


;■ IE제어 - 인터넷익스플로러 제어하기
pwb := ComObjCreate("InternetExplorer.Application") ; IE생성(열기) pwb
; pwb:=WBGet() ; 열려있는 IE 제어
pwb.Navigate("http://www.naver.com") ; 주소 이동
pwb.Visible := true ; 보이기
while pwb.busy or pwb.ReadyState <>4 
    Sleep, 100 ; info = % pwb.document.documentElement.outerHTM  ; ■ 웹정보
; ; ■ 요소클릭 : 클래스+innerText 활용
btn := pwb.document.getElementsByClassName("nav") ; ClassName, Name, TagName
loop % btn.length {
    if (btn[A_index-1].innerText = "뉴스")	{  ; 조건만족 클래스 클릭
        btn[A_Index-1].click()
        break
    }
}
;ClickLink(pwb,Text:="Text") ;문자링크 클릭 

;■ 인터넷 익스플로러(IE제어) ■ ■ ■ ■ ■ 
wb := ComObjCreate("InternetExplorer.Application") ; IE생성(열기) wb
wb.Visible := True ; 보이게
wb.Navigate("http://www.naver.com") ; ExURL 사이트로 이동
while wb.busy or wb.ReadyState != 4 
    Sleep, 100
wb.document.getElementById("query").value:="AHK"
wb.document.getElementById("search_btn").click()
while wb.busy or wb.ReadyState != 4 
    Sleep, 100 ; info = % pwb.document.documentElement.outerHTM  ; ■ 웹정보
Sleep, 500
num := 0  ; 변수 선언
loop, 4 {
    var:=wb.document.getElementsByClassName("api_txt_lines total_tit _cross_trigger")[num].innertext
    Msgbox,,, % var, 1
    num++
}
Sleep, 1000
wb.quit()


=============================================

1. 오토핫키란 : 공식문서 자습서, 자동화 안내문.hwp , 유튜브 참고

2. 편집기별 AHK 파일 열기 → 자동화 ★★★
  가. Scite4 : AHK.ahk → 우클릭 → Edit Script  /  F5(실행 Run Script)  
  나. Notepad++ :  AHK.ahk → 우클릭 → Edit with Notepad++ 
        / F5("$(FULL_CURRENT_PATH)") 단축키 저장
  다. vs Code : AutoHotKey Plus 설치 후  Ctrl+F9 실행

3. 코드 실행법 : 테스트 중심으로
  가. 코드입력 :  예) Msgbox, 문자 연습
  나. 저장로드 :  저장(Ctrl+s) + F5 또는  저장로드(Ctrl+R)  ※ 수정후 재로딩 필요
  다. GUI창 List_Box - '연습1' 선택 후  실행 버튼

4. 코드 자동입력
  가.  Alt+1 : 좌   표 클릭 - 특정 좌표 클릭 명령 (자동입력)
  나.  Alt+2 : 이미지 클릭 - 특정 이미지 찾거나 나타날 때까지 대기 후 클릭 시
       * 그림캡쳐 후 실행할 것 → PIC폴더에 저장됨  // 그림이 나타날때까지 대기 후 클릭(기본10초)
  다.  Alt+3 : 창 활성화    - Win창을 가장 앞으로 나오게 함
  라.  Alt+4 : 작업창 대기 - Win창이 열릴때까지 대기, 프로그램 실행될 때까지 대기 등
  마.  Alt+5 : 작업창 이동 - Win창 가장 좌상단 기준 이동,  [폭,높이 생략됨]

5. AutoScriptWriter 자동코드 입력  ★코드 일부 수정 필요
   "..\TEST\MacroRecoder.ahk" : GUI메뉴 → F1 클릭 → 원하는 작업 → F3(Stop)
   F5(Edit) 로 코드수정 : Send 나 MouseClick 명령이 없는 코드 삭제해도 됨.
      예) tt = Internet Explorer ahk_class IEFrame
          WinWait, %tt%
          IfWinNotActive, %tt%,, WinActivate, %tt%
          WinWaitActive, %tt%
          Sleep, 125
  F4(Play) 검증 후 다른이름 저장(*.ahk) 등  - 핫키::  ~  Return 으로 단축키 지정
  종료 : ESC 키

■ 5-1 외부 프로그램 실행 ■ Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID] 
msgbox, %A_WorkingDir% 를 한다면 현재 디렉토리가 보여집니다
Run, Calc        ; 계산기 실행
Run, Notepad  ; 노트패드 실행
Run, C:\Windows\Notepad.exe "C:\My Documents\Test.txt"
Run, C:\My Documents\Test.txt
Run, mspaint   ; 그림판 실행
Run, C:\         ;  탐색창 열기 C드라이브
Run, http://google.com  ;  기본 브라우저로 구글 접속
Run, http://www.naver.com  ; 네이버 실행
Run, Taskmgr   ; 작업관리자 실행
Run, C:\Program Files\Internet Explorer\iexplore.exe "http://www.naver.com" ; 네이버 열기
※ WinClose, 종료할 프로그램



6. ■ 엑셀 활용 =============================

; ■■ 엑셀 시트 순환(차례로)
loop, % ex.sheets.count { ;시트 갯수만큼 반복
    MsgBox,,, % A_index "반복", 1
}

; ■■ 폴더내 파일 순환(차례로) 열고닫기
ex:=ComObjCreate("Excel.Application") ; 새엑셀 ex1 선언
loop, C:\*.xlsx {  ; 파일 순차실행 ,,1(sub)
    ex.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ; 읽기모드 열기
    ex.Visible:=True ; 보기 ↔ False
    ex.Workbooks.Close ; 문서만 닫기
}
ex.Quit ; ex 엑셀종료(문서닫기 포함)

; ■ 예시1) 새로운 엑셀 : 생성→편집→저장→종료
ex := ComObjCreate("Excel.Application") ;새엑셀 ex로 객체선언 
ex.Workbooks.Add ; 새문서 생성
ex.visible:=True ;보이기 ↔ False
ex.Range("A1").value := 12300 ; A1셀에 숫자 입력 
ex.Cells(3,2).value := "문자입력" ; B3셀에 문자 입력
ex.Range("A1:B3").Copy ; A1~C1 셀범위 복사(Clipboard 저장)
MsgBox % Clipboard ; 클립보드값 출력
ex.DisplayAlerts := false ; 저장 시 확인창 X
ex.ActiveWorkbook.Saveas(A_ScriptDir . "\123.xlsx") ; 다름이름 저장
;ex.ActiveWorkbook.Save() ; 같은 이름 저장 시
ex.Quit ; 종료

■ 예시2) 기존 엑셀 열기 + 셀값 출력 ###
ex:=ComObjCreate("Excel.Application")
ex.visible:=True ;보이기↔False ; ex.Workbooks.Add ; 새문서 생성 시
Path = %A_ScriptDir%\TEST\TEST_EXCEL.xlsm ; 경로 및 파일명
; path := A_WorkingDir . "\파일.xls" 
ex.Workbooks.Open(Path) ; path 열기
ex.sheets("DB").select        ; 시트 선택
MsgBox,,, % ex.range("c3").value, 1.5  ; C3셀값 출력

■ 예시3) 이미 열려있는 엑셀(TEST_EXCEL.xlsm) 제어
ex := ComObjActive("Excel.Application") ;열린엑셀 제어
ex.sheets("DB").select     ; ■ 시트명 선택 ■ 
Anum:=AEndRow(ex,1)  ; A열 끝행(작업기준)
Arr:=ex.Range(First_Col(ex) . First_Row(ex) . ":" Last_Col(ex) . Last_Row(ex)).value ; Arr[행,열] 
msgbox % "A끝행 Anum값: " Anum " / 배열값 Arr[Anum,3]: " Arr[Anum,3]
; ex.Range("A" . Anum).value = ex.cells(Anum,1).value = Arr[Anum,1]

■ excel 셀값
   - 셀값입력 : ex.Range("A3").value := 123 or  ex.cells(2,3).value := "값입력"
   - 읽기쓰기 : msgbox, % ex.cells(2,3).value  or send, % ex.cells(2,3).value
   - 끝줄수 및 끝열수
    endRow := ex.ActiveSheet.UsedRange.Rows.Count 
    endCol := ex.ActiveSheet.UsedRange.Columns.Count

ex:=ComObjActive("Excel.Application") ; ■ 열려있는 엑셀 ex로 선언 
ex.Cells.Select  ; ■ 활성화된 시트 전체선택
ex.Selection.Copy ; ■ 전체 복사
ex.ActiveSheet.UsedRange.Copy ; ■ 유효시트 내용만 복사

ex1:=ComObjCreate("Excel.Application") ; ■ 새엑셀 ex1로 선언 
ex1.Workbooks.Add  ; 새문서 생성
ex1.visible:=true
ex1.ActiveSheet.Paste ; 1번째 시트로 붙여넣기
ex1.cells(1,1).select ; 음영해제
ex.Application.CutCopyMode := False ; 복사모드 해제
ex.cells(1,1).select
MsgBox, % ex.Activesheet.range("A:A").ColumnWidth ; 열너비

■ 엑셀 샘플(행열 갯수, 사용된 행열 수) ★★
ex:=ComObjActive("Excel.Application") ;열려있는엑셀 ex로 선언 
ex.sheets("DB").select ;시트명 확인★ 
MsgBox, % "첫행 " First_Row(ex) " / 끝행 " Last_Row(ex) " / 첫열 " First_Col(ex) " / 끝열 " Last_Col(ex) 
MsgBox, % "첫열수 " First_Col_num(ex) " / 끝열수 " Last_Col_num(ex) " / Used행 " Used_Row(ex) " / Used열 " Used_col_num(ex) 

; ■ End(xlDown), End(xlUp) : 특정셀의 끝행, 첫행 찾기
ex := ComObjActive("Excel.Application")
ex.ActiveSheet.Range("B2", ex.Range("B2").End(-4121)).Select ;xlDown(-4121), xlup(-4162)
;ex.ActiveSheet.Range("B2", ex.Range("B" ex.Rows.Count).End(-4162)).Select
;또는 
;ex.Range("b2").End(-4121).Select ;★특정셀의 끝행 선택-4121(xldown),-4162(xlup)


7. 웹페이지 제어 : Internet Explorer  ※ 운영체제 또는 프로그램에 따라 안될 수 있음
  가. web.   → 웹포인터 설정 등
  나. Alt+B  → iWB2 Learner 실행 : 요소를 알 수 있는 도구
      - ㅁ+ 클릭드래그(이동)하여 원하는 곳에 놓으면 → 요소(ID, Name, Tag, Class) 값 확인
  나. 요소 클릭 : 웹에서 특정값 지정 또는 클릭할 때
    - clink.      → ClickLink(pwb,Text:="문자")  ; 하이퍼링크 문자클릭
    - getid.     → pwb.document.getElementByID("X").Value :="X" ; ■ ID값
    - getname. → pwb.document.GetElementsByName("X")[0].Value :="X" ; ■Name값
    - getclass.  → pwb.document.getElementsByClassName("X")[0].Value :="X" ; ■ Class값
    - gettag.    → pwb.document.GetElementsByTagName("X")[0].Value :="X" ; ■ Tag값

  다. Ctrl+왼마우스 클릭 → 다양한 요소, 프레임 등 클릭 지원

;; ■■■ 웹프레임 클릭하기 ■■■ iwb2
WinActivate,  문서관리카드 - Internet Explorer ;창활성화
pwb := WBGet() ;웹포인터 / ALT+B 연계`n
pwb.document.getElementByID("title~100").Value :="테스트하기" ;■ 1 제목
pwb.document.getElementByID("PRJ_BUTTON").click() ;■ 2 과제카드명 손클릭
작업창대기("과제선택 - Internet Explorer") ; 
;;■ 3 과제선택 창에서 단위과제카드 선택 ★★★★★★★★★★

;; ■ 프레임 요소 선택 ■ 과제선택 창에서  TASK창 내 요소클릭 ============================
;; ■ 1번째(^왼클릭) : Advanced - Frames-One Level - Frames has name or ID -get text ■ innerText~ 삭제
;;; pwb.document.parentWindow.frames("XX").document.all.tags("BODY")[0].
;; ■ 2번째 : ^+왼클릭 -> set on page - set ID + click()
;;; pwb.document.getElementByID("XXX").Value :="XXX"

;;■최종 : pwb.document.parentWindow.frames("TASK").document.all.tags("BODY")[0].document.getElementByID("task0").Click()

※ 대부분.. 엘리먼트의 이벤트를 발생시키기 위함.. FireEvent는 이벤트를 직접 발생시키는 함수
   pwb.document.getElementById("XX").fireEvent("ondblclick")

※ pwb.document.getElementById("iframe명").contentWindow.document 까지가 iframe 내부의 도큐먼트를 얻는 방법

;■■■ 다중 3중 프레임(Frame)
WinActivate, 새올 행정시스템 - Internet Explorer ; Title창 활성화 
Sleep, 200 
pwb:=WBGet() ; 웹포인터 !B 
; ■ 프레임(body → portlet33 → mysso) 값 입력 ■ 차세대인사랑 선택 + 클릭
pwb.document.parentWindow.frames("body").document.parentWindow.frames("portlet33").document.parentWindow.frames("mysso").document.all.tags("BODY")[0].document.getElementByID("sel_ssolist").value:="nexin"
pwb.document.parentWindow.frames("body").document.parentWindow.frames("portlet33").document.parentWindow.frames("mysso").document.all.tags("BODY")[0].document.getElementsByTagname("IMG")[0].click()
작업창대기("인사랑 - 강진군 - Internet Explorer") ; 나타날 때까지 
Sleep, 500 
pwb:=WBGet() ; 웹포인터 !B


; ■ 프레임 ID (body → portlet36 → uejungcount) + TagName 클릭 ■ 새올 - e호조 열기
pwb:=WBGet() ; 웹포인터 !B 활용하기
pwb.document.parentWindow.frames("body").document.parentWindow.frames("portlet36").document.parentWindow.frames("uejungcount").document.all.tags("BODY")[0].document.getElementsBytagname("TD")[5].click()


8. 기타
  가. #c(Win+c) : 캡쳐도구     
  나. !D(폴더열기),   ^e(편집) 
  다. 핫키 지정 :  #3:: ~  Return
  라. 핫스트링 샘플
    :*:s1::Sleep, 2000  ; 2초 대기(ms)
    :*:a1::안녕하세요{enter}
    :*:a2::즐거운 하루 되세요. `n다음에 또만나요{enter}

9. 기타 핫키
  ^q(기준 위치1),  ^w(상대이동 위치 클릭) 
  ^+q(픽셀 위치 및 값), ^+w(클릭할 위치)
  q1은 Send, {enter} 입력 + ,뒤 커서
  ◆값입력: input_value(var) 한영혼용시 활용 ◆ 창닫기(타이틀명)
  ◆검색 엔터: find_text_enter("처리")
     엑셀에서 EndRows(ex,2) → B열(2)의 끝행수

===================================

■ 파일 유무에 따른 실행조건
Run, Hi.txt, ,UseErrorLevel  ; 현스크립트 위치에 있다면 실행, 없다면 메시지..
if ErrorLevel
    msgbox, 파일을 찾을 수 없습니다.
else
    msgbox, 파일을 실행 시켰습니다.

■ 비교연산자
    a > b || c < d        ; ■ OR    // a가 b보다 크거나 c가 d보다 작다
    a = b && c <> d  ; ■ AND // a와 b가 같고 c가 d와 다르다
    a != b ; ab는 같지 않다 a <> b 같은뜻 // <>는 다르다, != 같지 않다.

■ 증감연산자 : ++ (변수값에 1씩 더하기 // -- (변수값에 1씩 빼기)
    var := var + 1  /  var += 1  / var++   ※ 모두 동일

■ 연산자 : 덧셈 + / 뺄셈 - / 곱셈 * 
    나눗셈과 나머지의 경우는, /와 %를 사용하는 대신
    // 와 mod(나눠질 값,몫) 사용, 거듭제곱 **

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

■ 숫자 표현 ■
SetFormat,FLOAT,0.0 ; 소숫점 6자리
var+=0
var:=ex.cells(1,3).Value ; ※ 위의 2개 코드 없으면, 1.000000 소수6자리 표현됨
SendInput, % var         ; 또는 input_value(var) ※ 클립보드 활용

■ 날짜표현 방법 ■
ex := ComObjActive("Excel.Application") ; 열려있는 엑셀을 ex로 선언 
ex.sheets("Sheet1").select  ; 시트 선택
var:=ex.range("A2").value  ; 날짜(2020-10-10)
FormatTime, var1,var, yyyyMMdd  ; ▶ 20201010 형식 변환(var1)
ex.range("C3") := var1

■ 날짜계산 ■ 오늘 + 30일 표현
FormatTime, currentDate,,yyyyMMdd  ; 오늘 날짜
msgbox % currentDate
currentDate  += 30, days   ; + 30 일
FormatTime, resultdate,%currentDate%,yyyyMMdd
msgbox % resultdate

FormatTime,Date,,yyyy.MM.dd ; msgbox,%Date% ; → 2019.10.24
FormatTime,Date,,yyyy-MM-dd ; msgbox,%Date% ; →  2019-10-24
d=20090215
FormatTime,res,%d%,yyyy_M_d
msgbox,%res%

XL.Range("F2").NumberFormat := "yyyymmdd"  ; 엑셀 날짜형식변경


; ■ 정해진 시간(특정시간)에 작업할 경우
loop{
    FormatTime, Timevar,,HHmm  ; hh(12), HH(24시간)
    if (Timevar = "1230"){  ; Timevar 값이  "0230"와 같다면
        MsgBox, The current time is %Timevar%
        ;~ Run %comspec% /c "shutdown.exe /r /t 0" ; 리부팅(/r), 종료(/s) 
        }
    sleep, 30000  ; 30초 마다 반복 / 과부하 예방
}

 ; 추후 OCR 활용시 ^t::
{  ; ^q 범위시작 위치 → ^q 범위끝 위치  ; OCR 대상
    MouseGetPos, X2, Y2
    EditorSelect_EngMode()
    aa:=X2 - X1
    bb:=Y2 - Y1
    SendInput, ocr_text := GetOCR(%X1%, %Y1%, %aa%, %bb%){space}{enter}ocr_num(ocr_text){End}{Space}{;}ocr_text {<} 0{Enter}
    SendInput, MsgBox, `% ocr_text{enter}
}	
Return

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

; ■ 블럭 내용 메모장 복사하기
^q::
Send, ^{c}
Sleep, 200
IfWinNotExist, ahk_exe notepad.exe
{
    Run, notepad
    WinWaitActive, ahk_class Notepad
}
WinActivate, ahk_class Notepad
sleep, 100
Send, ^{v}{enter 2}
Sleep, 200
Send, !{tab}
return

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

■ 파일복사 및 삭제
FileDelete, C:\AHK\ex*.txt ; FileDelete, C:\AHK\ex1.txt
loop, 5 {
    FileCopy, %A_ScriptDir%\eex.txt, %A_ScriptDir%\ex%A_Index%.txt
}

;◆ 파일삭제
FileDelete, %A_ScriptDir%\ex0*.txt ; FileDelete, C:\AHK\ex1.txt
Sleep, 1500

;◆ 파일생성
FileAppend, Another line.`n`n, %A_ScriptDir%\ex0.txt
FileAppend,
(
기본으로, 이전 줄과 이 줄 사이의 하드 캐리지 리턴은 (Enter) 파일에 쓰여집니다.`n이 줄은 탭 하나로 들여쓰기 됩니다 %Var%와 같은 변수 참조는 기본으로 확장됩니다.
), %A_ScriptDir%\ex0.txt

		
;◆ 파일복사
loop, 2 {
    FileCopy, %A_ScriptDir%\ex0.txt, %A_ScriptDir%\ex0%A_Index%.txt ; OK
}
Sleep, 200
MsgBox,,,완료,0.5
loop, 20 {
    if A_index < 10
        FileCopy, D:\Jugan\개인주간.hwp, D:\Jugan\0%A_index%개인.hwp
    if A_index >= 10
        FileCopy, D:\Jugan\개인주간.hwp, D:\Jugan\%A_index%개인.hwp
}

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

WinMinimize A 현재창을 최소화
WinRestore A 현재창을 이전 크기
WinMaximize A 현재창을 최대화
WinActivate 해당 창 활성화
#ifWinActive 해당 프로그램에서만 실행
winmove 해당 창 크기 및 위치 조절
ifwinexist 창의 참,거짓(실행중이면, 아니면 )

Run 브라우저 경로 및 실행 파일 "사이트 주소"
WinWaitActive 사이트 제목 ; 사이트 제목으로 해당 창이 로딩될 때까지 기다린다는 뜻
(안 하면 로딩 완료 전에 창 조절 스크립트 실행해서 창 조절 실패)

winmove a,, X축 위치 , Y축 위치 , X축 창크기 , Y축 창크기


;■■ while 구문 이용 : 연번 채우기
while (ex.Range("B" . A_Index+1).Value != "") { 
    ex.Range("A" . A_Index+1).Value := "=row()-1"
} 

■ GUI 설명 : https://elderlykims.tistory.com/30

■ 웹테스트 하기
pwb := WBGet()
if (pwb.LocationURL != "https://www.naver.com/"){
    pwb.navigate("https://www.naver.com/")
    while pwb.busy or pwb.ReadyState != 4
        Sleep, 100
    }
Sleep 300
pwb.document.getElementByID("query").Value := XL.range("C3").text . XL.range("G3").text
;~ pwb.document.getElementByID("query").Value := XL.range("v3").text
pwb.document.getElementByID("search_btn").click()
while pwb.busy or pwb.ReadyState != 4
    Sleep, 100
Sleep, 300

sArr :=XL.Range["A3:q10"] ;■ Store the content of the array into sArr
;~ MsgBox % IsObject(sArr) 
for row in sArr 
    for cell in row 
        data.= cell.TEXT "," 
MsgBox,,, % Data,1 ;■ If you want to access it directly, add the .Value 
;~ sArr :=XL.Range["A4:P4"].text
sArr :=XL.Range["A4:P4"].value
SetFormat,FLOAT,0.0  ;■ 숫자표시 → 아래와 함께 사용해서 정수로 출력
var+=0
MsgBox,,,% sArr[1,2],1


■ 배열 VS 일반코드 속도 비교
■ 계약_자동결재+자문중 파일과 함께 사용 / 노트패드 입력
시작 := A_TickCount  ; 소요 시간 측정 시
SetFormat,FLOAT,0.0  ; 숫자 아래와 함께 ...정수 출력
var+=0  ;~ endRow := ex.range("I1").value ; ■ A열의  갯수
endRow := ex.ActiveSheet.UsedRange.Rows.Count  ; ■ 모든행 갯수
endCol := ex.range("J1").value  ; 2행의 열갯수
;~ Arr :=ex.Range["A" endRow  ":R" endRow].value ; ■ 배열(A열수  1줄)
Arr :=ex.Range["A3:R" endRow].value ; ■ 배열(전체 범위 )
WinActivate, ahk_class Notepad
Sleep, 50
nrum := 1
loop, % endRow -2
{
    loop, % endCol - 8  ;~ MsgBox,,, % Arr[1, A_Index], 0.2
    {
        SendInput, % Arr[nrum, A_Index]
        Send {Tab} ;~ Sleep, 10
    }   ;~ Sleep, 10
    SendInput, {Enter}
    nrum := nrum+1
}
걸린시간 := A_TickCount - 시작
MsgBox, % 걸린시간
Sleep, 500
;~ MsgBox,,, % Arr[1, 3], 1  ;~ MsgBox,,, % Arr[1, 8], 0.5
nrum :=""
Arr := []


; ■■ 일반코드

■계약_자동결재+자문중 파일과 함께 사용 / 노트패드 입력

시작 := A_TickCount
SetFormat,FLOAT,0.0  ; 숫자 아래와 함께 ...정수 출력
var+=0
;~ endRow := XL.range("I1").value ; ■ A열의  갯수
endRow := XL.ActiveSheet.UsedRange.Rows.Count  ; ■ 모든행 갯수
endCol := XL.range("J1").value  ; 2행의 열갯수
WinActivate, ahk_class Notepad
Sleep, 50                                                                               
nrum := 1                 
loop, % endRow -2
    {
        loop, % endCol - 8  ;~ MsgBox,,, % Arr[1, A_Index], 0.2
        {
            SendInput, % XL.cells(nrum+2, A_Index).text
            Send {Tab} ;~ Sleep, 10
        } ;~ Sleep, 10
        SendInput, {Enter}
        nrum := nrum+1
    }
걸린시간 := A_TickCount - 시작
MsgBox, % 걸린시간
Sleep, 500

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

■ 텍스트파일(txt file)에 입력내용 저장하고 읽어오기
InputBox, inputText ; 입력내용을 inputtext 변수에 저장
  ;~ MsgBox,,, %inputText%, 1
  ;~ FileDelete, C:\AHK\inputSave.txt   ; 기존 파일 지우고
  ;~ FileAppend, %inputText%, C:\AHK\inputSave.txt ; 파일저장
  FileAppend, %inputText% `r`n, C:\AHK\inputSave.txt ; 파일저장
  Sleep, 1000
	
  FileRead, inputText, C:\AHK\inputSave.txt  ; 파일 읽고 클립보드 복사
  Clipboard = %inputText%  ; 추후 Ctrl + V
  ;~ MsgBox, % clipboard

; ■■■ 500자씩 맞춤범 검사하기(■크롬기준■) OK =======
; ■ 배열 생성. 최초는 비어 있음 : 500자씩 배열 추가
;FileRead, strvar, C:\Users\skion\Downloads\AHK1\Test.txt ; ■ TXT 파일 읽기
FileRead, strvar, %A_ScriptDir%\TEST\Test.txt ; ■ TXT 파일 읽기
Array := Object()

;■ 01 오백자까지 자르고, 오른쪽 공백문자 찾아서 자르기
loop, % Round(StrLen(strvar)/500) ; Round(3.14) → 3(정수만)
{
    StringLeft, OVar, strvar, 500 ; 500자까지 잘라서 OVar 넣기
    stringgetpos,pos,OVar,%A_Space%, r1 ; 오른쪽에서 1번째 '공백문자' 위치
    StringLeft, OVar, strvar, %pos% ; 500자에서 마지막 공백까지 자르기
    Array.Insert(OVar) ; ◆ 배열추가
    StringTrimLeft, strvar, strvar, %pos% ;왼쪽~마지막 공백까지지운것 변수
}
if StrLen(strvar) > 0 ; 500이하 나머지에 문자가 있다면
    Array.Insert(strvar) ; ◆ 배열추가
Sleep, 200
; loop, % Array.MaxIndex() { ; ■ 배열 내용 보기
;     msgbox,,, % Array[A_Index], 2
; }

; ■02 크롬 - 네이버 - 맞춤법 검사기 ※ 위쪽 코드까지 포함
Chrome := new Chrome() 
Pg := Chrome.GetPage() 
Pg.Call("Page.navigate", {"url": "https://naver.com/"}) 
Pg.WaitForLoad()
Sleep, 500
pg.Evaluate("document.querySelectorAll('#query')[0].value = '맞춤법 검사기'")
pg.Evaluate("document.querySelectorAll('#search_btn > span.ico_search_submit')[0].click()")
pg.WaitForLoad()
Sleep, 2000
FileDelete, %A_ScriptDir%\TEST\Test_result.txt ; 기존파일 삭제
result = ; ???
loop, % Array.maxindex()
{  ;; ■ 원문에 내용넣기 // 크롬변수 입력
    pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = ''")
    Sleep, 200
    pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = " Chrome.Jxon_Dump(Array[A_index]))
    Sleep, 200
    pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.check_info > button')[0].click()") ; 검사하기 버튼
    pg.WaitForLoad()
    Sleep, 1000

    ; ■ 복사버튼 클릭
    pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box.right._result.result > div > div.check_info.right > div.btn_area > button.copy')[0].click()") ; 복사하기버튼
    Sleep, 500
    FileAppend, %Clipboard%, %A_ScriptDir%\TEST\Test_result.txt
    Sleep, 500
}
MsgBox, 작업이 완료되었습니다.
Run, %A_ScriptDir%\TEST\Test_result.txt

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

; ■■ 맞춤법 검사하기 2■ 500자씩 맞춤범 검사하기 // IE용
FileRead, strvar, %A_ScriptDir%\Test.txt ; ■ TXT 파일 읽기
; msgbox,,, % "전체읽기 " strvar,1
; ■ 배열 생성. 최초는 비어 있음 : 500자씩 배열 추가
Array := Object()
loop, % Round(StrLen(strvar)/500) ; Round(3.14) → 3(정수만)
{ ;■ 500자까지 자르고, 오른쪽 공백문자 찾아서 자르기
    StringLeft, OVar, strvar, 500 ; 500자까지 잘라서 OVar 넣기
    stringgetpos,pos,OVar,%A_Space%, r1 ; 오른쪽에서 1번째 '공백문자' 위치
    StringLeft, OVar, strvar, %pos% ; 500자에서 마지막 공백까지 자르기
    Array.Insert(OVar) ; ◆ 배열추가
    StringTrimLeft, strvar, strvar, %pos% ;■ 왼쪽부터 마지막 공백까지 지운것을 변수로
}
if StrLen(strvar) > 0 ; 500이하 나머지에 문자가 있다면
    Array.Insert(strvar) ; ◆ 배열추가
Sleep, 500
; loop, % Array.MaxIndex() { ; ■ 배열 내용 보기
;     msgbox,,, % Array[A_Index], 2
; }
pwb := WBGet() ;웹포인터 ALT+B 
pwb.Navigate("www.naver.com") ;주소열기 
while pwb.busy or pwb.ReadyState !=4 
    Sleep, 100 ; "clink."문자클릭 / .click() ; 클릭 get+id_name_tag.(점)
pwb.document.getElementByID("query").Value :="맞춤법 검사"
pwb.document.getElementByID("search_btn").click()
Sleep, 1500
pwb := WBGet() ;웹포인터 ALT+B 
result =
loop, % Array.maxindex()
{
    pwb.document.getElementsByClassName("txt_gray")[0].Value := "" ; 원문 초기화
    pwb.document.getElementsByClassName("txt_gray")[0].Value := Array[A_index] ; 원문 입력
    Sleep, 300
    pwb.document.getElementsByClassName("btn_check")[0].click()
    Sleep, 2000
    var:=pwb.document.getElementsByClassName("_result_text stand_txt")[0].innertext
    result = %result% %var% 
}
msgbox,,, % result,1  ; 번역결과 확인
FileDelete, %A_ScriptDir%\Test_result.txt
FileAppend, %result%, Test_result.txt

;===========================================

;■■ 웹페이지 셀값 넣기 01 / 날짜형식(yyyymmdd) 셀값(input_value)
ex:=ComObjActive("Excel.Application") ;열려있는엑셀 ex로 선언 
ex.sheets("DB").select ;시트명 확인★ 
ex.range("C2").select  ; C2셀 선택
loop {
    if (ex.Activecell.offset(0,-2).value = "")  ; A2셀값이 없다면 ■ 
        break  ; loop 탈출
    pixel_click(-134, 107, "0xFF0202") ; 픽셀서치 계약건명 위치 클릭
    input_value(ex.Activecell.value)  ; 1 계약명 입력 / 한영혼합 클립복사 ■ 
    Send, {Tab}
    input_value(ex.Activecell.Offset(0,1).value)  ; 2 업체명 입력 ※한영 혼합
    Send, {Tab}
    Send, % ex.Activecell.Offset(0,2).value  ; 3 금액
    Send, {Tab}
    StringReplace, var,% ex.Activecell.Offset(0,3).value, -,,All  ; 날짜에서 "-" 제거 ■ 
    Send, % var
    Send, {Tab}
    input_value(ex.Activecell.Offset(0,4).value)  ; 5 감독부서
    Send, {Tab}
    if (ex.Activecell.offset(0,-1).value = "공사")  ; 조건문 if ■
        send, {space}
    if (ex.Activecell.offset(0,-1).value = "용역")
        send, {space}{right}
    if (ex.Activecell.offset(0,-1).value = "물품")
        send, {space}{right 2}
    Send, {tab}
    if (ex.Activecell.offset(0,5).value = "관내")
        send, {space}{tab 2}
    if (ex.Activecell.offset(0,5).value = "관외")
        send, {tab}{space}{tab}
    ex.Activecell.offset(1,0).select ; 아래셀 선택(이동) ; ■ 선택셀 이동(아래한칸)
    Sleep, 500      ; 내용 보이기 위해(불필요)
    Send, {enter}   ; 엔터(저장) 후 슬림추가 검토
}

; ■■  웹페이지 셀값넣기 02
ex:=ComObjActive("Excel.Application") ;열려있는엑셀 ex로 선언 
ex.sheets("DB").select ;시트명 확인★★ 
WinActivate, TEST_WEB.html - Chrome ; Title창 활성화 
ex.Range("a1").End(-4121).Select ;★A열 끝셀 ;xlDown(-4121), xlup(-4162)
if(ex.Activecell.offset(0,1).value = "")  ; 조건문
	break
Click, 120, 195 ; 1. 계약건명 칸 클릭
var := ex.Activecell.offset(0,2).value ; 계약건명
send, %var%{tab}
send, % ex.Activecell.offset(0,3).value ; 업체명칭
send, {tab}
send, % ex.Activecell.offset(0,4).value ; 계약금액
send, {tab}
StringReplace, var,% ex.Activecell.offset(0,5).value, -,,All 
send, % var  ; 20220202 일시###
send, {tab}
send, % ex.Activecell.offset(0,6).value ; 감독부서 ####
send, {tab}
Sleep, 200
;■  공사구분 입력
if(ex.Activecell.offset(0,1).value = "공사")
	send, {space}
if(ex.Activecell.offset(0,1).value = "용역")
	send, {right}
if(ex.Activecell.offset(0,1).value = "물품")
	send, {right 2}
Sleep, 200
send, {tab}	
Sleep, 200
if(ex.Activecell.offset(0,7).value = "관내")  ; ■ 관내외 선택
	Send, {space}{tab 2}
else
	Send, {tab 2}{space}{tab}
Sleep, 1000
Click, 37, 499 ; Send, {enter} ; 저장
ex.Range("a1").End(-4121).offset(1,0).value := "=ROW()-1"

;===========================================

;■■ 크롬-네이버 자동로그인
^/::   ; Ctrl+/
Chrome:=new Chrome()
Pg:=Chrome.GetPage()
Pg.Call("Page.navigate", {"url": "https://naver.com"})
Pg.WaitForLoad()
pg.Evaluate("document.querySelectorAll('#account > a > i')[0].click()") 
Pg.WaitForLoad()	
Sleep, 300
Send, {Tab 10}{Enter}
return


;■■ 시트취합 시트결합 시트병합
; ◆◆ 01 열려있는 엑셀파일의 시트 취합 
ex:=ComObjActive("Excel.Application")  ; 열려있는 엑셀 ex로 선언 
ex1:=ComObjCreate("Excel.Application") ; 새엑셀(취합할) ex1로 선언 
ex1.Workbooks.Add  ; 새문서 
ex1.visible:=true  ; 보이기 <-> False
shCnt := ex.Sheets.Count  ; 열려있던 ex의 시트 갯수
loop, % shCnt  ; ◆◆ 02 시트 취합
{
    ex.sheets(A_index).select
    ex.Range("A1").select ; 셀선택(기존 범위선택 예방)
    ; ◆◆ 03 Used 범위 복사
    if (A_index = 1)   ; 1회 반복이면
        Used_Rng(ex, 1).Copy ; 자료범위 복사(1 헤더 포함)
    else
        Used_Rng(ex, 0).Copy ; 자료범위 복사(0 헤더 미포함)
    ex1.sheets(1).Range("A" . Last_Row(ex1)+1).select ; 복사위치(마지막행+1)
    ex1.ActiveSheet.paste  ; 붙여넣기
    ex1.Application.CutCopyMode := False ; 복사모드 해제
    ex.Application.CutCopyMode := False  ; 복사모드 해제
}
ex1.ActiveSheet.Cells.Columns.AutoFit ; 열너비 자동 조정
ex1.cells(1,1).select
MsgBox, 시트취합 완료 엑셀 파워쿼리 권장


;■■ 폴더내 엑셀결합, 엑셀병합 / 엑셀 결합, 엑셀 병합
; ◆ 01 취합할 새로운 엑셀 열기
MsgBox, 열려있는 엑셀 종료 후 확인 버튼을 누르세요
ex:=ComObjCreate("Excel.Application") ; 새엑셀 ex 선언
ex.Workbooks.Add ; 새시트 생성
ex.Visible:=True ; 결과 보기 위해
ex.Activesheet.name:="Union" ; 시트이름 변경
ex.Range("A1").select ; A1셀 선택
FileSelectFolder, folder,,3 ; ◆ 02 취합 폴더 선택
;FileSelectFolder, folder,%A_ScriptDir%, 3 ; 현스크립트에서 선택하려면
loop, %folder%\*.xlsx ; ◆ 03 xlsx 파일 순차 실행
{ ; 엑셀 ex1로 선언
    ex1:=ComObjCreate("Excel.Application") ; 새엑셀 ex1 선언
    ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true) ;읽기모드로 열기
    ex1.Visible:=False ; 안보이게
    if (A_index = 1)   ; ◆ 셀값 복사 / 첫번째 실행할 경우 헤더포함 복사
        Used_Rng(ex1, 1).Copy ; 헤더 1유 0무 + 범위 복사
    else
        Used_Rng(ex1, 0).Copy ; 헤더 X 내용만 복사
    ex.sheets("Union").select ; 취합시트 선택 및 복사내용 붙여넣기
    ex.Range("A" . Last_Row(ex) +1).Select ; EndRows(ex, 1) ; A열 마지막줄+1 선택
    ex.ActiveSheet.Paste ; 붙여넣기
    ex1.Application.CutCopyMode:=false ; 복사모드 해제 
    ex1.Quit ; ex1 종료
} ;~ ex.Range("A3:A" . Last_Row(ex)).Formula:= "=row()-2" ; 자동 number(수식)
MsgBox, 폴더내 엑셀파일 취합 완료


; ■■ 01 취합엑셀 생성(폴더내 파일을 시트별로 저장)
ex:=ComObjCreate("Excel.Application") ; 새엑셀 ex로 선언
ex.Workbooks.Add ; 시트 생성
ex.Visible:=True ; 보이기
FileSelectFolder, folder,,3 ; ◆ 02 취합 폴더 선택
; ■ 03 파일리스트 배열 : flielist[숫자] 활용

global FileArr:=[] ; 배열 선언
loop, %folder%\*.xlsx {  ; 해당폴더\*.*  순환반복
    StringReplace, FileNameNoExt, A_LoopFileName, % "." . A_LoopFileExt
    FileArr.push(FileNameNoExt)
}
; ■ 04 폴더 내 .xlsx 순차실행
ex1:=ComObjCreate("Excel.Application") ; 새엑셀 ex1 선언
loop, %folder%\*.xlsx { ;loop, C:\Users\USER\Downloads\excel_sample\*.xlsx 
{ ; 폴더지정
    ex1.Workbooks.Open(A_LoopFileFullPath,, readonly := true)
    ex1.Visible:=False   ; 안보이게 ; ex1.sheets(1).select ; 1번째 시트 확인
    ex1.sheets(1).cells.copy           ; ex1 1번시트 복사
    ex.Sheets.Add(ComObjMissing(), ex.Sheets(ex.Sheets.Count)) ;시트추가(끝에)★
    ex.ActiveSheet.name:=fileArr[A_index] ; 이름변경 ex.ActiveSheet.name:= A_index
    ex.Activesheet.paste ; 붙여넣기 shcnt:=ex.sheets.count
    ex.Activecell.offset(1,0).select  ; 아래셀 선택(음영해제)
    ex1.Application.CutCopyMode:=false ; 복사모드 해제 
    ex1.Workbooks.Close ; 엑셀 문서만 닫기
}
ex1.Quit ; ex1 종료
ex.sheets(2).select
MsgBox,,, 폴더내 엑셀취합 완료,2


todaypath = %A_ScriptDir%\123
FileCreateDir, %todaypath%
url := "https://news.naver.com/"
wb:=ComObjCreate("InternetExplorer.Application")
wb.Navigate(url)
wb.Visible := true
While wb.busy ; wait for the page to load
while wb.readyState <> 4 || wb.document.readyState != "Complete" || wb.busy
    Sleep, 100
;~ loop, 3	{
    ;~ wb.document.parentWindow.scrollBy(0,3000) ; 하단 끝까지 내림
;~ }
While wb.busy ; wait for the page to load
while wb.readyState <> 4 || wb.document.readyState != "Complete" || wb.busy
    Sleep, 100
ex:=ComObjCreate("Excel.Application") ;새엑셀 ex로 선언 
ex.Workbooks.Add  ; 새문서 
ex.Visible:=true
ex.range("A1").value := 12300 ; 숫자입력 
ex.Activecell.offset(0,1).value:=todaypath
ex:=""


;■ 지정 폴더내 파일리스트 : 0, 1, 2
File_List("c:\*.*",0) ; 0파일만List, 1확장자까지,2Full 경로까지
MsgBox, % List_Arr.length() "개 / 1번값: " List_Arr[1] 

;■ 자동 검색하기
InputBox, SearchTerm, Search
if not ErrorLevel
if SearchTerm <> ""
    Run, https://search.naver.com/search.naver?where=nexearch&query=%SearchTerm%
if not ErrorLevel
if SearchTerm <> ""
    Run, http://www.google.com/search?q=%SearchTerm%


;####### test

; This script gets a range of cells in column A and B. (Like selecting cell A2 and then pressing Ctrl+Shift+Down and
; then Shift+Right.) Then each time the Ctrl+F12 hotkey is pressed it sends the next value.
; Usage:; Press Ctrl+F12 to send the next value.
; Constants
xlDown := -4121

Path := A_ScriptDir "\123.xlsx"       ; <-- Change this to the path of your workbook
ex := ComObjCreate("Excel.Application")  ; Create an instance of Excel
ex.Visible := true                                  ; Make Excel visible
Mybook := ex.Workbooks.Open(Path)     ; Open the workbook
CellA2 := ex.Cells(2, 1)                          ; Store a reference to cell A2
LastCell := CellA2.End(xlDown).Offset(0,1) ; Store the last cell. .End is like pressing Ctrl+Down
MyRange := ex.Range(CellA2, LastCell)     ; Store a reference to the Range A2:LastCell
CellNumber := 1                                  ; This variable will store the cell number to use
CellCount := MyRange.Cells.Count                            ; Store the count of cells in the range
return

^F12::                                                                            ; Ctrl+F12 hotkey
    SendRaw % MyRange.Cells(CellNumber).Text  ; Send the current cell specified by 'CellNumber'
    CellNumber++                                          ; Increase 'CellNumber' by one
    if (CellNumber > CellCount) {    ; If 'CellNumber' is greater than the total amount of cells...
        MsgBox, 64, Info, Finished. No more cells.  ; Done
        CellNumber := 1
}
return

; References
; https://autohotkey.com/boards/viewtopic.php?p=112648#p112648
; https://github.com/ahkon/MS-Office-COM-Basics/blob/master/Examples/Excel/Cells_in_a_column.ahk

; ■■■ 인터넷(IE) 제어하기
wb := ComObjCreate( "InternetExplorer.Application" )
wb.navigate( "https://nid.naver.com/nidlogin.login" )
While wb.readyState <> 4 || wb.document.readyState != "complete" || wb.busy
    Sleep, 100
wb.document.getElementById( "id" ).value :=  "아이디"
wb.document.getElementById( "pw" ).value :=  "비번"
wb.document.getElementById( "frmNIDLogin" ).submit()  ;로그인 정보를 서버에 전송
wb.Visible := true  ; IE창 보여줌

; ■■ 특정 요소를 클릭하는 방법 (ID 없을 때)
ele := pwb.document.getElementsByTagName("button") ;버튼을 btn변수에 담음.
loop % ele.length {
    if (ele[A_Index-1].getAttribute("onclick") = "javascript:NextSubmit();") {
        ele[A_Index-1].click()
        break
    }
} ;■ ele를 하나씩 확인하여, 속성이 onclick=javascript:NextSubmit(); 인경우 클릭

; 출처: https://secretgd.tistory.com/277 [비밀의화원]



; ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ 

; ■ 문서작성 : 제목, 문서요지
WinActivate, 문서관리카드 - Internet Explorer ; Title창 활성화 
Sleep, 200 
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.getElementByID("title~100").Value :="제목을 입력"
pwb.document.getElementByID("summary~100").Value :="요지를 입력"

;■ 과제카드명
pwb.document.getElementByID("PRJ_BUTTON").click()
작업창대기("과제선택 - Internet Explorer")
Sleep, 500
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.parentWindow.frames("TASK").document.all.tags("BODY")[0].document.getElementByID("task240").Click() ;■불법농지단속 클릭
pwb.document.all.tags("A")[10].fireEvent("onclick") ;■확인 클릭

;■ 보고경로
WinActivate, 문서관리카드 - Internet Explorer ; Title창 활성화 
Sleep, 100 
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.all.tags("A")[3].fireEvent("onclick") ; ■ 경로지정
작업창대기("보고경로 - Internet Explorer")
Sleep, 500 
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.getElementByID("raAsk4").click() ; 전결 클릭
Click, 935, 356, 2 ; 2클릭
Sleep, 500
pwb.document.GetElementsByTagName("A")[14].click()
Sleep, 500

;■ 시행정보
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.getElementByID("sendname~100").value := "강진군수"
pwb.document.getElementByID("chkAutoSend~100").click()
pwb.document.getElementByID("open~100").value := "DPBT3"
pwb.document.getElementByID("chkOpenbasis6~100").click() ; 안먹힘XXX
pwb.document.getElementByID("opendesc~100").value := "개인정보"
Sleep, 1000
MouseMove, 900, 500 ; 
Sleep, 200
pwb.document.all.tags("A")[26].fireEvent("onclick") ;■관인 클릭
MouseClick, Left, 36, -25,1,,,R  ; 
작업창대기("BmsOrgTe - Internet Explorer") ; 나타날 때까지 
Sleep, 1500 
Click, 591, 558 ;
Sleep, 1000
WinActivate,문서관리카드 - Internet Explorer ; Title창 활성화 
Sleep, 200 
pwb:=WBGet() ; 웹포인터 !B 
pwb.document.getElementsBytagname("A")[15].click() ; 클릭 
작업창대기("첨부할 파일을 선택하십시오") ; 나타날 때까지 
Sleep, 500 
Send, % 123.xlsx


; 참고? : 플로렌스 https://cafe.naver.com/ahklab/24329


WinActivate, 학습창 ; Title창 활성화 
Sleep, 200 
loop {
    img_click(163, 64, "파일명.png") ; 기본10초 
    sleep, 5000
}


; ■ IE 뉴스 제목 보기 테스트
wb := ComObjCreate("InternetExplorer.Application")
wb.Navigate("https://search.naver.com/search.naver?where=news&sm=tab_jum&query=강진군")
wb.Visible := true
While wb.busy
While wb.readyState <> 4 || wb.document.readyState != "complete" || wb.busy 
    Sleep, 100
loop, % wb.document.getElementsByClassName("news_tit").length { ; ■ Class로 요소값 확인하기
    MsgBox,,, % wb.document.getElementsByClassName("news_tit").item(A_index - 1).innerText, 0.3
}