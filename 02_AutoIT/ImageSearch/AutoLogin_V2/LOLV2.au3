#include  <ImageSearch.au3>
HotKeySet("{f1}","endapp")
$x=0
$y=0
$id = FileReadLine("id.txt")
$pass = FileReadLine("password.txt")
$path = FileReadLine("path.txt")
Run($path)
Sleep(500)
WinActivate("League of Legends")

while(1)
   WinActivate("League of Legends")
   $Search = _ImageSearch("pix.png", 0, $x, $y,0)
   if $Search = 1 Then
	  startapp()
   Else
	 WinActivate("League of Legends")
  EndIf
WEnd

Func startapp()
   WinActivate("League of Legends")
   Sleep(200)
   MouseMove($x,$y+100,1)
   Sleep(200)
   MouseClick("primary")
   MouseClick("primary")
   Send("{BACKSPACE}")
   Sleep(100)
   Send($id)
   Sleep(120)
   Send("{TAB}")
   Send($pass)
   Sleep(120)
   Send("{ENTER}")
   Sleep(500)
   endapp()
EndFunc

Func endapp()
   Exit
EndFunc


