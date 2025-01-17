#Requires AutoHotkey v2.0
#SingleInstance Force
#Include lib\Classy_GUI.ahk
#NoTrayIcon

if (!A_IsCompiled) {
    TraySetIcon("lib\icon.ico")
}


lcdGen()

lcdGen() {

    rowCount := 8
    columnCount := 5
    
    lightColor := "Background" "c5c5c5"
    darkColor := "Background" "525252"

    gui1 := Classy_GUI(, "LCD Character Generator")

    gui1.Classy_Options("hk af fm")
    gui1.Classy_Sizer(677, 579, 1394, 1112)
    gui1.Classy_Font(10, 8, 20, 4)

    sb := gui1.Classy_Add("StatusBar",, "Ctrl -/+ to adjust font size")

    g_hexString := gui1.Classy_Add("GroupBox", "Center c000000", "Hex Sting",,, 0, "f2", 1, "f")
    g_varString := gui1.Classy_Add("GroupBox", "Center c000000", "Var Sting",,, 0, "f", 1, "f")

    g_Char := gui1.Classy_Add("GroupBox", "Center c000000", "Character",,, 0, 0, 2/5, g_hexString)

    g_clip := gui1.Classy_Add("GroupBox", "Center c000000", "Clipboard",,, g_Char, 0, 1/5, "f")

    g_var := gui1.Classy_Add("GroupBox", "Center c000000", "Var",,, g_clip,, 1, "f")

    g_binStream := gui1.Classy_Add("GroupBox", "Center c000000", "Bin Stream",,, g_Char, g_var, 1/3, 1/3)
    g_hexStream := gui1.Classy_Add("GroupBox", "Center c000000", "Hex Stream",,, g_binStream, g_var, 1/3, 1/3)

    g_varBin := gui1.Classy_Add("GroupBox", "Center c000000", "Var Bin",,, g_Char, g_binStream, 1/3, g_hexString)
    g_varHex := gui1.Classy_Add("GroupBox", "Center c000000", "Var Hex",,, g_varBin, g_binStream, 1/3, g_hexString)

    g_var_e1 := gui1.Classy_Add("Edit", "", "customChar",, g_var, 0, 0, 1, 1) 

    g_clip_b1 := gui1.Classy_Add("Button", "Center", "Paste",, g_clip, 0, "f", 1/2, 1)
    g_clip_b2 := gui1.Classy_Add("Button", "Center", "Swap",, g_clip, 1/2, "f", 1/2, 1)

    g_binStream_b1 := gui1.Classy_Add("Button", "Center", "Copy",, g_binStream, 0, "f", 1, 1)
    g_binStream_e1 := gui1.Classy_Add("Edit", "Center ReadOnly Multi -VScroll -Wrap Multi -VScroll -Wrap",,, g_binStream, 0, 0, 1, g_binStream_b1)

    g_hexStream_b1 := gui1.Classy_Add("Button", "Center", "Copy",, g_hexStream, 0, "f", 1, 1)
    g_hexStream_e1 := gui1.Classy_Add("Edit", "Center ReadOnly Multi -VScroll -Wrap",,, g_hexStream, 0, 0, 1, g_hexStream_b1)

    g_hexString_e1 := gui1.Classy_Add("Edit", "ReadOnly",,, g_hexString, 0, 0, 4/5, 1)
    g_hexString_b1 := gui1.Classy_Add("Button", "Center", "Copy",, g_hexString, 4/5, 0, 1/5, 1)

    g_varString_e1 := gui1.Classy_Add("Edit", "ReadOnly",,, g_varString, 0, 0, 4/5, 1)
    g_varString_b1 := gui1.Classy_Add("Button", "Center ", "Copy",, g_varString, 4/5, 0, 1/5, 1)

    g_varBin_b1 := gui1.Classy_Add("Button", "Center", "Copy",, g_varBin, 0, "f", 1, 1)
    g_varBin_e1 := gui1.Classy_Add("Edit", "ReadOnly Multi -VScroll -Wrap",,, g_varBin, 0, 0, 1, g_varBin_b1)

    g_varHex_b1 := gui1.Classy_Add("Button", "Center", "Copy",, g_varHex, 0, "f", 1, 1)
    g_varHex_e1 := gui1.Classy_Add("Edit", "ReadOnly Multi -VScroll -Wrap",,, g_varHex, 0, 0, 1, g_varHex_b1)

    offSet := 1/(columnCount+1)
    g_Char_b1 := gui1.Classy_Add("Button", "Center", "Clear",, g_Char, offSet + 1/5, "f", 1/5, 1)
    g_Char_b2 := gui1.Classy_Add("Button", "Center", "Invert",, g_Char, -(offSet + 1/5), "f", 1/5, 1)

    rowCount++
    columnCount++

    g_Char_p := []

    gui1.Classy_Bounds(,,, g_Char_b1)

    loop rowCount {
        
        rc := A_Index
        
        loop columnCount {
            
            cc := A_Index

            if (rc == 1 && cc > 1){
                gui1.Classy_Add("Text", "Center 0x200", "Bit " (columnCount) - cc,, g_Char, (cc-1)/columnCount, (rc-1)/rowCount, 1/columnCount, 1/rowCount, true)
            }

            if (cc == 1 && rc > 1){
                gui1.Classy_Add("Text", "Center 0x200", "Byte " rc-2,, g_Char, (cc-1)/columnCount, (rc-1)/rowCount, 1/columnCount, 1/rowCount, true)
            }

            if (rc > 1 && cc > 1) {
                g_Char_p.Push(gui1.Classy_Add("Pic", lightColor,,, g_Char, (cc-1)/columnCount, (rc-1)/rowCount, 1/columnCount, 1/rowCount, true))
            }
        }
    }

    for pControl in g_Char_p {
        pControl.state := false
    }

    events()
    events() {
        g_binStream_b1.onEvent("Click", (*) => copyToClipboard(g_binStream_e1.Text))
        g_hexStream_b1.onEvent("Click", (*) => copyToClipboard(g_hexStream_e1.Text))
        g_hexString_b1.onEvent("Click", (*) => copyToClipboard(g_hexString_e1.Text))
        g_varString_b1.onEvent("Click", (*) => copyToClipboard(g_varString_e1.Text))
        g_varBin_b1.onEvent("Click", (*) => copyToClipboard(g_varBin_e1.Text))
        g_varHex_b1.onEvent("Click", (*) => copyToClipboard(g_varHex_e1.Text))

        g_var_e1.onEvent("Change", (*) => getValues())

        g_Char_b1.onEvent("Click", clear)
        clear(*) {
            for pControl in g_Char_p {
                pControl.Opt(lightColor)
                pControl.Redraw()
                pControl.state := false
            }
            getValues()
        }

        g_Char_b2.onEvent("Click", invert)
        invert(*) {
            for pControl in g_Char_p {
                if (pControl.state) {
                    pControl.Opt(lightColor)
                    pControl.Redraw()
                    pControl.state := false
                }
                else {
                    pControl.Opt(darkColor)
                    pControl.Redraw()
                    pControl.state := true
                }
            }
            getValues()
        }

        g_clip_b1.onEvent("Click", paste)
        paste(*) {

            clipVar := ""
            clipValues := []

            ClipboardtoInt(A_Clipboard, &clipVar, clipValues)

            rowCount := 0
            colCount := 0
            clear()

            if (clipVar) {
                g_var_e1.Value := clipVar
            }
            
            for index, value in clipValues {
                binStr := intToBin(value)
                loop StrLen(binStr) {
                    bit := SubStr(binStr, A_Index, 1)
                    pControl := g_Char_p[(index - 1) * (columnCount - 1) + A_Index]
                    if (bit == "1") {
                        pControl.Opt(darkColor)
                        pControl.state := true
                    } else {
                        pControl.Opt(lightColor)
                        pControl.state := false
                    }
                    pControl.Redraw()
                }
            }

            getValues()
        }

        g_clip_b2.onEvent("Click", swap)
        swap(*) {

            clipString := g_varString_e1.Value
            paste()

            A_Clipboard := clipString
        }
    }

    copyToClipboard(text) {
        A_Clipboard := text
        ToolTip("Copied to Clipboard:`n______`n" text)
        SetTimer(ToolTip, -1000)
    }

    ClipboardtoInt(clipString, &nameVar := "", valueArray := []) {
        clipString := StrReplace(clipString, "`r")
        clipString := StrReplace(clipString, "`t")
        clipString := StrReplace(clipString, "byte ")
        clipString := StrReplace(clipString, "0x")
        clipString := StrReplace(clipString, ",")
        clipString := StrReplace(clipString, "};")
        clipString := StrReplace(clipString, "`n", " ")

        clipString := LTrim(clipString)

        if (inStr(clipString, "[")) {
            nameVar := SubStr(clipString, 1, inStr(clipString, "[") - 1)
            clipString := SubStr(clipString, inStr(clipString, "{") + 1)
        }

        clipString := StrReplace(clipString, "B")

        for myNumber in StrSplit(clipString, " ") {
            if (myNumber != "") {
                myNumber := Trim(myNumber)
                if (RegExMatch(myNumber, "^[0-9A-Fa-f]{2}$")) {
                    myNumber := HexToInt(myNumber)
                } else if (RegExMatch(myNumber, "^[01]{5}$")) {
                    myNumber := BinToInt(myNumber)
                } else if (RegExMatch(myNumber, "^[01]{8}$")) {
                    myNumber := BinToInt(myNumber)
                }
                valueArray.Push(Integer(myNumber))
            }
        }
    }

    getValues()
    getValues() {

        outString := ""
        charData := []

        rowCounter := 1
        columnCounter := columnCount - 1
        for pControl in g_Char_p {

            outString := outString (pControl.state)

            if (A_Index == columnCounter) {
                columnCounter += columnCount - 1
                charData.Push(outString)
                outString := ""
            }
        }

        data := []

        for number in charData {
            data.Push(binToInt(number))
        }

        if (g_var_e1.Value) {
            varName := g_var_e1.Value "[]"
        } else {
            g_var_e1.Value := "customChar"
            varName := g_var_e1.Value "[]"
            g_var_e1.Focus()
        }

        g_binStream_Format()
        g_binStream_Format() {
            outString := ""
            for number in data {
            outString := outString intToBin(number) "`n"
            }
            outString := SubStr(outString, 1, -1)
            g_binStream_e1.Value := outString
        }

        g_hexStream_Format()
        g_hexStream_Format() {
            outString := ""
            for number in data {
            outString := outString intToHex(number) "`n"
            }
            outString := SubStr(outString, 1, -1)
            g_hexStream_e1.Value := outString
        }

        g_hexString_Format()
        g_hexString_Format() {
            outString := ""
            for number in data {
            outString := outString "0x" intToHex(number) ", "
            }
            outString := SubStr(outString, 1, -2)
            g_hexString_e1.Value := outString
        }

        g_varString_Format()
        g_varString_Format() {
            outString := "byte " varName " = {"
            for number in data {
            outString := outString "0x" intToHex(number) ", "
            }
            outString := SubStr(outString, 1, -2) "};"
            g_varString_e1.Value := outString
        }

        g_varBin_Format()
        g_varBin_Format() {
            outString := "byte " varName " = {`n"
            for number in data {
            outString := outString "`tB" intToBin(number) ",`n"
            }
            outString := SubStr(outString, 1, -2) "`n};"
            g_varBin_e1.Value := outString
        }

        g_varHex_Format()
        g_varHex_Format() {
            outString := "byte " varName " = {`n"
            for number in data {
            outString := outString "`t0x" intToHex(number) ",`n"
            }
            outString := SubStr(outString, 1, -2) "`n};"
            g_varHex_e1.Value := outString
        }
    }

    binToInt(binStr) {
        intValue := 0
        dfgdfg := StrLen(binStr)
        loop dfgdfg {
            intValue := intValue * 2 + SubStr(binStr, A_Index, 1)
        }
        return intValue
    }

    intToBin(intValue) {
        binStr := ""
        while (intValue > 0) {
            binStr := Mod(intValue, 2) binStr
            intValue := Floor(intValue / 2)
        }
        return StrLen(binStr) < 8 ? SubStr("00000", 1, 5 - StrLen(binStr)) binStr : binStr
    }

    intToHex(intValue) {
        hexStr := Format("{:02X}", intValue)
        return hexStr
    }

    hexToInt(hexStr) {
        intValue := 0
        hexStr := StrUpper(hexStr)
        hexDigits := "0123456789ABCDEF"
        loop StrLen(hexStr) {
            digit := SubStr(hexStr, A_Index, 1)
            intValue := intValue * 16 + InStr(hexDigits, digit) - 1
        }
        return intValue
    }

    gui1.Classy_Show()

    SetTimer(active_loop, 1)

    clickState := false
    drawState := 0
    oldObj := ""
    oldControl := ""

    oldClip := ""
    errorState := false

    active_loop() {

        if (WinActive("ahk_id " gui1.hwnd)) {

            if (oldClip != A_Clipboard) {
                oldClip := A_Clipboard
                
                try {
                    ClipboardtoInt(A_Clipboard) 
                } catch {
                    g_clip_b1.Opt("Disabled")
                    g_clip_b2.Opt("Disabled")
                    errorState := true
                } else {
                    g_clip_b1.Opt("-Disabled")
                    g_clip_b2.Opt("-Disabled")
                    errorState := false
                }
                 
            }

            MouseGetPos(&X, &Y, &Win, &Control)

            ; if (oldControl != Control) {
                if (Control == g_clip_b1.ClassNN || Control == g_clip_b2.ClassNN) {
                    if (StrLen(A_Clipboard) < 200) {
                        if (errorState) {
                            ToolTip("Invalid Clipboard")
                            SetTimer(ToolTip, -10)
                        } else {
                            ToolTip("Clipboard:`n______`n" A_Clipboard)
                            SetTimer(ToolTip, -10)
                        }
                        
                    }
                }
                oldControl := Control
            ; }

            if (GetKeyState("LButton", "P") && !clickState) {
                
                clickState := true

                MouseGetPos(&X, &Y, &Win, &Control)

                for pControl in g_Char_p {
                    
                    if (pControl.ClassNN == Control) {
                        
                        if (pControl.state) {
                            drawState := 1
                        }
                        
                        else {
                            drawState := 2
                        }
                    }
                }
            }
            
            else if (!GetKeyState("LButton", "P") && clickState) {
                clickState := false
                drawState := 0

                oldObj := 0
                oldControl := 0
                oldClip := 0
            }

            if (drawState) {

                for pControl in g_Char_p {

                    if (pControl.ClassNN == Control && oldObj != pControl) {

                        if (drawState == 1) {
                            pControl.Opt(lightColor)
                            pControl.Redraw()
                            pControl.state := false
                        }
                        
                        else {
                            pControl.Opt(darkColor)
                            pControl.Redraw()
                            pControl.state := true
                        }

                        getValues()
                        oldObj := pControl
                    }
                }
            }
        } else {
            ToolTip()
        }
    }    

    return gui1
}