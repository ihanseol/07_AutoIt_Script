{  ;�ɺ�: #(Win�ΰ�), ^(Ctrl),  !(Alt),  +(Shfit)
	#Include %A_ScriptDir%\..\lib\Chrome\Chrome.ahk ; ũ�� ����
	;�� GUI ����  �� graphical user interface
	Gui, Show, x1640 y30 w265 h50, ����� ;ȭ��ũ��&��ġ
	Gui, Add, Button, x10 y10 w70 h30,������˻�
	Gui, Add, Button, x+10 w55 h30,����ε�
	Gui, Add, Button, x+10 w45 h30,����
	Gui, Add, Button, x+10 w45 h30,����
	Gui, +Alwaysontop
	Return
}
; �� ũ�� ���� : https://m.blog.naver.com/goglkms/222145177039 ��


{ ; ������  GUIâ ����   ������
	Button������˻�:  ; ��� ����� �˻� ��ư�� Ŭ���ϸ� Return ������ �����
	������˻�()  ; ������˻�  �Լ��� ������
	return
	
	^r::             ; �� Ctrl+R ������   Return ���� ������ �����
	Button����ε�:  ; ����ε� Button���� : ���� ��  ����ε� �ڡڡ�
	ifwinexist, ahk_exe SciTE.exe      ; ���������Ⱑ �ִٸ�
		WinActivate, ahk_exe SciTE.exe ; ���������� Ȱ��ȭ
	ifwinexist, ahk_class Notepad++    ; ��Ʈ�е�++�� �ִٸ�
		WinActivate, ahk_class Notepad++
	Send, ^s    ; Ctrl+S ���� ���
	Reload      ; �ڵ�(Script) �ٽ� �б�,  ������� �ٽ� ����
	Return      ; ��Ű  ���� ����
	
	GuiClose:  ; GUIâ  X  ������
	ExitApp    ; ��ũ��Ʈ ����   �� ������  F5(Run Script) 
	
	Button����:  ; �� ���� Button  ������
	ExitApp
	return
	
	^e::      ; ^e ������ ����â ����
	Button����:  ; �� ���� Button ������ �����  ~  Return ����������
	Edit
	return

} ; End GUIâ


; ������  �Լ� ����   ������

������˻�()  ; �Լ� ����
{ 	; ��� �迭 ����.  500�ھ� �迭 �߰�
	FileRead, strvar, %A_ScriptDir%\TEST_������˻�.txt  ;�����б�
	Array := Object()  ; ��ü ����
	; �� 01 500�� �ڸ���, ������ ���鹮�� ã�Ƽ� �ڸ���(���� �߰� ���� ����)
	loop, % Round(StrLen(strvar)/500){         ; Round(3.14) �� 3(������)
		StringLeft, Var1, strvar, 500                  ; 500�ڱ��� �߶� Var1 �ֱ�
		stringgetpos,pos,Var1,%A_Space%, r1 ; �����ʿ��� 1��° '���鹮��' ��ġ
		StringLeft, Var1, strvar, %pos%             ; 500�ڿ��� ������ ������� �ڸ���
		Array.Insert(Var1)                                  ; �� �迭 �߰�
		StringTrimLeft, strvar, strvar, %pos%    ; ����~������ ������� ����� ����
	}
	if StrLen(strvar) > 0          ; 500 ���� �������� ���ڰ� �ִٸ�
		Array.Insert(strvar)       ; �迭 �߰�
	Sleep, 200

	; ��� 02 ũ�� - ���̹� - ����� �˻��  
	IfWinExist, ahk_exe chrome.exe
		WinKill, ahk_exe chrome.exe
	Sleep, 500
	Chrome := new Chrome()  ; �� ũ�� ���� 
	Pg := Chrome.GetPage()    ; �ߺ������� ���� 
	Pg.Call("Page.navigate", {"url": "https://naver.com/"})  ; ���ּ� �̵�
	Pg.WaitForLoad()  ; �߷ε� ���
	Sleep, 500	
	; �� �������  : ���ư-�˻� �� Copy ��  Copy Selector �ٿ��ֱ�(#query)
	pg.Evaluate("document.querySelectorAll('#query')[0].value = '����� �˻��'")
	pg.Evaluate("document.querySelectorAll('#search_btn > span.ico_search_submit')[0].click()")  ; Ŭ��  �� ��� (# ~ submit)
	pg.WaitForLoad()                                   ; �ε��� �Ϸ�� ������ ���
	Sleep, 1000                                            ; 1�� �߰� ��� #### �ʿ�� �߰�
	FileDelete, %A_ScriptDir%\TEST_������˻���.txt ; ��������  �ִٸ� ����
	result =   ; �ʱ�ȭ
	loop, % Array.maxindex()
	{  ;; ��� ������ ����ֱ� / ũ�Һ��� �Է�  �� copy Selector �� ' ' ���� �ٿ��ֱ�
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = ''") ;������ �ʱ�ȭ
		Sleep, 200
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.text_area > textarea')[0].value = " Chrome.Jxon_Dump(Array[A_index])) ; ������ �ֱ�
		Sleep, 200
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box._original > div > div.check_info > button')[0].click()") ; �˻��ϱ� ��ư
		pg.WaitForLoad()
		Sleep, 2000  ; ���ͳ� �ӵ��� ���� ��� ����
		pg.Evaluate("document.querySelectorAll('#grammar_checker > div > div.api_cs_wrap > div.check_box > div.text_box.right._result.result > div > div.check_info.right > div.btn_area > button.copy')[0].click()") ; �� ���� ��ư
		Sleep, 500
		FileAppend, %Clipboard%, %A_ScriptDir%\TEST_������˻���.txt ; txt ���Ͽ� ����
		Sleep, 1000
	}
	MsgBox,,, �۾� �Ϸ�,1
	Run, %A_ScriptDir%\TEST_������˻���.txt
}
