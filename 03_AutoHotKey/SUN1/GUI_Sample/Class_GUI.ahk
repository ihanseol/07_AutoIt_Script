; �����ڷ� : https://github.com/AHK-just-me/Class_ImageButton
; /Sources/V1_4/Class_ImageButton.ahk  ���� Ȱ��
#NoEnv
#SingleInstance, Force
SetBatchLines, -1
#Include Class_ImageButton.ahk
Gui, Font, s11 normal, ���� ���
ControlSetText, , , ahk_id %HWND%

Gui, Add, Button, xm ym w80 h25 hWndhBtn11, % "��ư01"
IBBtnStyles := [ [ 0, 0x80F0F0F0 , , , 0,  , 0x802B2B2B, 0]  ; normal ; ���0,�β�0
						, [0, 0x80F0B9B8, , , 0,  , 0x802B2B2B, 0]   ; hover
						, [0, 0x80E27C79, , , 0,  , 0x802B2B2B, 0]   ; pressed
						, [0, 0x80F0F0F0 , , , 0,  , 0x802B2B2B, 0] ]
ImageButton.Create(hBtn11, IBBtnStyles*)
;=====================================
; ���� : 0x80 + html color code 6�ڸ�
; ��� : ���� 0����  1~  ; �ܰ��� �β� : 1~
;=====================================

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn22, % "��ư02"
IBBtnStyles := [ [ 0, 0x80FCEFDC, , , 4,  , 0x80F0AD4E, 1]  ; normal ;���4, �β�1
						, [0, 0x80F6CE95 , , , 4,  , 0x80F0AD4E, 1]  ; hover
						, [0, 0x80F0AD4E, , , 4,  , 0x80F0AD4E, 1]  ; pressed
						, [0, 0x80F0F0F0 , , , 4,  , 0x80F0AD4E, 1] ]
ImageButton.Create(hBtn22, IBBtnStyles*)

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn21, % "��ư03"
IBBtnStyles := [ [ 0, 0x80F0B9B8 , , , 8 ,  , 0x80D43F3A, 1]  ; normal ; ���8
						, [0, 0x80E27C79 , , , 8 ,  , 0x80D43F3A, 1]  ; hover
						, [0, 0x80D43F3A , , , 8 ,  , 0x80D43F3A, 1]  ; pressed
						, [0, 0x80F0F0F0  , , , 8 ,  , 0x80D43F3A, 1] ]
ImageButton.Create(hBtn21, IBBtnStyles*)

Gui, Add, Button, x+10 yp w80 h25 hWndhBtn44, % "��ư04"
IBBtnStyles := [ [ 0, 0x80FA9656, , , 12,  , 0x80FE5404, 2]  ; normal, ���12 �β�2
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

Button��ư01:
MsgBox, ��ư1Ŭ��
return