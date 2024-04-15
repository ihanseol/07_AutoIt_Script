#SingleInstance, Force                     ; 프로세스 중복실행 금지
Gui, Add, Button,         , Google        ; 버튼 추가,  , ,내 생략시 자동
Gui, Add, Button,         , Naver          ; 버튼 추가 (기본 세로방향 추가)
Gui, Add, Button,         , 유튜브         ; 버튼 추가
Gui, Show, x120 y20    , GUI 1           ; GUI 1 보이기

Gui, 2:Add, Button,          , Google     ; 버튼 추가
Gui, 2:Add, Button, x+10 , Naver       ; 버튼 추가  ★ x+10 우측 추가
Gui, 2:Add, Button, x+10 , 유튜브      ; 버튼 추가  ★
Gui, 2: Show, x230 y20,      GUI 2       ; GUI 2 보이기, ★ x y (위치 조정)

Gui, 3:Font, s11  ,     맑은 고딕           ; 크기, 글꼴 ★
Gui, 3:Add, Button,          , Google      ; 버튼 추가
Gui, 3:Add, Button, x+10 , Naver        ; 버튼 추가
Gui, 3:Add, Button, x+10 , 유튜브       ; 버튼 추가
Gui, 3:-Caption                                    ; 제목바 X  ★
Gui, 3: Show, x230 y120,     GUI 3       ; GUI 3 보이기, x y (위치 조정)

Gui, 4:Font, s11   , 맑은 고딕               ; 크기, 글꼴
Gui, 4:Color, green                              ; 배경색 / Blue Red Yellow Purple Aqua... ★
Gui, 4:Add, Button,         , Google       ; 버튼 추가
Gui, 4:Add, Button, x+10 , Naver        ; 버튼 추가
Gui, 4:Add, Button, x+10 , 유튜브       ; 버튼 추가
Gui, 4: Show, x500 y20    ,  GUI 4        ; GUI 4 보이기, ★ x y (위치 조정)

Gui, 5:Font, s11   , 맑은 고딕              ; 크기, 글꼴
Gui, 5:Color, 648CFE                           ; 배경색 / html color code ★
Gui, 5:Add, Button,          , Google     ; 버튼 추가
Gui, 5:Add, Button, x+10 , Naver        ; 버튼 추가
Gui, 5:Add, Button, x+10 , 유튜브       ; 버튼 추가
Gui, 5:-Caption                                    ; 제목바 X ★
Gui, 5: Show, x500 y120  , GUI 5         ; GUI 5 보이기

Gui, 6:Color, 9D70F7                              ; 색상 (html color code)
Gui, 6:Font, s12 Bold                              ; 크기 굵기, 기본글꼴 ★
Gui, 6:Add, Button, y10  h25 , Google    ; 버튼 추가  h높이 조정 ★
Gui, 6:Add, Button, x+10 h25, Naver      ; 버튼 추가
Gui, 6:Add, Button, x+10 h25, 유튜브     ; 버튼 추가
Gui, 6:Font, s11 , 맑은 고딕                     ; 크기 굵기, 기본글꼴 ★
Gui, 6:Add, Text, x15 CWhite, ※ 배경색 및 글꼴 등 변경 ; Text 추가
Gui, 6:-Caption                                        ; 제목바 X
Gui, 6: Show, x500 y205   , GUI 6            ; GUI 6 보이기

;~ ; Text 추가 및 g라벨로 버튼화  --------------------------------------

Gui, 7:Font, s12 , 맑은 고딕                         ; 크기, 글꼴
Gui, 7:Add, Text, gLGoogle , Google            ; Text 추가 ※g라벨은 "라벨:" 필요
Gui, 7:Add, Text, x+15 gLNaver, Naver        ; Text 추가
Gui, 7:Add, Text, x+15 gLYoutube, 유튜브   ; Text 추가
Gui, 7:+AlwaysOnTop                                   ; 항상위 ★
Gui, 7: Show, x820 y20, GUI 7                      ; GUI 7 보이기

Gui, 8:Color, FEAB1C                                            ; 색상 설정
Gui, 8:Font, s13 bold underline, 맑은 고딕           ; 크기 굵기 밑줄, 글꼴 ★
Gui, 8:Add, Text, cWhite gLGoogle , Google         ; Text 추가
Gui, 8:Add, Text, x+10 cBlue gLNaver, Naver        ; Text 추가
Gui, 8:Add, Text, x+10 cpurple gLYoutube, 유튜브 ; Text 추가
Gui, 8:+AlwaysOnTop -Caption                             ; 항상위,  제목바 X
Gui, 8: Show, x820 y125, GUI 8                              ; GUI 8 보이기

; Picture 추가 및 g라벨로 버튼화  --------------------------------------
Gui, 9:Color, 648CFE       ; 배경색 / html color code ★
Gui, 9:Add, Picture,           gLGoogle  , btn_google.png    ; 그림 추가 / 라벨 제어
Gui, 9:Add, Picture, x+10  gLNaver    , btn_naver.png       ; 그림 추가, g라벨
Gui, 9:Add, Picture, x+10  gLyoutube , btn_Youtube.png  ; 그림 추가
Gui, 9:Add, Picture, x+10  gLquit        , btn_exit.png         ; 그림 추가
Gui, 9:+AlwaysOnTop -Caption                                         ; 항상위,  제목바 X
Gui, 9: Show, x1100 y20, GUI 9                                          ; GUI 9 보이기

Gui, 10:Color, White       ; 배경색
Gui, 10:Add, Picture, w80 h-1 gLGoogle, %A_ScriptDir%\DATA\P_google.png  ; 그림 추가/라벨
Gui, 10:Add, Picture, x+10 w80 h-1 gLNaver, %A_ScriptDir%\DATA\P_naver.png  ; 그림 추가, g라벨
Gui, 10:Add, Picture, x+10 w80 h-1 gLyoutube, %A_ScriptDir%\DATA\P_Youtube.png  ; 그림 추가
Gui, 10:Add, Picture, x+10 w33 h-1  gLquit        , btn_exit.png         ; 그림 추가
Gui, 10:+AlwaysOnTop -Caption                                         ; 항상위,  제목바 X
Gui, 10: Show, x1100 y120, GUI 10                                          ; GUI 9 보이기

return  ;  초기 설정 및 GUI 설정  종료


; ■■ 단축키 설정 ==============================

GuiClose:      ; Gui창의 X 클릭 → 종료
;~ 2GuiClose:    ; 2Gui창의 X 클릭 → 종료
LQuit:            ; LQuit 라벨 설정 ← 라벨이름 + :(콜론)
ExitApp

^e::Edit         ; Ctrl+E 편집 
^r::Reload     ; Ctrl+R 다시로드

; ■■ 버튼 및 라벨 설정 ==========================

ButtonGoogle:   ; Google 버튼 설정 : Button + 버튼이름 + :(콜론)
2ButtonGoogle: ; 2Google 버튼 설정 : Button + 버튼이름 + :(콜론)
LGoogle:             ; 라벨 설정 →  g라벨이름 + :(콜론)
Run, chrome.exe www.google.com
return

ButtonNaver:    ; Naver 버튼 설정
2ButtonNaver:  ; 2Naver 버튼 설정
LNaver:              ; 라벨(TEXT 연결) →  라벨명: 
Run, chrome.exe www.naver.com
return

^y::                     ; Ctrl+y 핫키 지정
Button유튜브:    ; 유튜브 버튼 설정
2Button유튜브:  ;2유튜브 버튼 설정
LYouTube:           ; 라벨(TEXT 연결) →  라벨명: 
Run, chrome.exe http://www.youtube.com
return