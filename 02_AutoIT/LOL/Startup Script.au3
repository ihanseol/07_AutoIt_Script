#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Vehemos

 Script Function:
	Setup my startup environment (Google Chrome)

#ce ----------------------------------------------------------------------------
; Script Start -
#include <Array.au3>
Local $chrome_visit[6] = ["India", "gmail.com", "linkedin.com", "quora.com", "github.com", "fb.com"]
$mouse_click_button = "primary"				;	"" OR "left" are same, can be used with "primary" for right handed/swap cases
$chrome_pos_x = 467 					;	X coordinate of Google Chrome on my taskbar
$chrome_pos_y = 750 					;	Y oordinate of Google Chrome on my taskbar
#cs---------------------------------------------------------------------------
   Instead of using XY coords of Google Chrome I can also use win10 search to
   search "Google Chrome" and start it via there, it is more foolproof(Portable)
   but also more slower as win10 search is ... _/\_
   I can also run chrome from the installed directory, the most foolproof way
   will be to use windows run (Win+R) and enter chrome.exe
   But I won't do all that as I want people who blindly copy paste to suffer :P
#ce---------------------------------------------------------------------------
MouseClick ( $mouse_click_button, $chrome_pos_x, $chrome_pos_y, 1, 0 )
WinWait ( "New Tab - Google Chrome" )
WinActivate ( "New Tab - Google Chrome" )
For $i in $chrome_visit
   Send ( $i & "{ENTER}^t" )
   WinWait ( "New Tab - Google Chrome" )
   Next
