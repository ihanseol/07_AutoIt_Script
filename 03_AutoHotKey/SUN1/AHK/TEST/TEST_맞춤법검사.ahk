{  ;심볼: #(Win로고), ^(Ctrl),  !(Alt),  +(Shfit)
	#Include %A_ScriptDir%\..\lib\Chrome\Chrome.ahk ; 크롬 제어
	;■ GUI 설정  ■ graphical user interface
	Gui, Show, x1640 y30 w265 h50, 맞춤법 ;화면크기&위치
	Gui, Add, Button, x10 y10 w70 h30,맞춤법검사
	Gui, Add, Button, x+10 w55 h30,저장로드
	Gui, Add, Button, x+10 w45 h30,편집
	Gui, Add, Button, x+10 w45 h30,종료
	Gui, +Alwaysontop
	Return
}
; ※ 크롬 참조 : https://m.blog.naver.com/goglkms/222145177039 외


{ ; ■■■■■  GUI창 제어   ■■■■■
	Button맞춤법검사:  ; ■■ 맞춤법 검사 버튼을 클릭하면 Return 전까지 실행됨
	맞춤법검사()  ; 맞춤법검사  함수를 실행함
	return
	
	^r::             ; ■ Ctrl+R 누르면   Return 까지 순차적 실행됨
	Button저장로드:  ; 저장로드 Button선언 : 수정 후  저장로드 ★★★
	ifwinexist, ahk_exe SciTE.exe      ; 전용편집기가 있다면
		WinActivate, ahk_exe SciTE.exe ; 전용편집기 활성화
	ifwinexist, ahk_class Notepad++    ; 노트패드++가 있다면
		WinActivate, ahk_class Notepad++
	Send, ^s    ; Ctrl+S 저장 명령
	Reload      ; 코드(Script) 다시 읽기,  종료없이 다시 시작
	Return      ; 핫키  종료 선언
	
	GuiClose:  ; GUI창  X  누르면
	ExitApp    ; 스크립트 종료   ↔ 실행은  F5(Run Script) 
	
	Button종료:  ; ■ 종료 Button  누르면
	ExitApp
	return
	
	^e::      ; ^e 누르면 편집창 열림
	Button편집:  ; ■ 편집 Button 누르면 실행됨  ~  Return 만날때까지
	Edit
	return

} ; End GUI창


; ■■■■■  함수 설정   ■■■■■

맞춤법검사()  ; 함수 정의
{ 	; ■■ 배열 생성.  500자씩 배열 추가
	FileRead, strvar, %A_ScriptDir%\TEST_맞춤법검사.txt  ;파일읽기
	Array := Object()  ; 객체 선언
	; ■ 01 500자 자르고, 오른쪽 공백문자 찾아서 자르기(글자 중간 끊김 방지)
	loop, % Round(StrLen(strvar)/500){         ; Round(3.14) → 3(정수만)
		StringLeft, Var1, strvar, 500                  ; 500자까지 잘라서 Var1 넣기
		stringgetpos,pos,Var1,%A_Space%, r1 ; 오른쪽에서 1번째 '공백문자' 위치
		StringLeft, Var1, strvar, %pos%             ; 500자에서 마지막 공백까지 자르기
		Array.Insert(Var1)                                  ; ◆ 배열 추가
		StringTrimLeft, strvar, strvar, %pos%    ; 왼쪽~마지막 공백까지 지운것 변수
	}
	if StrLen(strvar) > 0          ; 500 이하 나머지에 문자가 있다면
		Array.Insert(strvar)       ; 배열 추가
	Sleep, 200

	; ■■ 02 크롬 - 네이버 - 맞춤법 검사기  
	IfWinExist, ahk_exe chrome.exe
		WinKill, ahk_exe chrome.exe
	Sleep, 500
	Chrome := new Chrome()  ; ◆ 크롬 선언 
	Pg := Chrome.GetPage()    ; ◆빈페이지 열기 
	Pg.Call("Page.navigate", {"url": "https://naver.com/"})  ; ◆주소 이동
	Pg.WaitForLoad()  ; ◆로딩 대기
	Sleep, 500	
	; ■ 요소제어  : 우버튼-검사 → Copy →  Copy Selector 붙여넣기(#query)
	pg.Evaluate("document.querySelectorAll('#query')[0].value = '맞춤법 검사기'")
	pg.Evaluate("document.querySelectorAll('#search_btn > span.ico_search_submit')[0].click()")  ; 클릭  ※ 요소 (# ~ submit)
	pg.WaitForLoad()                                   ; 로딩이 완료될 때까지 대기
	Sleep, 1000                                            ; 1초 추가 대기 #### 필요시 추가
	FileDelete, %A_ScriptDir%\TEST_맞춤법검사결과.txt ; 기존파일  있다면 삭제
	result =   ; 초기화
	loop, % Array.maxindex()
	{  ;; ■■ 원문에 내용넣기 / 크롬변수 입력  ※ copy Selector 값 ' ' 사이 붙여넣기
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = ''") ;기존값 초기화
		Sleep, 200
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = " Chrome.Jxon_Dump(Array[A_index])) ; 변수값 넣기
		Sleep, 200
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.check_info > button')[0].click()") ; 검사하기 버튼
		pg.WaitForLoad()
		Sleep, 2000  ; 인터넷 속도가 늦을 경우 조정
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box.right._result.result > div > div.check_info.right > div.btn_area > button.copy')[0].click()") ; ■ 복사 버튼
		Sleep, 500
		FileAppend, %Clipboard%, %A_ScriptDir%\TEST_맞춤법검사결과.txt ; txt 파일에 쓰기
		Sleep, 1000
	}
	MsgBox,,, 작업 완료,1
	Run, %A_ScriptDir%\TEST_맞춤법검사결과.txt
}
