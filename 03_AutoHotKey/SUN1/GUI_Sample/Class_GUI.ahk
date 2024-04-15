; °ü·ÃÀÚ·á : https://github.com/AHK-just-me/Class_ImageButton
; /Sources/V1_4/Class_ImageButton.ahk  ÆÄÀÏ È°¿ë
#NoEnv
#SingleInstance, Force
SetBatchLines, -1
#Include Class_ImageButton.ahk
Gui, Font, s11 normal, ¸¼Àº °íµñ
ControlSetText, , , ahk_id %HWND%

Gui, Add, Button, xm ym w80 h25 hWndhBtn11, % "¹öÆ°01"
IBBtnStyles := [ [ 0, 0x80F0F0F0 , , , 0,  , 0x802B2B2B, 0]  ; normal ; °î·ü0,µÎ²²0
						, [0, 0x80F0B9B8, , , 0,  , 0x802B2B2B, 0]   ; hover
						, [0, 0x80E27C79, , , 0,  , 0x802B2B2B, 0]   ; pressed
						, [0, 0x80F0F0F0 , , , 0,  , 0x802B2B2B, 0] ]
ImageButton.Create(hBtn11, IBBtnStyles*)
;=====================================
; »ö»ó : 0x80 + html color code 6ÀÚ¸®
; °î·ü : ¼ýÀÚ 0Á÷°¢  1~  ; ¿Ü°û¼± µÎ²² : 1~
;=====================================

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn22, % "¹öÆ°02"
IBBtnStyles := [ [ 0, 0x80FCEFDC, , , 4,  , 0x80F0AD4E, 1]  ; normal ;°î·ü4, µÎ²²1
						, [0, 0x80F6CE95 , , , 4,  , 0x80F0AD4E, 1]  ; hover
						, [0, 0x80F0AD4E, , , 4,  , 0x80F0AD4E, 1]  ; pressed
						, [0, 0x80F0F0F0 , , , 4,  , 0x80F0AD4E, 1] ]
ImageButton.Create(hBtn22, IBBtnStyles*)

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn21, % "¹öÆ°03"
IBBtnStyles := [ [ 0, 0x80F0B9B8 , , , 8 ,  , 0x80D43F3A, 1]  ; normal ; °î·ü8
						, [0, 0x80E27C79 , , , 8 ,  , 0x80D43F3A, 1]  ; hover
						, [0, 0x80D43F3A , , , 8 ,  , 0x80D43F3A, 1]  ; pressed
						, [0, 0x80F0F0F0  , , , 8 ,  , 0x80D43F3A, 1] ]
ImageButton.Create(hBtn21, IBBtnStyles*)

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn44, % "¹öÆ°04"
IBBtnStyles := [ [ 0, 0x80FA9656, , , 12,  , 0x80FE5404, 2]  ; normal, °î·ü12 µÎ²²2
						, [0, 0x80FE5404, , , 12,  , 0x80FE5404, 2]  ; hover
						, [0, 0x80FF0A02, , , 12,  , 0x80FE5404, 2]  ; pressed
						, [0, 0x80FA9656, , , 12,  , 0x80FE5404, 2] ]
ImageButton.Create(hBtn44, IBBtnStyles*)

Gui, Show,x1100 y210, Class_ImageButton Sample
return

GuiClose:
GuiEscape:
ExitApp

^r::Reload

Button¹öÆ°01:
MsgBox, ¹öÆ°1Å¬¸¯
return