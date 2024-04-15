;����: https://www.the-automator.com/excel-and-autohotkey/  ��

{ ; ��� ���� Excel Function  ���
	First_Row_original(xlname){  ; �� ù���(����) : First_Row(��ü��)
	   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
	}
	
	First_Row(xlname){  ; �� Used ù��� : First_Row(��ü��)
	   Loop { ; Used���� ù���� ���� �ƴ϶�� ���� (�ڷ�����)
			if (xlname.Cells(A_index, First_Col_Num(xlname)).value <> ""){
				end_numbers := A_index  ; ������ Row ����
				break
			}
		}
		return end_numbers
	}
	
	Last_Row(xlname){  ; �� ������ ��� (����): Last_Row(��ü��)
		if  (Last_Row_original(xlname)=1) or (Last_Row_original(ex)=1)
			return 1
		var:=xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
		Loop { ; Used ����  7�� �� ��  ������� ���� ���� �ִٸ�  ���߰�  ��� ��ȯ
			if (xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,1).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,2).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,3).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,4).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,5).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,6).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,7).value <>""){
				end_numbers := var - A_index  + 1 ; ������ Row ����
				break
			}
		}
		return end_numbers
	}


	Last_Row_original(xlname){  ; �� ������ ��� (����): Last_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
	}
	
	Used_Row(xlname){  ; �� Used��� : Used_Row(��ü��)
		return xlname.ActiveSheet.UsedRange.Rows.Count
	}
	
	First_Col_Num(xlname){ ; �� ù��° Į�� number
	   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
	}
	
	Last_Col_Num(xlname){ ; �� ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
	}
	
	Used_Col_Num(xlname){ ; �� Used ������ Į��  number
		return xlname.ActiveSheet.UsedRange.Columns.Count 
	}
	
	First_Col(xlname){  ; �� ù��° Į��  alpabet
		FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
			Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
	}
	
	; �� ���� ���� : 1�̸�  ó������, 0�̸� ��� ����
	Used_Rng(xlname,Header=1){   ; Used_Rng(ex,1) ; Use header to include first row
		if(Last_Row_original(xlname)=1)
			return xlname.Range("1:1")  ; �̰� ....
	IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
	IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
	}
	
	Last_Col(xlname){ ; �� ������ Į�� alpabet : Last_Col(��ü��)
		LastCol:=Last_Col_Num(xlname)	 ; + First_Col_num(xlname) -1
		IfLessOrEqual,LastCol,26, Return, (Chr(64+LastCol))
			Else IfGreater,LastCol,26, return, Chr((LastCol-1)/26+64) . Chr(mod((LastCol- 1),26)+65)
	}
	
		
	;***********************alpha to Number********************************.
	String_To_Number(Column){ ;~ String_To_Number("ab")
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
	
	; �� ���� ����� �� EndRows(ex, 1) ; 1��(A)�� �����
	EndRows(ByRef xlname, ByRef col_num=1){
		num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; ������ �����
		Loop {
			if (xlname.Cells(num - A_index, col_num).value <> ""){
				end_numbers := num - A_index  ; ������ Row ����
				break
			}
		}
		return end_numbers
	}
}
