;■ 초기설정
#Singleinstance Force ; 미종료 상태 새로켜짐 
#NoEnv ; 환경변수 무시 
SendMode Input ; 속도, 안전성 추천 
SetWorkingDir %A_ScriptDir%  ; 현재 작업폴더 기준 
CoordMode, Pixel, Screen    ; 전체화면  이미지 기준 
CoordMode, Mouse, Screen ; 전체화면 마우스 
SetFormat,FLOAT,0.0  ; 소숫점 6자리 예방(아래줄과 함께) 
var+=0 

;■ 01 파일 열기(TEST폴더) : TEST_EXCEL.xlsx 과 TEST_EXCEL웹.html

;■ 02 열려있는 엑셀 설정
ex:=ComObjActive("Excel.Application") ; 열려있는엑셀 ex로 선언 
ex.sheets("DB").select ; 시트명 확인★

loop, 2 ; 횟수만큼 반복하기
{
	;■■ 00 작업창 활성화 : WinSpy 활용 등(Win_Logo키 → "spy")
	WinActivate, ahk_exe chrome.exe ; 작업창 활성화
	Sleep, 200
	
	; ■■ 01 계약건명 입력칸 클릭
	click, 111, 195 ;  / WinSpy 활용 등
	
	; ■■ 02 응용프로그램에  셀값 입력하기
	ex.Range("a1").End(-4121).Select ; A1셀 기준 끝행 선택
	Send, % ex.Activecell.offset(0,2).value ; 1 계약명 / 선택셀 기준 행0,열2 위치값 입력
	Send, {tab}  ; 다음칸 이동
	Send, % ex.Activecell.offset(0,3).value ; 2 업체명
	Send, {tab}
	Send, % ex.Activecell.offset(0,4).value ; 3 금액
	Send, {tab}
	Send, % ex.Activecell.offset(0,5).value ; 4 일시
	Send, {tab}
	Sleep, 200

	; 5 공사구분 : 공사, 용역, 물품 ★★ if조건문
	if (ex.Activecell.offset(0,1).value = "공사")
		Send, {space}
	if (ex.Activecell.offset(0,1).value = "용역")
		Send, {right}{space}
	if (ex.Activecell.offset(0,1).value = "물품")
		Send, {right 2}{space}
	Sleep, 200
	Send, {tab}
	Sleep, 200
	
	; 6 관내, 관외(if)
	if (ex.Activecell.offset(0,6).value = "관내")
		Send, {space}{tab 2}
	else
		Send, {tab}{space}{tab}
	Sleep, 200
	
	; 7 참고사항(if) : 검토, 추진중, 완료
	if (ex.Activecell.offset(0,7).value = "검토")
		Send, {down}
	else if (ex.Activecell.offset(0,7).value = "추진중")
		Send, {down 2}
	else
		Send, {down 3}
	Sleep, 200
	Send, {tab}
	
	Sleep, 2000 ; 자료 입력상황 보기 위해서
	Send, {enter}  ; 저장하기 클릭
	
	; 다음자료 입력위해 A열 끝행 + 1에 자료입력
	ex.Range("a1").End(-4121).offset(1,0).value := "=ROW()-1"
}
