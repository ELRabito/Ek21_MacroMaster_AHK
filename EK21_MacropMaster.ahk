; ##########################################
; ##########################################
; MACROPAD MASTER SCRIPT - ULTRA EDITION
; Modifiers: Shift (via VIA), F23 (Phys.), F24 (Phys.)
; ##########################################
; ##########################################

; Defines
global margin := 7
InstallKeybdHook
SetTitleMatchMode 2
#UseHook

; --- HUD INIT ---
HUD := Gui("+AlwaysOnTop -Caption +ToolWindow")
HUD.SetFont("s10 w700 cWhite", "Segoe UI")
HUDText := HUD.Add("Text", "Center w220", "")
guiWidth := 220
xPos := (A_ScreenWidth / 2) - (guiWidth / 2)

; Modifier HUD
ShowHUD(txt, color) {
    HUD.BackColor := color
    HUDText.Value := txt
    HUD.Show("x" xPos " y0 w" guiWidth " NoActivate")
}

; Feedback HUD
FlashHUD(txt, color) {
    HUD.BackColor := color
    HUDText.Value := txt
    HUD.Show("x" xPos " y0 w" guiWidth " NoActivate")
    SetTimer () => HUD.Hide(), -1000 ; Dissapears after 1 second
}

; ##########################################
; ##########################################
; LAYER 1: NORMAL (Halves & Maximize)
; ##########################################
; ##########################################

; Shift + F13: Snap LEFT Half
$+F13::
{
    WinRestore "A"
    WinMove -margin, 0, 1280 + (2 * margin), A_ScreenHeight - 40, "A"
    FlashHUD("SNAP: LEFT HALF", "2D2D2D")
}

; Shift + F14: Maximize Window
$+F14::
{
    WinMaximize "A"
    FlashHUD("WINDOW: MAXIMIZED", "2D2D2D")
}

; Shift + F15: Snap RIGHT Half
$+F15::
{
    WinRestore "A"
    WinMove 1280 - margin, 0, 1280 + (2 * margin), A_ScreenHeight - 40, "A"
    FlashHUD("SNAP: RIGHT HALF", "2D2D2D")
}

; Shift + F16: Transparency Toggle
$+F16::
{
    try {
        currentTrans := WinGetTransparent("A")
        newTrans := (currentTrans = 128) ? 255 : 128
        WinSetTransparent newTrans, "A"
        FlashHUD("GHOST MODE: " . (newTrans = 128 ? "ON" : "OFF"), "4B0082")
    } catch {
        WinSetTransparent 128, "A"
        FlashHUD("GHOST MODE: ON", "4B0082")
    }
}

; --- F17: Smart Close ---
$+F17::
{
    activeProcess := WinGetProcessName("A")
	FlashHUD("Closed", "8B0000")
    if (activeProcess ~= "i)firefox.exe|notepad\+\+\.exe|chrome.exe")
        Send "^w"
    else if (activeProcess = "Explorer.EXE")
        Send "!{F4}"
    else
        ;ProcessClose activeProcess
		WinClose "A"
}

; --- F18: Smart foobar2000 ---
$+F18::
{
    FlashHUD("APP: FOOBAR2000", "2E8B57")
    if WinExist("ahk_exe foobar2000.exe")
        WinActivate
    else {
        Run "foobar2000.exe"
        if WinWait("ahk_exe foobar2000.exe", , 2) {
            WinRestore "ahk_exe foobar2000.exe"
            WinMove (A_ScreenWidth-1600)/2, (A_ScreenHeight-900)/2, 1600, 900, "ahk_exe foobar2000.exe"
        }
    }
}

; --- F19: Smart Explorer ---
$+F19::
{
    FlashHUD("APP: EXPLORER", "0078D7")
    if WinExist("ahk_class CabinetWClass")
        WinActivate
    else
        Run "explorer.exe"
}

; --- F20: Smart Firefox ---
$+F20::
{
    FlashHUD("APP: FIREFOX", "E66000")
    if WinExist("ahk_exe firefox.exe")
        WinActivate
    else {
        KeyWait "F20"
        Sleep 100
        Run "firefox.exe"
    }
}

; --- F21: Smart Downloads ---
$+F21::
{
    FlashHUD("FOLDER: DOWNLOADS", "0078D7")
    if WinExist("Downloads ahk_class CabinetWClass")
        WinActivate
    else
        Run "explorer.exe shell:Downloads"
}

; ##########################################
; ##########################################
; LAYER 2: F23-MODIFIER (Thirds-Splits)
; ##########################################
; ##########################################

#HotIf GetKeyState("F23", "P")

$+F13:: ; Snap LEFT Third
{
    WinRestore "A"
    WinMove -margin, 0, 853 + (2 * margin), A_ScreenHeight - 40, "A"
    FlashHUD("SNAP: LEFT THIRD", "005A9E")
}

$+F14:: ; Snap CENTER Third
{
    WinRestore "A"
    WinMove 853 - margin, 0, 854 + (2 * margin), A_ScreenHeight - 40, "A"
    FlashHUD("SNAP: CENTER THIRD", "005A9E")
}

$+F15:: ; Snap RIGHT Third
{
    WinRestore "A"
    WinMove 1707 - margin, 0, 853 + (2 * margin), A_ScreenHeight - 40, "A"
    FlashHUD("SNAP: RIGHT THIRD", "005A9E")
}

$+F16:: ; Smart Search
{
    A_Clipboard := ""
    Send "^c"
    if ClipWait(1) {
        searchQuery := StrReplace(A_Clipboard, " ", "+")
        FlashHUD("SEARCH: GOOGLE", "4285F4")
        Run "firefox.exe https://www.google.com/search?q=" . searchQuery
    }
}


$+F17:: ; Filter Explorer (Current Window Priority)
{
    A_Clipboard := ""
    Send "^c"
    ClipWait(0.5)

    if WinExist("ahk_class CabinetWClass") 
    {
        WinActivate "ahk_class CabinetWClass"
        if WinWaitActive("ahk_class CabinetWClass", , 1) {
            Send "{f3}"
            Sleep 200
            if (A_Clipboard != "") {
                Send "^v{Enter}"
                FlashHUD("FILTERING CURRENT WINDOW", "0078D7")
            } else {
                FlashHUD("SEARCH MODE", "0078D7")
            }
        }
    } 
    else 
    {
        Run "explorer.exe"
        if WinWaitActive("ahk_class CabinetWClass", , 2) {
            Sleep 600
            if (A_Clipboard != "") {
                Send "{f3}"
                Sleep 200
                Send "^v{Enter}"
                FlashHUD("OPEN & FILTER", "0078D7")
            }
        }
    }
}

$+F18:: ; Smart YouTube
{
    FlashHUD("APP: YOUTUBE", "FF0000")
    if WinExist("YouTube")
        WinActivate
    else {
        KeyWait "F18"
        Sleep 100
        Run "firefox.exe https://www.youtube.com"
    }
}

#HotIf

; ##########################################
; ##########################################
; LAYER 3: F24-MODIFIER
; ##########################################
; ##########################################

#HotIf GetKeyState("F24", "P")

$+F13:: ; Center 1600x900
{
    WinRestore "A"
    WinMove (A_ScreenWidth-1600)/2, (A_ScreenHeight-900)/2, 1600, 900, "A"
    FlashHUD("MODE: CENTER 1600p", "D4A017")
}

$+F14:: ; Focus Mode (Large Center)
{
    WinRestore "A"
    WinMove (A_ScreenWidth-2000)/2, (A_ScreenHeight-1200)/2, 2000, 1200, "A"
    FlashHUD("MODE: FOCUS 2000p", "D4A017")
}

$+F15:: ; Picture-in-Picture Toggle
{
    ExStyle := WinGetExStyle("A")
    if (ExStyle & 0x8) {
        WinSetAlwaysOnTop 0, "A"
        WinMaximize "A" 
        FlashHUD("PiP: OFF", "D4A017")
    } else {
        WinRestore "A"
        WinSetAlwaysOnTop 1, "A"
        WinMove A_ScreenWidth-650, A_ScreenHeight-400-40, 650, 400, "A"
        FlashHUD("PiP: ON", "D4A017")
    }
}

$+F16:: ; Smart Explorer - ARMA
{
    FlashHUD("FOLDER: ARMA PROJECT", "7B904B")
    if WinExist("Arma ahk_class CabinetWClass")
        WinActivate
    else
        Run 'explorer.exe "G:\Arma"'
}

$+F17:: ; Same-App-Hopper
{
    activeProc := WinGetProcessName("A")
    FlashHUD("HOP: " . activeProc, "D4A017")
    searchTarget := (activeProc = "Explorer.EXE") ? "ahk_class CabinetWClass" : "ahk_exe " activeProc
    ids := WinGetList(searchTarget)
    if (ids.Length > 1) {
        WinMoveBottom("A")
        for id in ids {
            if (id = ids[1])
                continue
            if (WinGetStyle("ahk_id " id) & 0x10000000) {
                WinActivate("ahk_id " id)
                break
            }
        }
    }
}

$+F18:: ; Copy Current Explorer Path
{
    if WinActive("ahk_class CabinetWClass") {
        Send "^l"
        Sleep 50
        Send "^c"
        Sleep 50
        Send "{Esc}"
        FlashHUD("PATH COPIED", "0078D7")
    }
}

#HotIf

; ##########################################
; HELPERS & MODIFIER HUD
; ##########################################

*F23::
{
    ShowHUD("LAYER 2: THIRDS", "005A9E")
    KeyWait "F23"
    HUD.Hide()
}

*F24::
{
    ShowHUD("LAYER 3: POWER", "D4A017")
    KeyWait "F24"
    HUD.Hide()
}
