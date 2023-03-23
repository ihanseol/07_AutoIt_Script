#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt('MouseClickDragDelay',0)

HotKeySet("{UP}","up")
HotKeySet("{DOWN}","down")
HotKeySet("{LEFT}","left")
HotKeySet("{RIGHT}","right")
HotKeySet("{esc}","esc")
HotKeySet("{F9}","ext")
HotKeySet("{SPACE}","space")

$delay=150

Func up()
	MouseClickDrag("left",300,300,300,100,0)
	MouseMove(300,300,0)
EndFunc

Func down()
	MouseClickDrag("left",300,300,300,500,0)
	MouseMove(300,300,0)
EndFunc

Func left()
	MouseClickDrag("left",300,300,100,300,0)
	MouseMove(300,300,0)
	Sleep($delay)
EndFunc

Func right()
	MouseClickDrag("left",300,300,500,300,0)
	MouseMove(300,300,0)
	Sleep($delay)
EndFunc

Func esc()
	MouseMove(20, 20, 0)
	MouseClick("left")
EndFunc

Func ext()
	Exit
EndFunc

Func space()
	MouseClick("left", 300, 300, 2)
EndFunc


While 1
	Sleep(100)
	If Not ProcessExists("Subway_Surfers.exe") Then Exit
WEnd