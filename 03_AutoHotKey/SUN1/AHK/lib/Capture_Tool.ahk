﻿if((A_PtrSize=8&&A_IsCompiled="")||!A_IsUnicode){ ;32 bit=4  ;64 bit=8
 SplitPath,A_AhkPath,,dir
 if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
  MsgBox error
  ExitApp
 }
 Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
 ExitApp
 return
}
#SingleInstance, Force
#NoEnv
;#Include Tesseract.ahk
/*  ; Credits   I borrowed heavily from ...
Learning one :=Screen Clippling  https://autohotkey.com/boards/viewtopic.php?f=6&t=12088
*/
;~ #NoTrayIcon
;~ Menu, tray, icon, AutoRun\camera.ico , 1
#Lbutton::SCW_ScreenClip2Win(clip:=1,email:=0)  ; Win+left click =auto copy to clipboard
#^Lbutton::SCW_ScreenClip2Win(clip:=0,email:=0) ; Win+Control+Left click- no copy to clipboard
;~ #!Lbutton::SCW_ScreenClip2Win(clip:=0,email:=1) ; Wind+Alt+left click =saves images and attach to email (path of jpg on clipboard)

;********************After clip exists***********************************
#IfWinActive, ScreenClippingWindow ahk_class AutoHotkeyGUI
^c::SCW_Win2Clipboard(0)  ; copy selected win to clipboard  Change to (1) if want border
^s:: SCW_Win2File(0)  ; save selected clipping on desktop as timestamp named .png  ; this was submited by tervon
^t:: ;Perform OCR on image
pToken := Gdip_Startup()
Tesseract:=new Tesseract()
pBitmap := Gdip_CreateBitmapFromClipboard() ;store pointer to image from clipboard
text:=Tesseract.OCR(pBitmap)  process image
Tesseract:=""
Gdip_Shutdown(pToken)
MsgBox % Clipboard:=Text
Reload
return

Esc:: winclose, A ;contribued by tervon
;~ Rbutton:: winclose, A ;contributed by tervon
#IfWinActive

;===Functions===========================================
SCW_Version() {
  return 1.02
}

SCW_DestroyAllClipWins() {
 MaxGuis := SCW_Reg("MaxGuis"), StartAfter := SCW_Reg("StartAfter")
 Loop, %MaxGuis%
 {
  StartAfter++
  Gui %StartAfter%: Destroy
 }
}

SCW_SetUp(Options="") {
 if !(Options = "")
 {
   Loop, Parse, Options, %A_Space%
   {
     Field := A_LoopField
     DotPos := InStr(Field, ".")
     if (DotPos = 0)
      Continue
      var := SubStr(Field, 1, DotPos-1)
      val := SubStr(Field, DotPos+1)
      if var in StartAfter,MaxGuis,AutoMonitorWM_LBUTTONDOWN,DrawCloseButton,BorderAColor,BorderBColor,SelColor,SelTrans
      %var% := val
     }
  }

   SCW_Default(StartAfter,80), SCW_Default(MaxGuis,6)
   SCW_Default(AutoMonitorWM_LBUTTONDOWN,1), SCW_Default(DrawCloseButton,0)
   SCW_Default(BorderAColor,"ff6666ff"), SCW_Default(BorderBColor,"ffffffff")
   SCW_Default(SelColor,"Yellow"), SCW_Default(SelTrans,80)

   SCW_Reg("MaxGuis", MaxGuis), SCW_Reg("StartAfter", StartAfter), SCW_Reg("DrawCloseButton", DrawCloseButton)
   SCW_Reg("BorderAColor", BorderAColor), SCW_Reg("BorderBColor", BorderBColor)
   SCW_Reg("SelColor", SelColor), SCW_Reg("SelTrans",SelTrans)
   SCW_Reg("WasSetUp", 1)
   if AutoMonitorWM_LBUTTONDOWN
   OnMessage(0x201, "SCW_LBUTTONDOWN")
}

SCW_ScreenClip2Win(clip=0,email=0) {
   static c
   if !(SCW_Reg("WasSetUp"))
   SCW_SetUp()

   StartAfter := SCW_Reg("StartAfter"), MaxGuis := SCW_Reg("MaxGuis"), SelColor := SCW_Reg("SelColor"), SelTrans := SCW_Reg("SelTrans")
   c++
   if (c > MaxGuis)
   c := 1

   GuiNum := StartAfter + c
   Area := SCW_SelectAreaMod("g" GuiNum " c" SelColor " t" SelTrans)
   StringSplit, v, Area, |
   if (v3 < 10 and v4 < 10)   ; too small area
   return

   pToken := Gdip_Startup()
   if pToken =
   {
      MsgBox, 64, GDI+ error, GDI+ failed to start. Please ensure you have GDI+ on your system.
      return
   }

   Sleep, 100
   ;~ MsgBox % Clipboard:=Area
   pBitmap := Gdip_BitmapFromScreen(Area)

if (email=1){
;**********************Added to automatically save to bmp*********************************
File1:=A_ScriptDir . "\example.BMP" ;path to file to save (make sure uppercase extenstion.  see below for options
Gdip_SaveBitmapToFile(pBitmap, File1) ;Exports automatcially to file

File2:=A_ScriptDir . "\example.JPG" ;path to file to save (make sure uppercase extenstion.  see below for options
Gdip_SaveBitmapToFile(pBitmap, File2) ;Exports automatcially to file
Clipboard:=File2

;**********************make sure outlook is running so email will be sent*********************************
Process, Exist, Outlook.exe    ; check to see if Outlook is running.
   Outlook_pid=%errorLevel%         ; errorlevel equals the PID if active
If (Outlook_pid = 0)   { ;
run outlook.exe
WinWait, Microsoft Outlook, ,3
}
;~ MsgBox here 1
;**********************Write email*********************************
olMailItem := 0
try
    IsObject(MailItem := ComObjActive("Outlook.Application").CreateItem(olMailItem)) ; Get the Outlook application object if Outlook is open
catch
    MailItem  := ComObjCreate("Outlook.Application").CreateItem(olMailItem) ; Create if Outlook is not open

olFormatHTML := 2
MailItem.BodyFormat := olFormatHTML
;~ MailItem.TO := (MailTo)
;~ MailItem.CC :="glines@ti.com"
FormatTime, TodayDate , YYYYMMDDHH24MISS, dddd MMMM d, yyyy h:mm:ss tt
MailItem.Subject :="Screen shot taken : " (TodayDate) ;Subject line of email

MailItem.HTMLBody := "
<H2 style='BACKGROUND-COLOR: red'><br></H2>
<HTML>Attached you will find the screenshot taken on "(TodayDate)" <br><br>
<span style='color:black'>Please let me know if you have any questions.<br><br><a href='mailto:Joe@the-Automator.com'>Joe Glines</a> <br>682.209.8014
</HTML>"
MailItem.Attachments.Add(File1)
MailItem.Attachments.Add(File2)
MailItem.Display ;
Reload
}

;*******************************************************
   SCW_CreateLayeredWinMod(GuiNum,pBitmap,v1,v2, SCW_Reg("DrawCloseButton"))
   Gdip_Shutdown("pToken")
if clip=1
{
 ;********************** added to copy to clipboard by default*********************************
   WinActivate, ScreenClippingWindow ahk_class AutoHotkeyGUI ;activates last clipped window
   SCW_Win2Clipboard(0)  ;copies to clipboard by default w/o border
;~ MsgBox on clipboard
;*******************************************************
}
}

SCW_SelectAreaMod(Options="") {
   CoordMode, Mouse, Screen
   MouseGetPos, MX, MY
      loop, parse, Options, %A_Space%
   {
      Field := A_LoopField
      FirstChar := SubStr(Field,1,1)
      if FirstChar contains c,t,g,m
      {
         StringTrimLeft, Field, Field, 1
         %FirstChar% := Field
      }
   }
   c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g
   Gui %g%: Destroy
   Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound -DPIScale ;provided from rommmcek 10/23/16

   WinSet, Transparent, %t%
   Gui %g%: Color, %c%
   Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
   While, (GetKeyState(Hotkey, "p"))
   {
      Sleep, 10
      MouseGetPos, MXend, MYend
      w := abs(MX - MXend), h := abs(MY - MYend)
      X := (MX < MXend) ? MX : MXend
      Y := (MY < MYend) ? MY : MYend
      Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
   }
   Gui %g%: Destroy
   MouseGetPos, MXend, MYend
   If ( MX > MXend )
   temp := MX, MX := MXend, MXend := temp
   If ( MY > MYend )
   temp := MY, MY := MYend, MYend := temp
   Return MX "|" MY "|" w "|" h
}

SCW_CreateLayeredWinMod(GuiNum,pBitmap,x,y,DrawCloseButton=0) {
   static CloseButton := 16
   BorderAColor := SCW_Reg("BorderAColor"), BorderBColor := SCW_Reg("BorderBColor")

   Gui %GuiNum%: -Caption +E0x80000 +LastFound +ToolWindow +AlwaysOnTop +OwnDialogs
   Gui %GuiNum%: Show, Na, ScreenClippingWindow
   hwnd := WinExist()

   Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
   hbm := CreateDIBSection(Width+6, Height+6), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
   G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)

   Gdip_DrawImage(G, pBitmap, 3, 3, Width, Height)
   Gdip_DisposeImage(pBitmap)

   pPen1 := Gdip_CreatePen("0x" BorderAColor, 3), pPen2 := Gdip_CreatePen("0x" BorderBColor, 1)
   if DrawCloseButton
   {
      Gdip_DrawRectangle(G, pPen1, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
      Gdip_DrawRectangle(G, pPen2, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
   }
   Gdip_DrawRectangle(G, pPen1, 1, 1, Width+3, Height+3)
   Gdip_DrawRectangle(G, pPen2, 1, 1, Width+3, Height+3)
   Gdip_DeletePen(pPen1), Gdip_DeletePen(pPen2)

   UpdateLayeredWindow(hwnd, hdc, x-3, y-3, Width+6, Height+6)
   SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
   SCW_Reg("G" GuiNum "#HWND", hwnd)
   SCW_Reg("G" GuiNum "#XClose", Width+6-CloseButton)
   SCW_Reg("G" GuiNum "#YClose", CloseButton)
   Return hwnd
}

SCW_LBUTTONDOWN() {
   MouseGetPos,,, WinUMID
    WinGetTitle, Title, ahk_id %WinUMID%
   if Title = ScreenClippingWindow
   {
      PostMessage, 0xA1, 2,,, ahk_id %WinUMID%
      KeyWait, Lbutton
      CoordMode, mouse, Relative
      MouseGetPos, x,y
     XClose := SCW_Reg("G" A_Gui "#XClose"), YClose := SCW_Reg("G" A_Gui "#YClose")
      if (x > XClose and y < YClose)
      Gui %A_Gui%: Destroy
      return 1   ; confirm that click was on module's screen clipping windows
   }
}

SCW_Reg(variable, value="") {
   static
   if (value = "") {
      yaqxswcdevfr := kxucfp%variable%pqzmdk
      Return yaqxswcdevfr
   }
   Else
   kxucfp%variable%pqzmdk = %value%
}

SCW_Default(ByRef Variable,DefaultValue) {
   if (Variable="")
   Variable := DefaultValue
}

SCW_Win2Clipboard(KeepBorders=0) {
   /*   ;   does not work for layered windows
   ActiveWinID := WinExist("A")
   pBitmap := Gdip_BitmapFromHWND(ActiveWinID)
   Gdip_SetBitmapToClipboard(pBitmap)
   */
   Send, !{PrintScreen} ; Active Win's client area to Clipboard
   if !KeepBorders
   {
      pToken := Gdip_Startup()
      pBitmap := Gdip_CreateBitmapFromClipboard()
      Gdip_GetDimensions(pBitmap, w, h)
      pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
      Gdip_SetBitmapToClipboard(pBitmap2)
      Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
      Gdip_Shutdown("pToken")
   }
}

SCW_CropImage(pBitmap, x, y, w, h) {
   pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
   Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
   Gdip_DeleteGraphics(G2)
   return pBitmap2
}

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255){
 if ((x != "") && (y != ""))
  VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)

 if (w = "") ||(h = "")
  WinGetPos,,, w, h, ahk_id %hwnd%

 return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
 , "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}



BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster=""){
 return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh
 , "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}


StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster=""){
 return DllCall("gdi32\StretchBlt", "uint", ddc, "int", dx, "int", dy, "int", dw, "int", dh
 , "uint", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}


SetStretchBltMode(hdc, iStretchMode=4){
 return DllCall("gdi32\SetStretchBltMode", "uint", hdc, "int", iStretchMode)
}


SetImage(hwnd, hBitmap){
 SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
 E := ErrorLevel
 DeleteObject(E)
 return E
}

SetSysColorToControl(hwnd, SysColor=15){
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor)
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}


Gdip_BitmapFromScreen(Screen=0, Raster=""){
 if (Screen = 0)
 {
  Sysget, x, 76
  Sysget, y, 77
  Sysget, w, 78
  Sysget, h, 79
 }
 else if (Screen&1 != "")
 {
  Sysget, M, Monitor, %Screen%
  x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
 }
 else
 {
  StringSplit, S, Screen, |
  x := S1, y := S2, w := S3, h := S4
 }

 if (x = "") || (y = "") || (w = "") || (h = "")
  return -1

 chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := GetDC()
 BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
 ReleaseDC(hhdc)

 pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
 SelectObject(hhdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
 return pBitmap
}


Gdip_BitmapFromHWND(hwnd){
 WinGetPos,,, Width, Height, ahk_id %hwnd%
 hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
 PrintWindow(hwnd, hdc)
 pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
 SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
 return pBitmap
}

CreateRectF(ByRef RectF, x, y, w, h){
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}

CreateSizeF(ByRef SizeF, w, h){
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")
}

CreatePointF(ByRef PointF, x, y){
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")
}

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0){
 hdc2 := hdc ? hdc : GetDC()
 VarSetCapacity(bi, 40, 0)
 NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
 hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)

 If !hdc
  ReleaseDC(hdc2)
 return hbm
}

PrintWindow(hwnd, hdc, Flags=0){
 return DllCall("PrintWindow", "uint", hwnd, "uint", hdc, "uint", Flags)
}

DestroyIcon(hIcon){
   return DllCall("DestroyIcon", "uint", hIcon)
}

PaintDesktop(hdc){
 return DllCall("PaintDesktop", "uint", hdc)
}

CreateCompatibleBitmap(hdc, w, h){
 return DllCall("gdi32\CreateCompatibleBitmap", "uint", hdc, "int", w, "int", h)
}

CreateCompatibleDC(hdc=0){
   return DllCall("CreateCompatibleDC", "uint", hdc)
}

SelectObject(hdc, hgdiobj){
   return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}

DeleteObject(hObject){
   return DllCall("DeleteObject", "uint", hObject)
}

GetDC(hwnd=0){
 return DllCall("GetDC", "uint", hwnd)
}

ReleaseDC(hdc, hwnd=0){
   return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}

DeleteDC(hdc){
   return DllCall("DeleteDC", "uint", hdc)
}

Gdip_LibraryVersion(){
 return 1.38
}

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0){
 if !BRAFromMemIn
  return -1
 Loop, Parse, BRAFromMemIn, `n
 {
  if (A_Index = 1)
  {
   StringSplit, Header, A_LoopField, |
   if (Header0 != 4 || Header2 != "BRA!")
    return -2
  }
  else if (A_Index = 2)
  {
   StringSplit, Info, A_LoopField, |
   if (Info0 != 3)
    return -3
  }
  else
   break
 }
 if !Alternate
  StringReplace, File, File, \, \\, All
 RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
 if !FileInfo
  return -4

 hData := DllCall("GlobalAlloc", "uint", 2, "uint", FileInfo2)
 pData := DllCall("GlobalLock", "uint", hData)
 DllCall("RtlMoveMemory", "uint", pData, "uint", &BRAFromMemIn+Info2+FileInfo1, "uint", FileInfo2)
 DllCall("GlobalUnlock", "uint", hData)
 DllCall("ole32\CreateStreamOnHGlobal", "uint", hData, "int", 1, "uint*", pStream)
 DllCall("gdiplus\GdipCreateBitmapFromStream", "uint", pStream, "uint*", pBitmap)
 DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
 return pBitmap
}

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h){
   return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r){
 Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
 E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
 Gdip_ResetClip(pGraphics)
 Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
 Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
 Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
 Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
 Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
 Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
 Gdip_ResetClip(pGraphics)
 return E
}

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h){
   return DllCall("gdiplus\GdipDrawEllipse", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4){
   return DllCall("gdiplus\GdipDrawBezier", "uint", pgraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2
   , "float", x3, "float", y3, "float", x4, "float", y4)
}


Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle){
   return DllCall("gdiplus\GdipDrawArc", "uint", pGraphics, "uint", pPen, "float", x
   , "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle){
   return DllCall("gdiplus\GdipDrawPie", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}


Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2){
   return DllCall("gdiplus\GdipDrawLine", "uint", pGraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2)
}

Gdip_DrawLines(pGraphics, pPen, Points){
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipDrawLines", "uint", pGraphics, "uint", pPen, "uint", &PointF, "int", Points0)
}

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h){
   return DllCall("gdiplus\GdipFillRectangle", "uint", pGraphics, "int", pBrush
   , "float", x, "float", y, "float", w, "float", h)
}

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r){
 Region := Gdip_GetClipRegion(pGraphics)
 Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
 Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
 E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
 Gdip_SetClipRegion(pGraphics, Region, 0)
 Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
 Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
 Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
 Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
 Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
 Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
 Gdip_SetClipRegion(pGraphics, Region, 0)
 Gdip_DeleteRegion(Region)
 return E
}

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0){
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipFillPolygon", "uint", pGraphics, "uint", pBrush, "uint", &PointF, "int", Points0, "int", FillMode)
}

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle){
   return DllCall("gdiplus\GdipFillPie", "uint", pGraphics, "uint", pBrush
   , "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h){
 return DllCall("gdiplus\GdipFillEllipse", "uint", pGraphics, "uint", pBrush, "float", x, "float", y, "float", w, "float", h)
}

Gdip_FillRegion(pGraphics, pBrush, Region){
 return DllCall("gdiplus\GdipFillRegion", "uint", pGraphics, "uint", pBrush, "uint", Region)
}

Gdip_FillPath(pGraphics, pBrush, Path){
 return DllCall("gdiplus\GdipFillPath", "uint", pGraphics, "uint", pBrush, "uint", Path)
}

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1){
 StringSplit, Points, Points, |
 VarSetCapacity(PointF, 8*Points0)
 Loop, %Points0%
 {
  StringSplit, Coord, Points%A_Index%, `,
  NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
 }

 if (Matrix&1 = "")
  ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
 else if (Matrix != 1)
  ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

 if (sx = "" && sy = "" && sw = "" && sh = "")
 {
  sx := 0, sy := 0
  sw := Gdip_GetImageWidth(pBitmap)
  sh := Gdip_GetImageHeight(pBitmap)
 }

 E := DllCall("gdiplus\GdipDrawImagePointsRect", "uint", pGraphics, "uint", pBitmap
 , "uint", &PointF, "int", Points0, "float", sx, "float", sy, "float", sw, "float", sh
 , "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
 if ImageAttr
  Gdip_DisposeImageAttributes(ImageAttr)
 return E
}

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1){
 if (Matrix&1 = "")
  ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
 else if (Matrix != 1)
  ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

 if (sx = "" && sy = "" && sw = "" && sh = "")
 {
  if (dx = "" && dy = "" && dw = "" && dh = "")
  {
   sx := dx := 0, sy := dy := 0
   sw := dw := Gdip_GetImageWidth(pBitmap)
   sh := dh := Gdip_GetImageHeight(pBitmap)
  }
  else
  {
   sx := sy := 0
   sw := Gdip_GetImageWidth(pBitmap)
   sh := Gdip_GetImageHeight(pBitmap)
  }
 }

 E := DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
 , "float", dx, "float", dy, "float", dw, "float", dh
 , "float", sx, "float", sy, "float", sw, "float", sh
 , "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
 if ImageAttr
  Gdip_DisposeImageAttributes(ImageAttr)
 return E
}

Gdip_SetImageAttributesColorMatrix(Matrix){
 VarSetCapacity(ColourMatrix, 100, 0)
 Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
 StringSplit, Matrix, Matrix, |
 Loop, 25
 {
  Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
  NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
 }
 DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
 DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
 return ImageAttr
}

Gdip_GraphicsFromImage(pBitmap){
    DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
    return pGraphics
}

Gdip_GraphicsFromHDC(hdc){
    DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
    return pGraphics
}

Gdip_GetDC(pGraphics){
 DllCall("gdiplus\GdipGetDC", "uint", pGraphics, "uint*", hdc)
 return hdc
}

Gdip_ReleaseDC(pGraphics, hdc){
 return DllCall("gdiplus\GdipReleaseDC", "uint", pGraphics, "uint", hdc)
}

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff){
    return DllCall("gdiplus\GdipGraphicsClear", "uint", pGraphics, "int", ARGB)
}

Gdip_BlurBitmap(pBitmap, Blur){
 if (Blur > 100) || (Blur < 1)
  return -1

 sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
 dWidth := sWidth//Blur, dHeight := sHeight//Blur

 pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
 G1 := Gdip_GraphicsFromImage(pBitmap1)
 Gdip_SetInterpolationMode(G1, 7)
 Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

 Gdip_DeleteGraphics(G1)

 pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
 G2 := Gdip_GraphicsFromImage(pBitmap2)
 Gdip_SetInterpolationMode(G2, 7)
 Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

 Gdip_DeleteGraphics(G2)
 Gdip_DisposeImage(pBitmap1)
 return pBitmap2
}

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=100){
 SplitPath, sOutput,,, Extension
 if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
  return -1
 Extension := "." Extension

 DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
 VarSetCapacity(ci, nSize)
 DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
 if !(nCount && nSize)
  return -2

 Loop, %nCount%
 {
  Location := NumGet(ci, 76*(A_Index-1)+44)
  if !A_IsUnicode
  {
   nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
   VarSetCapacity(sString, nSize)
   DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
   if !InStr(sString, "*" Extension)
    continue
  }
  else
  {
   nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
   sString := ""
   Loop, %nSize%
    sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
   if !InStr(sString, "*" Extension)
    continue
  }
  pCodec := &ci+76*(A_Index-1)
  break
 }
 if !pCodec
  return -3

 if (Quality != 75)
 {
  Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
  if Extension in .JPG,.JPEG,.JPE,.JFIF
  {
   DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
   VarSetCapacity(EncoderParameters, nSize, 0)
   DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
   Loop, % NumGet(EncoderParameters)      ;%
   {
    if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
    {
       p := (28*(A_Index-1))+&EncoderParameters
       NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
       break
    }
   }
   }
 }

 if !A_IsUnicode
 {
  nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
  VarSetCapacity(wOutput, nSize*2)
  DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
  VarSetCapacity(wOutput, -1)
  if !VarSetCapacity(wOutput)
   return -4
  E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
 }
 else
  E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
 return E ? -5 : 0
}

Gdip_GetPixel(pBitmap, x, y){
 DllCall("gdiplus\GdipBitmapGetPixel", "uint", pBitmap, "int", x, "int", y, "uint*", ARGB)
 return ARGB
}

Gdip_SetPixel(pBitmap, x, y, ARGB){
   return DllCall("gdiplus\GdipBitmapSetPixel", "uint", pBitmap, "int", x, "int", y, "int", ARGB)
}

Gdip_GetImageWidth(pBitmap){
   DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
   return Width
}

Gdip_GetImageHeight(pBitmap){
   DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
   return Height
}

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height){
 Width := Gdip_GetImageWidth(pBitmap)
 Height := Gdip_GetImageHeight(pBitmap)
}

Gdip_GetImagePixelFormat(pBitmap){
 DllCall("gdiplus\GdipGetImagePixelFormat", "uint", pBitmap, "uint*", Format)
 return Format
}

Gdip_GetDpiX(pGraphics){
 DllCall("gdiplus\GdipGetDpiX", "uint", pGraphics, "float*", dpix)
 return Round(dpix)
}

Gdip_GetDpiY(pGraphics){
 DllCall("gdiplus\GdipGetDpiY", "uint", pGraphics, "float*", dpiy)
 return Round(dpiy)
}

Gdip_GetImageHorizontalResolution(pBitmap){
 DllCall("gdiplus\GdipGetImageHorizontalResolution", "uint", pBitmap, "float*", dpix)
 return Round(dpix)
}

Gdip_GetImageVerticalResolution(pBitmap){
 DllCall("gdiplus\GdipGetImageVerticalResolution", "uint", pBitmap, "float*", dpiy)
 return Round(dpiy)
}

Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize=""){
 SplitPath, sFile,,, ext
 if ext in exe,dll
 {
  Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
  VarSetCapacity(buf, 40)
  Loop, Parse, Sizes, |
  {
   DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, "uint*", hIcon, "uint*", 0, "uint", 1, "uint", 0)
   if !hIcon
    continue

   if !DllCall("GetIconInfo", "uint", hIcon, "uint", &buf)
   {
    DestroyIcon(hIcon)
    continue
   }
   hbmColor := NumGet(buf, 16)
   hbmMask  := NumGet(buf, 12)

   if !(hbmColor && DllCall("GetObject", "uint", hbmColor, "int", 24, "uint", &buf))
   {
    DestroyIcon(hIcon)
    continue
   }
   break
  }
  if !hIcon
   return -1

  Width := NumGet(buf, 4, "int"),  Height := NumGet(buf, 8, "int")
  hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)

  if !DllCall("DrawIconEx", "uint", hdc, "int", 0, "int", 0, "uint", hIcon, "uint", Width, "uint", Height, "uint", 0, "uint", 0, "uint", 3)
  {
   DestroyIcon(hIcon)
   return -2
  }

  VarSetCapacity(dib, 84)
  DllCall("GetObject", "uint", hbm, "int", 84, "uint", &dib)
  Stride := NumGet(dib, 12), Bits := NumGet(dib, 20)

  DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "uint", Bits, "uint*", pBitmapOld)
  pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap)
  Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
  SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
  Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
  DestroyIcon(hIcon)
 }
 else
 {
  if !A_IsUnicode
  {
   VarSetCapacity(wFile, 1023)
   DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sFile, "int", -1, "uint", &wFile, "int", 512)
   DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &wFile, "uint*", pBitmap)
  }
  else
   DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &sFile, "uint*", pBitmap)
 }
 return pBitmap
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0){
 DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
 return pBitmap
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff){
 DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
 return hbm
}

Gdip_CreateBitmapFromHICON(hIcon){
 DllCall("gdiplus\GdipCreateBitmapFromHICON", "uint", hIcon, "uint*", pBitmap)
 return pBitmap
}

Gdip_CreateHICONFromBitmap(pBitmap){
 DllCall("gdiplus\GdipCreateHICONFromBitmap", "uint", pBitmap, "uint*", hIcon)
 return hIcon
}

Gdip_CreateBitmap(Width, Height, Format=0x26200A){
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
    Return pBitmap
}

Gdip_CreateBitmapFromClipboard(){
 if !DllCall("OpenClipboard", "uint", 0)
  return -1
 if !DllCall("IsClipboardFormatAvailable", "uint", 8)
  return -2
 if !hBitmap := DllCall("GetClipboardData", "uint", 2)
  return -3
 if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
  return -4
 if !DllCall("CloseClipboard")
  return -5
 DeleteObject(hBitmap)
 return pBitmap
}

Gdip_SetBitmapToClipboard(pBitmap){
 hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
 DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
 hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
 pdib := DllCall("GlobalLock", "uint", hdib)
 DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
 DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
 DllCall("GlobalUnlock", "uint", hdib)
 DllCall("DeleteObject", "uint", hBitmap)
 DllCall("OpenClipboard", "uint", 0)
 DllCall("EmptyClipboard")
 DllCall("SetClipboardData", "uint", 8, "uint", hdib)
 DllCall("CloseClipboard")
}

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A){
 DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h
 , "int", Format, "uint", pBitmap, "uint*", pBitmapDest)
 return pBitmapDest
}

Gdip_CreatePen(ARGB, w){
   DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
   return pPen
}

Gdip_CreatePenFromBrush(pBrush, w){
 DllCall("gdiplus\GdipCreatePen2", "uint", pBrush, "float", w, "int", 2, "uint*", pPen)
 return pPen
}

Gdip_BrushCreateSolid(ARGB=0xff000000){
 DllCall("gdiplus\GdipCreateSolidFill", "int", ARGB, "uint*", pBrush)
 return pBrush
}

Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0){
 DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "int", ARGBfront, "int", ARGBback, "uint*", pBrush)
 return pBrush
}
Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h=""){
 if !(w && h)
  DllCall("gdiplus\GdipCreateTexture", "uint", pBitmap, "int", WrapMode, "uint*", pBrush)
 else
  DllCall("gdiplus\GdipCreateTexture2", "uint", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "uint*", pBrush)
 return pBrush
}

Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1){
 CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
 DllCall("gdiplus\GdipCreateLineBrush", "uint", &PointF1, "uint", &PointF2, "int", ARGB1, "int", ARGB2, "int", WrapMode, "uint*", LGpBrush)
 return LGpBrush
}

Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1){
 CreateRectF(RectF, x, y, w, h)
 DllCall("gdiplus\GdipCreateLineBrushFromRect", "uint", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "uint*", LGpBrush)
 return LGpBrush
}

Gdip_CloneBrush(pBrush){
 static pNewBrush
 VarSetCapacity(pNewBrush, 288, 0)
 DllCall("RtlMoveMemory", "uint", &pNewBrush, "uint", pBrush, "uint", 288)
 VarSetCapacity(pNewBrush, -1)
 return &pNewBrush
}

Gdip_DeletePen(pPen){
   return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}

Gdip_DeleteBrush(pBrush){
   return DllCall("gdiplus\GdipDeleteBrush", "uint", pBrush)
}

Gdip_DisposeImage(pBitmap){
   return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}

Gdip_DeleteGraphics(pGraphics){
   return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}

Gdip_DisposeImageAttributes(ImageAttr){
 return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}

Gdip_DeleteFont(hFont){
   return DllCall("gdiplus\GdipDeleteFont", "uint", hFont)
}

Gdip_DeleteStringFormat(hFormat){
   return DllCall("gdiplus\GdipDeleteStringFormat", "uint", hFormat)
}

Gdip_DeleteFontFamily(hFamily){
   return DllCall("gdiplus\GdipDeleteFontFamily", "uint", hFamily)
}

Gdip_DeleteMatrix(Matrix){
   return DllCall("gdiplus\GdipDeleteMatrix", "uint", Matrix)
}

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0){
 IWidth := Width, IHeight:= Height

 RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
 RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
 RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
 RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
 RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
 RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
 RegExMatch(Options, "i)R(\d)", Rendering)
 RegExMatch(Options, "i)S(\d+)(p*)", Size)

 if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
  PassBrush := 1, pBrush := Colour2

 if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
  return -1

 Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
 Loop, Parse, Styles, |
 {
  if RegExMatch(Options, "\b" A_loopField)
  Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
 }

 Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
 Loop, Parse, Alignments, |
 {
  if RegExMatch(Options, "\b" A_loopField)
   Align |= A_Index//2.1      ; 0|0|1|1|2|2
 }

 xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
 ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
 Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
 Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
 if !PassBrush
  Colour := "0x" (Colour2 ? Colour2 : "ff000000")
 Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
 Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

 hFamily := Gdip_FontFamilyCreate(Font)
 hFont := Gdip_FontCreate(hFamily, Size, Style)
 hFormat := Gdip_StringFormatCreate(0x4000)
 pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
 if !(hFamily && hFont && hFormat && pBrush && pGraphics)
  return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0

 CreateRectF(RC, xpos, ypos, Width, Height)
 Gdip_SetStringFormatAlign(hFormat, Align)
 Gdip_SetTextRenderingHint(pGraphics, Rendering)
 ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

 if vPos
 {
  StringSplit, ReturnRC, ReturnRC, |

  if (vPos = "vCentre") || (vPos = "vCenter")
   ypos += (Height-ReturnRC4)//2
  else if (vPos = "Top") || (vPos = "Up")
   ypos := 0
  else if (vPos = "Bottom") || (vPos = "Down")
   ypos := Height-ReturnRC4

  CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
  ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
 }

 if !Measure
  E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

 if !PassBrush
  Gdip_DeleteBrush(pBrush)
 Gdip_DeleteStringFormat(hFormat)
 Gdip_DeleteFont(hFont)
 Gdip_DeleteFontFamily(hFamily)
 return E ? E : ReturnRC
}

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF){
 if !A_IsUnicode
 {
  nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
  VarSetCapacity(wString, nSize*2)
  DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
  return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
  , "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
 }
 else
 {
  return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
  , "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
 }
}

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF){
 VarSetCapacity(RC, 16)
 if !A_IsUnicode
 {
  nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
  VarSetCapacity(wString, nSize*2)
  DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
  DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
  , "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
 }
 else
 {
  DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
  , "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
 }
 return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

Gdip_SetStringFormatAlign(hFormat, Align){
   return DllCall("gdiplus\GdipSetStringFormatAlign", "uint", hFormat, "int", Align)
}

Gdip_StringFormatCreate(Format=0, Lang=0){
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, "uint*", hFormat)
   return hFormat
}

Gdip_FontCreate(hFamily, Size, Style=0){
   DllCall("gdiplus\GdipCreateFont", "uint", hFamily, "float", Size, "int", Style, "int", 0, "uint*", hFont)
   return hFont
}

Gdip_FontFamilyCreate(Font){
 if !A_IsUnicode
 {
  nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", 0, "int", 0)
  VarSetCapacity(wFont, nSize*2)
  DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", &wFont, "int", nSize)
  DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &wFont, "uint", 0, "uint*", hFamily)
 }
 else
  DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &Font, "uint", 0, "uint*", hFamily)
 return hFamily
}

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y){
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "uint*", Matrix)
   return Matrix
}

Gdip_CreateMatrix(){
   DllCall("gdiplus\GdipCreateMatrix", "uint*", Matrix)
   return Matrix
}

Gdip_CreatePath(BrushMode=0){
 DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "uint*", Path)
 return Path
}

Gdip_AddPathEllipse(Path, x, y, w, h){
 return DllCall("gdiplus\GdipAddPathEllipse", "uint", Path, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(Path, Points){
 StringSplit, Points, Points, |
 VarSetCapacity(PointF, 8*Points0)
 Loop, %Points0%
 {
  StringSplit, Coord, Points%A_Index%, `,
  NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
 }

 return DllCall("gdiplus\GdipAddPathPolygon", "uint", Path, "uint", &PointF, "int", Points0)
}

Gdip_DeletePath(Path){
 return DllCall("gdiplus\GdipDeletePath", "uint", Path)
}
Gdip_SetTextRenderingHint(pGraphics, RenderingHint){
 return DllCall("gdiplus\GdipSetTextRenderingHint", "uint", pGraphics, "int", RenderingHint)
}

Gdip_SetInterpolationMode(pGraphics, InterpolationMode){
   return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}

Gdip_SetSmoothingMode(pGraphics, SmoothingMode){
   return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}

Gdip_SetCompositingMode(pGraphics, CompositingMode=0){
   return DllCall("gdiplus\GdipSetCompositingMode", "uint", pGraphics, "int", CompositingMode)
}

Gdip_Startup(){
 if !DllCall("GetModuleHandle", "str", "gdiplus")
  DllCall("LoadLibrary", "str", "gdiplus")
 VarSetCapacity(si, 16, 0), si := Chr(1)
 DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
 return pToken
}

Gdip_Shutdown(pToken){
 DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
 if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
  DllCall("FreeLibrary", "uint", hModule)
 return 0
}

Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0){
 return DllCall("gdiplus\GdipRotateWorldTransform", "uint", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0){
 return DllCall("gdiplus\GdipScaleWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0){
 return DllCall("gdiplus\GdipTranslateWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics){
 return DllCall("gdiplus\GdipResetWorldTransform", "uint", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation){
 pi := 3.14159, TAngle := Angle*(pi/180)

 Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
 if ((Bound >= 0) && (Bound <= 90))
  xTranslation := Height*Sin(TAngle), yTranslation := 0
 else if ((Bound > 90) && (Bound <= 180))
  xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
 else if ((Bound > 180) && (Bound <= 270))
  xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
 else if ((Bound > 270) && (Bound <= 360))
  xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight){
 pi := 3.14159, TAngle := Angle*(pi/180)
 if !(Width && Height)
  return -1
 RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
 RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0){
   return DllCall("gdiplus\GdipSetClipRect", "uint", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0){
   return DllCall("gdiplus\GdipSetClipPath", "uint", pGraphics, "uint", Path, "int", CombineMode)
}

Gdip_ResetClip(pGraphics){
   return DllCall("gdiplus\GdipResetClip", "uint", pGraphics)
}

Gdip_GetClipRegion(pGraphics){
 Region := Gdip_CreateRegion()
 DllCall("gdiplus\GdipGetClip", "uint" pGraphics, "uint*", Region)
 return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0){
 return DllCall("gdiplus\GdipSetClipRegion", "uint", pGraphics, "uint", Region, "int", CombineMode)
}

Gdip_CreateRegion(){
 DllCall("gdiplus\GdipCreateRegion", "uint*", Region)
 return Region
}

Gdip_DeleteRegion(Region){
 return DllCall("gdiplus\GdipDeleteRegion", "uint", Region)
}

;***********Function by Tervon*******************
SCW_Win2File(KeepBorders=0) {
   Send, !{PrintScreen} ; Active Win's client area to Clipboard
   sleep 50
   if !KeepBorders
   {
    pToken := Gdip_Startup()
    pBitmap := Gdip_CreateBitmapFromClipboard()
    Gdip_GetDimensions(pBitmap, w, h)
    pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
    /*
    ;~ File2:=A_Desktop . "\" . A_Now . ".PNG" ; tervon  time /path to file to save
    ;~ FormatTime, TodayDate , YYYYMMDDHH24MISS, MM_dd_yy @h_mm_ss ;This is Joe's time format
    FormatTime, TodayDate , YYYYMMDDHH24MISS, yyMMdd_HHmms ;This is Joe's time format
    File2:=A_Desktop . "\" . TodayDate . ".PNG" ;path to file to save
    */
    FormatTime, TodayDate , YYYYMMDDHH24MISS, yyMMdd_mms ;This is Joe's time format
    File2:=A_Desktop . "\" . TodayDate . ".PNG" ;path to file to save
    Gdip_SaveBitmapToFile(pBitmap2, File2) ;Exports automatcially to file
    Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
    Gdip_Shutdown("pToken")
   }
}



; ■■■■
class Tesseract 
{
;********************jg added- wait for file to exist***********************************
	static leptonica := A_ScriptDir "\bin\leptonica_util\leptonica_util.exe"
	static tesseract := A_ScriptDir "\bin\tesseract\tesseract.exe"
	static tessdata_best := A_ScriptDir "\bin\tesseract\tessdata_best"
	static tessdata_fast := A_ScriptDir "\bin\tesseract\tessdata_fast"
	static file := A_ScriptDir "\mcoc_screenshot.bmp"
	static fileProcessedImage := A_ScriptDir "\mcoc_preprocess.tif"
	static fileConvertedText := A_ScriptDir "\mcoc_text.txt"
	
	; OCR() can be called directly
	OCR(pBitmap, language:="", options:="")
	{
		this.language := language
		imgFile:= this.toFile(pBitmap, this.file)
		this.preprocess(imgFile, this.fileProcessedImage)
		this.convert_best(this.fileProcessedImage, this.fileConvertedText, 0, options)
		return this.read(), this.cleanup()
	}
	
	; toFile() - Saves the image as a temporary file.
	toFile(image, outputFile:="")
	{
		Gdip_SaveBitmapToFile(image, outputFile)
		While ! FileExist(outputFile) ;Added by Joe Glines on 9/21/2019
			Sleep, 100 ;Added by Joe Glines on 9/21/2019
		return outputFile
	}
	
	__New(language:="", options:="")
	{
		this.language := language
	}
	
	cleanup()
	{
		FileDelete, % this.file
		FileDelete, % this.fileProcessedImage
		FileDelete, % this.fileConvertedText
	}
	
	convert_best(in:="", out:="", fast:=0, options:="")
	{
		in := (in) ? in : this.fileProcessedImage
		out := (out) ? out : this.fileConvertedText
		fast := (fast) ? this.tessdata_fast : this.tessdata_best
		
		if !(FileExist(in))
			throw Exception("Input image for conversion not found.",, in)
		
		if !(FileExist(this.tesseract))
			throw Exception("Tesseract not found",, this.tesseract)
		
		static q := Chr(0x22)
		_cmd .= q this.tesseract q " --tessdata-dir " q fast q " " q in q " " q SubStr(out, 1, -4) q 
		_cmd .= (options) ? options : " -psm 6"
		_cmd .= (this.language) ? " -l " q this.language q : ""
		_cmd := ComSpec " /C " q _cmd q
		
		;~ msgbox % _cmd
		RunWait % _cmd,, Hide
		
		if !(FileExist(out))
			throw Exception("Tesseract failed.",, _cmd)
		
		return out
	}
	
	convert_fast(in:="", out:="")
	{
		return this.convert_best(in, out, 1)
	}
	
	
	preprocess(in:="", out:="")
	{
		static LEPT_TRUE 				:= ocrPreProcessing := 1
		static negateArg 				:= 2 ; 0=NEGATE_NO,   /* Do not negate image */  1=NEGATE_YES,  /* Force negate */  2=NEGATE_AUTO, /* Automatically negate if border pixels are dark */
		static dark_bg_threshold 		:= 0.5 ; /* From 0.0 to 1.0, with 0 being all white and 1 being all black */
		static performScaleArg 			:= LEPT_TRUE ; true/false
		static scaleFactor 				:= 3.5 ;
		static perform_unsharp_mask 	:= LEPT_TRUE ;
		static usm_halfwidth 			:= 5 ;
		static usm_fract 				:= 2.5 ;
		static perform_otsu_binarize	:= LEPT_TRUE ;
		static otsu_sx					:= 2000 ;
		static otsu_sy					:= 2000 ;
		static otsu_smoothx				:= 0 ;
		static otsu_smoothy				:= 0 ;
		static otsu_scorefract   		:= 0.0 ;
		static q := Chr(0x22)
		
		in := (in != "") ? in : this.file
		out := (out != "") ? out : this.fileProcessedImage
		
		if !(FileExist(in))
			throw Exception("Input image for preprocessing not found.",, in)
		
		if !(FileExist(this.leptonica))
			throw Exception("Leptonica not found",, this.leptonica)
		
		_cmd .= q this.leptonica q " " q in q " " q out q
		
		_cmd .= " " negateArg " " dark_bg_threshold 
			.	" " performScaleArg " " scaleFactor 
			.	" " perform_unsharp_mask " " usm_halfwidth " " usm_fract 
			.	" " perform_otsu_binarize  " " otsu_sx " " otsu_sy " " otsu_smoothx " " otsu_smoothy " " otsu_scorefract
		
		_cmd := ComSpec " /C " q _cmd q
		
		; leptonica_util.exe in.png out.png  2 0.5  1 3.5  1 5 2.5  1 2000 2000 0 0 0.0  1 */
		RunWait, % _cmd,, Hide
		
		if !(FileExist(out))
			throw Exception("Preprocessing failed.",, _cmd)
		
		return out
	}
	
	read(in:="", lines:="")
	{
		in := (in) ? in : this.fileConvertedText
		database := FileOpen(in, "r`n", "UTF-8")
		
		if (lines == "") 
		{
			text := RegExReplace(database.Read(), "^\s*(.*?)\s*$", "$1")
			text := RegExReplace(text, "(?<!\r)\n", "`r`n")
		} 
		else
		{
			while (lines > 0) 
			{
				data := database.ReadLine()
				data := RegExReplace(data, "^\s*(.*?)\s*$", "$1")
				if (data != "") 
				{
					text .= (text) ? ("`n" . data) : data
					lines--
				}
				if (!database || database.AtEOF)
					break
			}
		}
		database.Close()
		return text
	}
	
	readlines(lines)
	{
		return this.read(, lines)
	}
}
