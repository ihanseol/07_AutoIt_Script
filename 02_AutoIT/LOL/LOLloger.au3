
HotKeySet("{f1}", "konec")
$pass = FileReadLine("password.txt")
$id= FileReadLine("id.txt")
$path = FileReadLine("path.txt")


Run($path)
AutoItSetOption("MouseCoordMode", 0)


Sleep(1000)
WinWait("League of Legends")
while (1)
   WinMove("League of Legends","",0,0)
   WinActivate("League of Legends")
   $cords = PixelSearch(1084, 185, 1155, 245, 0x000306,10)
   if not (@error) then
	 inf()
   Else
	  WinActivate("League of Legends")
   EndIf
WEnd
Func inf()
   WinActivate("League of Legends")
   Sleep(200)
   ConsoleWrite("ahoj")
   MouseClick("primary", $cords[0], $cords[1],2,1)
   Sleep(100)
   MouseClick("primary")
    ConsoleWrite("ahoj2")
   MouseClick("primary")
    ConsoleWrite("ahoj3")
   Send("{BACKSPACE}")
   Sleep(100)
   Send($id)
   Sleep(50)
   Send("{TAB}")
   Send($pass)
   Sleep(30)
   Send("{ENTER}")

   PixelSearch(1064, 124, 1144, 161,0xF0E6D2,5)
   if not (@error) Then
	  Sleep(1000)
	  konec()
   Else
	  inf2()
   EndIf

EndFunc

Func inf2()
    WinActivate("League of Legends")
   Sleep(1000)
   MouseClick("left", $cords[0], $cords[1],2,1)
   Sleep(100)
   MouseClick("left")

   MouseClick("left")
   Send("{BACKSPACE}")
   Send($id)
   Sleep(50)
   Send("{TAB}")
   Send($pass)
   Sleep(30)
   Send("{ENTER}")
   PixelSearch(1064, 124, 1144, 161,0xF0E6D2,5)
   if not (@error) Then
	  konec()
   Else
	  inf2()
   EndIf
EndFunc


Func konec()
   Exit
EndFunc
