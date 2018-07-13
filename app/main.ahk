#NoEnv
#NoTrayIcon
#KeyHistory 0
#SingleInstance force

DetectHiddenWindows, On
SetWorkingDir, %A_ScriptDir%
ListLines, Off

#Include tts.ahk
#Include utility.ahk

AppVersion := "1.2.1"
AppTitle := "AHK Text to Speech v" . AppVersion

AudioTextHistory := []
TTSInstance := new TTS()


GUI1:
    Gui, Font, s10, Segoe UI
    
    Gui, Add, Text, w70 h24 x10 y14, Output:
    Gui, Add, DropDownList, w310 x80 y10 vAudioOutput
    Temp := GetComboBoxChoice(TTSInstance.GetAudioOutputs(), TTSInstance.GetCurrentAudioOutput())
    GuiControl, , AudioOutput, % Temp["Choices"]
    GuiControl, Choose, AudioOutput, % Temp["Index"]
    
    Gui, Add, Text, w70 h24 x10 y44, Voice:
    Gui, Add, DropDownList, w310 x80 y40 vAudioVoice
    Temp := GetComboBoxChoice(TTSInstance.GetAudioVoices(), TTSInstance.GetCurrentAudioVoice())
    GuiControl, , AudioVoice, % Temp["Choices"]
    GuiControl, Choose, AudioVoice, % Temp["Index"]
    
    Gui, Add, Text, w70 h24 x10 y74, Volume:
    Gui, Add, Slider, w310 h24 x80 y70 vAudioVolume Range0-100 TickInterval10, 100
    
    Gui, Add, Text, w70 h24 x10 y104, Rate:
    Gui, Add, Slider, w115 h24 x80 y100 vAudioRate Range-10-10 TickInterval2, 0
    
    Gui, Add, Text, w70 h24 x205 y104, Pitch:
    Gui, Add, Slider, w115 h24 x275 y100 vAudioPitch Range-10-10 TickInterval2, 0
    
    Gui, Add, Text, w70 h24 x10 y134, Test Text:
    Gui, Add, ComboBox, w310 h24 x80 y130 r5 vAudioText, Hello world
    GuiControl, Choose, AudioText, 1
    
    Gui, Add, Button, Default Center w380 h30 x10 y164 gExecuteSubmit, Speak

    Gui, Add, Text, w380 h24 x10 y200, Hotkey Configuration (ALT, SHIFT, and/or CTRL plus Key)
    Gui, Add, Hotkey, vKeyCombo x10 y224 w240 h24 Limit1, Reee
    Gui, Add, Button, w130 h24 x260 y224 gSetupKey, Set Key Combo
      
    Gui, Add, StatusBar, , Ready
    
    Temp := ""
    Gui, Show, Center w400, %AppTitle%
    
    GuiControl, Focus, AudioText
Return

; ========================================

ExecuteSubmit:
    Gui, Submit, NoHide
    
    If (AudioText != "") {
        Speak(AudioOutput
            , AudioVoice
            , AudioText
            , AudioRate
            , AudioVolume
            , AudioPitch)
    }
Return

SetupKey:
    Gui, Submit, NoHide
    If OldHotkey !=
        Hotkey, %OldHotkey%, Off
    If KeyCombo !=
        Hotkey, %KeyCombo%, ExecuteHotkey, On
    OldHotkey := KeyCombo
Return


Speak(AudioOutput, AudioVoice, AudioText, AudioRate, AudioVolume, AudioPitch) {
    global TTSInstance
	TTSInstance.SetCurrentAudioOutput(AudioOutput)
	TTSInstance.SetCurrentAudioVoice(AudioVoice)
	TTSInstance.Speak(AudioText
		, AudioRate
		, AudioVolume
		, AudioPitch)
	
	AudioText := SpeechPath
	AudioVolume := "1.0"
}


ExecuteHotkey:
    Gosub, InitGUI2
	inputText:=""
	Loop
	{
		Input, in, L1, {Enter}{Backspace}{Escape}
		EL=%ErrorLevel%
		if EL = EndKey:Enter
        {
            break
        }
        else if EL = EndKey:BackSpace
        {
			inputText:=SubStr(inputText, 1, StrLen(inputText)-1)
        }
        else if EL = EndKey:Escape
        {
            inputText:=""
            break
        }
		inputText.=in
        GuiControl, 2:    , HotkeyText, %inputText%_
	}
	
	If (inputText != "") {
		Gui, Submit, NoHide
        Speak(AudioOutput
            , AudioVoice
            , inputText
            , AudioRate
            , AudioVolume
            , AudioPitch)
    }
    Gosub, CloseGUI2
Return

InitGUI2:
    gui_w := A_ScreenWidth
    text_w := A_ScreenWidth - 40

    gui_y := A_ScreenHeight - 115 - 50

    Gui, 2:+AlwaysOnTop -Caption +Owner +LastFound +Border +E0x20
    hwndGUI2 := WinExist()
    Gui, 2:Margin, 20, 0
    Gui, 2:Color, Black
    Gui, 2:Font, cWhite w700 s30, Arial
    Gui, 2:Add, Text, +Center xm ym w%text_w% h115 vHotkeyText, _
    WinSet, Transparent, 200, ahk_id %hwndGUI2%

    Gui, 2:Show, NoActivate x0 y%gui_y% h115 w%gui_w%
Return

CloseGUI2:
    Gui, 2:Destroy
Return

OnExit, GuiClose

GuiClose:
    ExitApp
Return