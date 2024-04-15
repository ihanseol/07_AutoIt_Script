;참고: https://www.the-automator.com/excel-and-autohotkey/  등

{ ; ■■ 엑셀 Excel Function  ■■
	First_Row_original(xlname){  ; ■ 첫행수(원래) : First_Row(객체명)
	   Return, xlname.Application.ActiveSheet.UsedRange.Rows(1).Row
	}
	
	First_Row(xlname){  ; ■ Used 첫행수 : First_Row(객체명)
	   Loop { ; Used열의 첫행은 빈셀이 아니라는 전제 (자료있음)
			if (xlname.Cells(A_index, First_Col_Num(xlname)).value <> ""){
				end_numbers := A_index  ; 마지막 Row 갯수
				break
			}
		}
		return end_numbers
	}
	
	Last_Row(xlname){  ; ■ 마지막 행수 (원본): Last_Row(객체명)
		if  (Last_Row_original(xlname)=1) or (Last_Row_original(ex)=1)
			return 1
		var:=xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
		Loop { ; Used 끝행  7개 셀 중  비어있지 않은 셀이 있다면  멈추고  행수 반환
			if (xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,1).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,2).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,3).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,4).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,5).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,6).value <>"" or xlname.Cells(var - A_index + 1, First_Col_Num(xlname)).Offset(0,7).value <>""){
				end_numbers := var - A_index  + 1 ; 마지막 Row 갯수
				break
			}
		}
		return end_numbers
	}


	Last_Row_original(xlname){  ; ■ 마지막 행수 (원본): Last_Row(객체명)
		return xlname.ActiveSheet.UsedRange.Rows.Count + xlname.Application.ActiveSheet.UsedRange.Rows(1).Row - 1
	}
	
	Used_Row(xlname){  ; ■ Used행수 : Used_Row(객체명)
		return xlname.ActiveSheet.UsedRange.Rows.Count
	}
	
	First_Col_Num(xlname){ ; ■ 첫번째 칼럼 number
	   Return, xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
	}
	
	Last_Col_Num(xlname){ ; ■ 마지막 칼럼  number
		return xlname.ActiveSheet.UsedRange.Columns.Count + xlname.Application.ActiveSheet.UsedRange.Columns(1).Column - 1
	}
	
	Used_Col_Num(xlname){ ; ■ Used 마지막 칼럼  number
		return xlname.ActiveSheet.UsedRange.Columns.Count 
	}
	
	First_Col(xlname){  ; ■ 첫번째 칼럼  alpabet
		FirstCol:=xlname.Application.ActiveSheet.UsedRange.Columns(1).Column
		IfLessOrEqual,LastCol,26, Return, (Chr(64+FirstCol))
			Else IfGreater,LastCol,26, return, Chr((FirstCol-1)/26+64) . Chr(mod((FirstColn- 1),26)+65)
	}
	
	; ■ 사용된 범위 : 1이면  처음부터, 0이면 헤더 제외
	Used_Rng(xlname,Header=1){   ; Used_Rng(ex,1) ; Use header to include first row
		if(Last_Row_original(xlname)=1)
			return xlname.Range("1:1")  ; 이게 ....
	IfEqual,Header,1,Return, xlname.Range(First_Col(xlname) . First_Row(xlname) ":" Last_Col(xlname) . Last_Row(xlname))
	IfEqual,Header,0,Return, xlname.Range(First_Col(xlname) . First_Row(xlname)+1 ":" Last_Col(xlname) . Last_Row(xlname))
	}
	
	Last_Col(xlname){ ; ■ 마지막 칼럼 alpabet : Last_Col(객체명)
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
	
	; ■ 열의 끝행수 → EndRows(ex, 1) ; 1열(A)의 끝행수
	EndRows(ByRef xlname, ByRef col_num=1){
		num:=xlname.ActiveSheet.UsedRange.Rows.Count + First_Row(xlname) ; 사용범위 끝행수
		Loop {
			if (xlname.Cells(num - A_index, col_num).value <> ""){
				end_numbers := num - A_index  ; 마지막 Row 갯수
				break
			}
		}
		return end_numbers
	}
}
