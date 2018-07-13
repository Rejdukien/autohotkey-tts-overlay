; ========================================

JoinArray(Arr, Glue) {
    FinalString := ""
    
    Loop % Arr.Length() {
        FinalString .= Arr[A_Index] . Glue
    }
    
    Return SubStr(FinalString, 1, StrLen(FinalString) - 1)
}

GetComboBoxChoice(TheList, TheCurrent) {
    Loop % TheList.Length() {
        If (TheCurrent == TheList[A_Index]) {
            TheCurrent := A_Index
            Break
        }
    }
    TheList := JoinArray(TheList, "|")
    
    Return {"Index": TheCurrent, "Choices": TheList}
}