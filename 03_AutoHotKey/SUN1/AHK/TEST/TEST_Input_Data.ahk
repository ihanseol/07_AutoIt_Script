;�� �ʱ⼳��
#Singleinstance Force ; ������ ���� �������� 
#NoEnv ; ȯ�溯�� ���� 
SendMode Input ; �ӵ�, ������ ��õ 
SetWorkingDir %A_ScriptDir%  ; ���� �۾����� ���� 
CoordMode, Pixel, Screen    ; ��üȭ��  �̹��� ���� 
CoordMode, Mouse, Screen ; ��üȭ�� ���콺 
SetFormat,FLOAT,0.0  ; �Ҽ��� 6�ڸ� ����(�Ʒ��ٰ� �Բ�) 
var+=0 

;�� 01 ���� ����(TEST����) : TEST_EXCEL.xlsx �� TEST_EXCEL��.html

;�� 02 �����ִ� ���� ����
ex:=ComObjActive("Excel.Application") ; �����ִ¿��� ex�� ���� 
ex.sheets("DB").select ; ��Ʈ�� Ȯ�Ρ�

loop, 2 ; Ƚ����ŭ �ݺ��ϱ�
{
	;��� 00 �۾�â Ȱ��ȭ : WinSpy Ȱ�� ��(Win_LogoŰ �� "spy")
	WinActivate, ahk_exe chrome.exe ; �۾�â Ȱ��ȭ
	Sleep, 200
	
	; ��� 01 ���Ǹ� �Է�ĭ Ŭ��
	click, 111, 195 ;  / WinSpy Ȱ�� ��
	
	; ��� 02 �������α׷���  ���� �Է��ϱ�
	ex.Range("a1").End(-4121).Select ; A1�� ���� ���� ����
	Send, % ex.Activecell.offset(0,2).value ; 1 ���� / ���ü� ���� ��0,��2 ��ġ�� �Է�
	Send, {tab}  ; ����ĭ �̵�
	Send, % ex.Activecell.offset(0,3).value ; 2 ��ü��
	Send, {tab}
	Send, % ex.Activecell.offset(0,4).value ; 3 �ݾ�
	Send, {tab}
	Send, % ex.Activecell.offset(0,5).value ; 4 �Ͻ�
	Send, {tab}
	Sleep, 200

	; 5 ���籸�� : ����, �뿪, ��ǰ �ڡ� if���ǹ�
	if (ex.Activecell.offset(0,1).value = "����")
		Send, {space}
	if (ex.Activecell.offset(0,1).value = "�뿪")
		Send, {right}{space}
	if (ex.Activecell.offset(0,1).value = "��ǰ")
		Send, {right 2}{space}
	Sleep, 200
	Send, {tab}
	Sleep, 200
	
	; 6 ����, ����(if)
	if (ex.Activecell.offset(0,6).value = "����")
		Send, {space}{tab 2}
	else
		Send, {tab}{space}{tab}
	Sleep, 200
	
	; 7 �������(if) : ����, ������, �Ϸ�
	if (ex.Activecell.offset(0,7).value = "����")
		Send, {down}
	else if (ex.Activecell.offset(0,7).value = "������")
		Send, {down 2}
	else
		Send, {down 3}
	Sleep, 200
	Send, {tab}
	
	Sleep, 2000 ; �ڷ� �Է»�Ȳ ���� ���ؼ�
	Send, {enter}  ; �����ϱ� Ŭ��
	
	; �����ڷ� �Է����� A�� ���� + 1�� �ڷ��Է�
	ex.Range("a1").End(-4121).offset(1,0).value := "=ROW()-1"
}
