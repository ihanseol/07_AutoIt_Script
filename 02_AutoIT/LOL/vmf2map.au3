#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>

If $CmdLine[0]="" Then
$gui=1
#Region ### START Koda GUI section ###
$Form = GUICreate(" VMF ==> MAP", 402, 155, -1, -1)
GUICtrlCreateLabel(.vmf file", 8, 9, 44, 17)
$Choose = GUICtrlCreateButton("Choose file", 56, 3, 75, 25)
$vmf_lbl = GUICtrlCreateInput("", 136, 6, 257, 21)
GUICtrlCreateLabel(".map file", 8, 41, 47, 17)
$Save = GUICtrlCreateButton("Save to", 56, 35, 75, 25)
$map_lbl = GUICtrlCreateInput("", 136, 38, 257, 21)
$Convert = GUICtrlCreateButton("Convert", 8, 80, 387, 25)
$Progress = GUICtrlCreateProgress(8, 112, 387, 17)
GUICtrlCreateLabel("COPYRIGHT 2013 BY DEMBA //github.com/demba003", 168, 136, 229, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Choose
			$vmf_file = FileOpenDialog("Choose .vmf file","",".vmf files (*.vmf)","","",$Form)
			GUICtrlSetData($vmf_lbl, $vmf_file)
		Case $Save
			$map_file = FileSaveDialog("Saving location for .map file","",".map files (*.map)","","",$Form)
			If Not StringInStr($map_file,".map") Then
			If Not $map_file="" Then $map_file = $map_file & ".map"
			EndIf
			GUICtrlSetData($map_lbl, $map_file)
		Case $Convert
			If GUICtrlRead($vmf_lbl)<>"" And GUICtrlRead($map_lbl)<>"" Then
			Convert(GUICtrlRead($vmf_lbl), GUICtrlRead($map_lbl))
			EndIf
	EndSwitch
WEnd
Else
$gui=0
If StringInStr($CmdLine[1],".vmf") Then
Convert($CmdLine[1],StringReplace($CmdLine[1],".vmf",".map"))
Else
MsgBox(0,"Error","Bad file")
EndIf
EndIf

Func Convert($vmf, $map)
	If $gui=1 Then GUICtrlSetData($Progress,0)
	$vmf_content=FileRead($vmf)
	$vmf_content = StringReplace($vmf_content,'}'&@CRLF&@TAB&@TAB&'side'&@CRLF&@TAB&@TAB&'{',"</side>"&@CRLF&@TAB&@TAB&"<side>")
	$vmf_content = StringReplace($vmf_content,'side'&@CRLF&@TAB&@TAB&'{',"<side>")
	$vmf_content = StringReplace($vmf_content,'}'&@CRLF&@TAB&@TAB&'editor'&@CRLF&@TAB&@TAB&'{',"</side>"&@CRLF&"editor"&@CRLF&"{")

	$vmf_content = StringRegExpReplace($vmf_content,'(?s)//(.*?)\r\n',"")
	$vmf_content = StringRegExpReplace($vmf_content,'(?s)versioninfo(.*?)}',"")
	$vmf_content = StringRegExpReplace($vmf_content,'(?s)cameras(.*?)}(.*?)}',"")
	$vmf_content = StringRegExpReplace($vmf_content,'(?s)viewsettings(.*?)}',"")
	$vmf_content = StringReplace($vmf_content,"visgroups"&@CRLF&"{"&@CRLF&"}","")
	$vmf_content = StringRegExpReplace($vmf_content,'(?s)entity(.*?)}',"")

	$vmf_content = StringReplace($vmf_content,'}'&@CRLF&@CRLF&'}'&@CRLF&@CRLF&'}'&@CRLF&@CRLF,"")

	$vmf_content = StringReplace($vmf_content,'solid'&@CRLF&@TAB&'{',"<solid>")
	$vmf_content = StringReplace($vmf_content,'}'&@CRLF&'}',"}")
	$vmf_content = StringReplace($vmf_content,'}',"</solid>")

	$vmf_content = StringRegExpReplace($vmf_content,'(?s)editor(.*?)}',"")

$solid_content = _StringBetween($vmf_content,"<solid>","</solid>")

$solids = ""

For $i=0 To UBound($solid_content)-1
	$side_content = _StringBetween($solid_content[$i],"<side>","</side>")
	$solids = $solids & "{" & @CRLF
	For $j=0 To UBound($side_content)-1
	$side_content[$j] = StringRegExpReplace($side_content[$j], '\Q"id" "\E\d*"',"")
	$side_content[$j] = StringReplace($side_content[$j], '"plane" "',"")
	$side_content[$j] = StringReplace($side_content[$j], '"',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'material',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'uaxis',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'vaxis',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'rotation',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'lightmapscale',"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF&@TAB&@TAB&@TAB&'smoothing_groups',"")
	$side_content[$j] = StringReplace($side_content[$j], @TAB,"")
	$side_content[$j] = StringReplace($side_content[$j], @CRLF,"")
	$side_content[$j] = StringReplace($side_content[$j], '0.250000',"")

	$solids = $solids & $side_content[$j] & @CRLF
	Next
	$solids = $solids & @CRLF & "}" & @CRLF

Next
FileWrite($map,'{'&@CRLF&'"classname" "worldspawn"'&@CRLF&'"MaxRange" "4096"'&@CRLF&'"mapversion" "1"'&@CRLF&'"wad" "wad" "\valve\cstrike\cstrike.wad;\valve\valve\halflife.wad"'&@CRLF& $solids & '}' & @CRLF)
If $gui=1 Then GUICtrlSetData($Progress,100)
MsgBox(0,"Info","Conversion completed!")
EndFunc
