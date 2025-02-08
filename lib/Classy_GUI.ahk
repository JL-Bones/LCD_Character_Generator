; ##################################################
; ||                                              ||
; ||                  CLASSY GUI                  ||
; ||                                              ||
; ##################################################

#Requires AutoHotkey v2.0

class Classy_GUI extends Gui {

    __Init() {

        this.showFlag := false

        this.iniState := false

        this.fontSize := 10
        this.fontMin := 8
        this.fontMax := 30
        this.margin := 6

        this.fontStyle := "Arial"

        this.minMax := 0

        this.antiFlicker := false
        this.forceMin := false
        this.hotKeyState := false

        this.minW1 := 100
        this.minH1 := 100
        this.minW2 := this.minW1
        this.minH2 := this.minH1

        this.toolObj := []

        activeState := false
        SetTimer(activeEvents, 10)

        activeEvents() {

            if (WinActive("ahk_id " this.Hwnd) && !activeState) {
                activeState := true

                if (this.hotKeyState) {

                    Hotkey("^=", fontup, "on")
                    Hotkey("^NumpadAdd", fontup, "on")
                    Hotkey("^-", fontdown, "on")
                    Hotkey("^NumpadSub", fontdown, "on")
                }
            }
            else if (!WinActive("ahk_id " this.Hwnd) && activeState) {
                activeState := false

                if (this.hotKeyState) {
                    Hotkey("^=", fontup, "off")
                    Hotkey("^NumpadAdd", fontup, "off")

                    Hotkey("^-", fontdown, "off")
                    Hotkey("^NumpadSub", fontdown, "off")

                }
            }
        }

        fontup(*) {
            this.fontChange(++this.fontSize)
        }

        fontdown(*) {
            this.fontChange(--this.fontSize)
        }
    }    

    Classy_Settings(newbar := 0) {

        if (!newbar) {
            newbar := MenuBar()
        }
        
        newbar.Add("Settings", (*) => set1.Open())
        this.MenuBar := newbar

        set1 := settings1()
        set2 := settings2(set1)

        settings1() {
            gui1 := this.Classy_ToolWindow(,, "Settings")
            gui1.Classy_Sizer(297, 267, 767, 466)

            tab1 := gui1.Classy_Add("Tab3", , ["Gui"], , 0, 0, 0, 1, 1)
            tab1.UseTab("Gui")

            g1 := gui1.Classy_Add("GroupBox", "Center", "Font Size",, tab1, 0, 0, 1/2, "f2")
            g1_cb1 := gui1.Classy_Add("CheckBox", "Center", "Default",, g1, 1/4, 0, 1/2, 1/2)
            g1_e1 := gui1.Classy_Add("Edit", "Center", this.fontSize, , g1, 0, 1/2, 1/2, 1/2)
            g1_ud1 := gui1.Classy_Add("UpDown",,,, g1, 1/2, 1/2, 1/2, 1/2)

            g2 := gui1.Classy_Add("GroupBox", "Center", "Margin",, tab1, 1/2, 0, 1, "f2")
            g2_cb1 := gui1.Classy_Add("CheckBox", "Center", "Default",, g2, 1/4, 0, 1/2, 1/2)
            g2_e1 := gui1.Classy_Add("Edit", "Center", this.margin, , g2, 0, 1/2, 1/2, 1/2)
            g2_ud1 := gui1.Classy_Add("UpDown",,,, g2, 1/2, 1/2, 1/2, 1/2)

            g3 := gui1.Classy_Add("GroupBox", "Center", "Controls",, tab1, 0, g1, 1, "f2")
            g3_t1 := gui1.Classy_Add("Text", "center 0x200", "Hotkey:",, g3, 0, 0, 1/4, "f")
            g3_dl1 := gui1.Classy_Add("DropDownList",, ["Default", "On", "Off"],, g3, 1/4, 0, 1/4, "f")
            g3_t2 := gui1.Classy_Add("Text", "center 0x200", "Anti-Flicker:",, g3, 1/2, 0, 1/4, "f")
            g3_dl2 := gui1.Classy_Add("DropDownList",, ["Default", "On", "Off"],, g3, 3/4, 0, 1/4, "f")
            g3_t3 := gui1.Classy_Add("Text", "center 0x200", "Force Min:",, g3, 0, 1/2, 1/4, "f")
            g3_dl3 := gui1.Classy_Add("DropDownList",, ["Default", "On", "Off"],, g3, 1/4, 1/2, 1/4, "f")
            g3_t4 := gui1.Classy_Add("Text", "center 0x200", "Max size:",, g3, 1/2, 1/2, 1/4, "f")
            g3_dl4 := gui1.Classy_Add("DropDownList",, ["Default", "On", "Height", "Width"],, g3, 3/4, 1/2, 1/4, "f")

            g4 := gui1.Classy_Add("GroupBox", "Center",,, tab1, 0, "f", 1, "f")
            g4_b1 := gui1.Classy_Add("Button",, "Advanced",, g4, 0, 0, 1/3, 1)
            g4_b2 := gui1.Classy_Add("Button",, "Cancel",, g4, 1/3, 0, 1/3, 1)
            g4_b3 := gui1.Classy_Add("Button",, "OK",, g4, 2/3, 0, 1/3, 1)

            g5 := gui1.Classy_Add("GroupBox", "Center Background000000",,, tab1, 0, g3, 1, g4)

            g4_b1.onEvent("Click", (*) => set2.Open())

            return gui1
        }

        settings2(pObj) {
            gui2 := this.Classy_ToolWindow(pObj,, "Advanced")
            gui2.Classy_Sizer(200, 200)

            return gui2
        }

        return newbar
    }

    Classy_Options(options := "") {
        options := StrSplit(StrLower(options), " ")

        for option in options {
            if (InStr(option, "antiflicker") || InStr(option, "af")) {
                state := SubStr(option, InStr(option, "antiflicker") + 11, 1)
                if (state = "") {
                    state := SubStr(option, InStr(option, "af") + 2, 1)
                }
                this.antiFlicker := (state = "1" || state = "")
                if (this.antiFlicker) {
                    OnMessage(0x0232, ExitMove)
                    ExitMove(wParam, lParam, msg, hwnd) {
                        this.Resize()
                    }
                }
            }

            if (InStr(option, "-antiflicker") || InStr(option, "-af")) {
                this.antiFlicker := false
            }

            if (InStr(option, "forcemin") || InStr(option, "fm")) {
                state := SubStr(option, InStr(option, "forcemin") + 8, 1)
                if (state = "") {
                    state := SubStr(option, InStr(option, "fm") + 2, 1)
                }
                this.forceMin := (state = "1" || state = "")
            }

            if (InStr(option, "-forcemin") || InStr(option, "-fm")) {
                this.forceMin := false
            }

            if (InStr(option, "hotkey") || InStr(option, "hk")) {
                state := SubStr(option, InStr(option, "hotkey") + 6, 1)
                if (state = "") {
                    state := SubStr(option, InStr(option, "hk") + 2, 1)
                }
                this.hotKeyState := (state = "1" || state = "")
            }

            if (InStr(option, "-hotkey") || InStr(option, "-hk")) {
                this.hotKeyState := false
            }
        }
    }

    Classy_Sizer(minW1 := 100, minH1 := 100, minW2 := minW1 * 2, minH2 := minH1 * 2) {
        this.minW1 := minW1
        this.minH1 := minH1
        this.minW2 := minW2
        this.minH2 := minH2

        if (!A_IsCompiled) {
            this.OnEvent("ContextMenu", guiMenu)
        }

        guiMenu(GuiObj, GuiCtrlObj, Item, IsRightClick, X, Y) {
            if (!GuiCtrlObj) {
                mainMenu := Menu()
                mainMenu.Add("set MinSize", (*) => this.setMinSize())
                mainMenu.Show()
            }
        }
    }

    Classy_Font(fontSize := this.fontSize, fontMin := this.fontMin, fontMax := this.fontMax, margin := this.margin, fontStyle := this.fontStyle) {

        this.setFont(, fontStyle)

        this.fontSize := fontSize

        this.fontMin := fontMin
        this.fontMax := fontMax

        this.margin := margin

        this.fontStyle := fontStyle
        
        try {
            this.fontChange(this.fontSize)
        }
    }

    Classy_ini(iniPath, section := this.Title) {

        dirPath := SubStr(iniPath, 1, InStr(iniPath, "\",, -1))

        if (!FileExist(dirPath)) {
            createdir := MsgBox("Create this folder:`n" A_ScriptDir . "\" dirPath, "Missing Dirctory", 4 + 48)
            if (createdir = "Yes") {
                DirCreate(dirPath)
            } else {
                return
            }
        }

        this.iniState := true

        this.iniminMax := Classy_GUI.ini_Var(iniPath, section, "minMax", 0)
        this.iniX := Classy_GUI.ini_Var(iniPath, section, "x", 0)
        this.iniY := Classy_GUI.ini_Var(iniPath, section, "y", 0)
        this.iniW := Classy_GUI.ini_Var(iniPath, section, "w", 0)
        this.iniH := Classy_GUI.ini_Var(iniPath, section, "h", 0)

        this.iniFont := Classy_GUI.ini_Var(iniPath, section, "font", 0)
        if (this.iniFont.Value) {
            this.fontSize := this.iniFont.Value
        }

    }

    Classy_Add(ControlType, Options := "", Text := "", extraData := [], pObj := 0, xScale := 0, yScale := 0, wScale := 0, hScale := 0, boundState := false) {

        fScale := 1
        for option in StrSplit(Options, " ") {
            if (SubStr(option, 1, 1) == "f") {
                fScale := SubStr(option, 2)
                Options := StrReplace(Options, option)
                break
            }
        }
        this.SetFont("s" this.fontSize * fScale)

        ControlType := StrLower(ControlType)
        if (ControlType == "statusbar") {
            if (this.fontSize > 12) {
                this.SetFont("s" 12)
            }
        }
        newControl := this.Add(ControlType, Options, Text)
        this.SetFont("s" this.fontSize)

        if (ControlType == "statusbar") {
            newControl.extraData := extraData
            newControl.SetParts(extraData*)
        }
        else if (ControlType == "listview") {

            newControl.drawState := drawState

            drawState(GuiCtrlObj, Info) {

                if (Info) {
                    GuiCtrlObj.Opt("+redraw")
                    this.Resize()
                } else {
                    GuiCtrlObj.Opt("-redraw")
                }
            }
        }

        newControl.fScale := fScale
        newControl.extraData := extraData
        newControl.pObj := pObj
        newControl.xScale := xScale
        newControl.yScale := yScale
        newControl.wScale := wScale
        newControl.hScale := hScale

        newControl.boundState := boundState

        return newControl
    }

    Classy_Bounds(bx_Obj := 0, by_Obj := 0, bw_Obj := 0, bh_Obj := 0) {
        this.bx_Obj := bx_Obj
        this.by_Obj := by_Obj
        this.bw_Obj := bw_Obj
        this.bh_Obj := bh_Obj
    }

    Classy_Show(options := "", w := this.minW1, h := this.minH1) {

        if (!this.showFlag) {
            this.Opt("Resize")
            events()
            this.showFlag := true
        }

        events() {

            this.OnEvent("Size", size)
            size(GuiObj, MinMax, Width, Height) {

                if (!this.antiFlicker || MinMax != this.minMax) {
                    this.Resize()
                }

                this.minMax := MinMax
                if (this.iniState && MinMax != -1) {
                    this.iniminMax.Value := MinMax
                }

                
            }

            this.OnEvent("Close", (*) => close())
            close() {
                if (this.iniState) {

                    if (this.minMax != 0) {
                        this.Restore()
                    }
                    if (this.minMax == -1) {
                        this.Restore()
                    }
                    this.GetPos(&x, &y, &w, &h)

                    ; WinGetClientPos(&x, &y, &w, &h, "ahk_id " this.Hwnd)

                    this.iniFont.Write(this.fontSize)

                    this.iniminMax.Write()
                    this.iniX.Write(x)
                    this.iniY.Write(y)
                    this.iniW.Write(w - 16)
                    this.iniH.Write(h - 39)
                }

                pid := WinGetPID("ahk_id " this.Hwnd)
                this.Hide()

                if (!WinExist("ahk_pid " pid)) {
                    ExitApp()
                }
            }
        }

        if (this.iniState) {
            if (this.iniminMax.Value) {
                options := options " Maximize"
            }
            if (this.iniX.Value) {
                options := options " x" this.iniX.Value
            }
            if (this.iniY.Value) {
                options := options " y" this.iniY.Value
            }
            if (this.iniW.Value) {
                w := this.iniW.Value
            }
            if (this.iniH.Value) {
                h := this.iniH.Value
            }
        }

        options := options " w" w " h" h
        this.minSizer()
        this.Show(options)
        this.Resize()
    }

    Classy_ToolWindow(pObj := this, options := "", prams*) {

        options := options " ToolWindow Owner" pObj.Hwnd
        newTool := Classy_GUI(options, prams*)

        newTool.minMax := 0
        newTool.Classy_Options("af" this.antiFlicker " fm")
        newTool.Classy_Font(this.fontSize, this.fontMin, this.fontMax, this.margin, this.fontStyle)

        newTool.Open := Open

        newTool.OnEvent("Escape", (*) => Send("!{f4}"))
        newTool.OnEvent("Close", close)

        this.toolObj.Push(newTool)

        return newTool

        Open(*) {

            pObj.Opt("Disabled")

            newTool.Classy_Show()

            newTool.fontChange(this.fontSize)

            newTool.getPos(,, &tw, &th)

            WinGetPos(&gx, &gy, &gw, &gh, "ahk_id " pObj.Hwnd)
            ; pObj.GetPos(&gx, &gy, &gw, &gh)

            tx := gx + (gw/2) - (tw/2)
            ty := gy + (gh/2) - (th/2)

            newTool.Move(tx, ty, tw, th)
        }

        close(*) {
            pObj.Opt("-Disabled")
        }
    }

    fontChange(fontSize) {

        this.fontSize := fontSize

        if (this.fontSize < this.fontMin) {
            this.fontSize := this.fontMin
        } else if (this.fontSize > this.fontMax) {
            this.fontSize := this.fontMax
        }

        for control in this {
            if (InStr("Pic UpDown", control.Type)) {
                continue
            }

            newFontSize := this.fontSize * control.fScale

            if (newFontSize > 10 && control.Type == "StatusBar") {
                newFontSize := 10
            }

            if (control.fScale) {
                control.setFont("s" newFontSize)
            } else {
                control.setFont("s" this.fontSize)
            }
        }

        this.minSizer()
    }

    setMinSize() {

        currentFontSize := this.fontSize
        for control in this {
            control.Enabled := false
        }

        this.fontChange(this.fontMin)
        Hotkey("enter", getMinSize1, "On")

        this.Opt("-MinSize Resize")
        this.antiFlicker := false

        getMinSize1(*) {
            this.GetPos(, , &w, &h)
            clipString := w - 16 ", " h - 39

            this.fontChange(this.fontMax)

            Hotkey("enter", getMinSize1, "Off")
            Hotkey("enter", getMinSize2, "On")

            this.Opt("-MinSize")

            getMinSize2(*) {
                this.GetPos(, , &w, &h)

                A_Clipboard := clipString ", " w - 16 ", " h - 39
                ExitApp()
            }
        }
    }

    minSizer() {

        minw := ranger(this.fontSize, this.fontMin, this.fontMax, this.minW1, this.minW2)
        minh := ranger(this.fontSize, this.fontMin, this.fontMax, this.minH1, this.minH2)

        this.Opt("+MinSize" minw "x" minh)

        this.GetPos(&x, &y)

        if (this.forceMin && this.minMax != 1) {
            this.Move(x, y, minw, minh)
        }

        this.Move(x, y)
        this.Resize()

        ranger(value, fromLow, fromHigh, toLow, toHigh) {
            return Integer((value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow)
        }
    }

    Resize() {
        this.GetPos(, , &Width, &Height)
        Width -= 16
        Height -= 39

        if (this.MenuBar) {
            Height -= 20

        }

        for control in this {

            if (control.Type == "StatusBar") {

                Height -= 24
                partsWidth := []

                for ratio in control.extraData {
                    partsWidth.Push(Width * ratio)
                }
                control.SetParts(partsWidth*)
            }
            else if (control.wScale && control.hScale) {

                if (control.pObj) {
                    control.pObj.getPos(&bx, &by, &bw, &bh)

                    hAdjust := control.pObj.fScale * this.fontSize * 1.5
                    by += hAdjust
                    bh -= hAdjust

                    if (control.pObj.Type == "Tab" || control.pObj.Type == "Tab2" || control.pObj.Type == "Tab3") {
                        by += this.margin
                        bh -= this.margin
                    }

                } else {
                    bx := 0
                    by := 0
                    bw := Width
                    bh := Height
                }

                if (control.boundState) {
                    if (IsObject(this.bx_Obj)) {
                        this.bx_Obj.getPos(&cx, , &cw)
                        bx := cx + cw + this.margin

                        if (!IsObject(this.bw_Obj)) {
                            bw -= cx + cw
                        }
                    } else {
                        bx += this.bx_Obj
                    }

                    if (IsObject(this.by_Obj)) {
                        this.by_Obj.getPos(, &cy, , &ch)
                        by := cy + ch + this.margin

                        if (!IsObject(this.bh_Obj)) {
                            bh -= (cy + ch) - hAdjust
                        }
                    } else {
                        by += this.by_Obj
                    }

                    if (IsObject(this.bw_Obj)) {
                        this.bw_Obj.getPos(&cx, , &cw)
                        bw -= (bx + bw) - cx + this.margin
                    } else {
                        bw += this.bw_Obj
                    }

                    if (IsObject(this.bh_Obj)) {
                        this.bh_Obj.getPos(, &cy)
                        bh -= (by + bh) - cy + this.margin
                    } else {
                        bh += this.bh_Obj
                    }
                }

                if (IsObject(control.xScale)) {
                    control.xScale.getPos(&cx, , &cw)
                    nx := cx + cw + (this.margin * 2)
                } else {
                    if (control.xScale <= 1 && control.xScale >= 0) {
                        nx := bx + (control.xScale * bw) + this.margin
                    }
                    else if (control.xScale >= -1 && control.xScale < 0) {
                        nx := (bx + bw) + (control.xScale * bw) + this.margin
                    }
                    else if (control.xScale > 1) {
                        nx := bx + control.xScale
                    }
                    else if (control.xScale < -1) {
                        nx := (bx + bw) + control.xScale - this.margin
                    }
                }

                if (IsObject(control.yScale)) {
                    control.yScale.getPos(, &cy, , &ch)
                    ny := cy + ch + (this.margin * 2)
                } else if (IsNumber(control.yScale)) {
                    if (control.yScale <= 1 && control.yScale >= 0) {
                        ny := by + (control.yScale * bh) + this.margin
                    }
                    else if (control.yScale >= -1 && control.yScale < 0) {
                        ny := (by + bh) + (control.yScale * bh) + this.margin
                    }
                    else if (control.yScale > 1) {
                        ny := by + control.yScale
                    }
                    else if (control.yScale < -1) {
                        ny := (by + bh) + control.yScale - this.margin
                    }
                } else {

                    for option in StrSplit(StrLower(control.yScale), " ") {
                        if (InStr(option, "font") || InStr(option, "f")) {
                            hValue := SubStr(option, InStr(option, "font") + 4, 1)
                            
                            if (hValue = "") {
                                hValue := SubStr(option, InStr(option, "f") + 1, 1)
                            }

                            if (hValue) {
                                hValue := Integer(hValue)
                            } else {
                                hValue := 1
                            }

                            if (control.Type == "GroupBox") {
                                hValue *= 2
                            }

                            hValue := (1.5 * this.fontSize + 12) * hValue + (this.margin / 2)

                            ny := (by + bh) - hValue - this.margin
                        }
                    }
                }

                if (IsObject(control.wScale)) {
                    control.wScale.getPos(&cx, , &cw)
                    nw := cx - nx - (this.margin * 2)
                } else {
                    if (control.wScale <= 1 && control.wScale >= 0) {
                        nw := bw * control.wScale - (this.margin * 2)
                    } else if (control.wScale >= -1 && control.wScale < 0) {
                        nw := bw * (1 - Abs(control.wScale)) - (this.margin * 2)
                    } else if (control.wScale > 1) {
                        nw := control.wScale
                    } else if (control.wScale < -1) {
                        nw -= Abs(control.wScale)
                    }
                }

                if (IsObject(control.hScale)) {
                    control.hScale.getPos(, &cy)
                    nh := cy - ny - (this.margin * 2)
                } else if (IsNumber(control.hScale)) {
                    if (control.hScale <= 1 && control.hScale >= 0) {
                        nh := bh * control.hScale - (this.margin * 2)
                    } else if (control.hScale >= -1 && control.hScale < 0) {
                        nh := bh * (1 - Abs(control.hScale)) - (this.margin * 2)
                    } else if (control.hScale > 1) {
                        nh := control.hScale
                    } else if (control.hScale < -1) {
                        nh -= Abs(control.hScale)
                    }
                } else {

                    for option in StrSplit(StrLower(control.hScale), " ") {
                        if (InStr(option, "font") || InStr(option, "f")) {
                            hValue := SubStr(option, InStr(option, "font") + 4)
                            
                            if (hValue = "") {
                                hValue := SubStr(option, InStr(option, "f") + 1)
                            }

                            if (hValue) {
                                hValue := Number(hValue)
                            } else {
                                hValue := 1
                            }
                        } else if (InStr(option, "r")) {
                            hValue := SubStr(option, InStr(option, "r") + 1)
                            
                            if (hValue) {
                                hValue := Number(hValue)
                            } else {
                                hValue := 1
                            }
                        }
                    }

                    nh := (1.5 * this.fontSize + 8) * hValue + (this.margin / 2)

                    if (control.Type == "GroupBox") {
                        ; nh *= 2
                        ;nh += (this.margin) - 3
                    }

                    ; nh := (1.5 * this.fontSize + 8) * fTest + (this.margin / 2)

                    if (control.Type == "GroupBox") {
                        nh *= 2
                        nh += (this.margin) - 3
                    }
                }

                if ((nx + nw) > (bx + bw)) {
                    nw -= (nx + nw) - (bx + bw) + this.margin
                }

                if ((ny + nh) > (by + bh)) {
                    nh -= (ny + nh) - (by + bh) + this.margin
                }

                control.Move(nx, ny, nw, nh)
                control.redraw()
            } else {
                control.Move(0, 0, 0, 0)
                control.redraw()
            }

            if (control.Type == "ListView") {
                control.getPos(, , &controlWidth)

                if (ControlGetStyle(control.Hwnd) & 0x00200000) {
                    controlWidth -= 21
                } else {
                    controlWidth -= 4
                }

                for ratio in control.extraData {
                    control.ModifyCol(A_Index, controlWidth * ratio)
                }
            }
        }
    }

    class ini_Var {
        __New(FileName, Section, Key, default := "", saveState := true) {
            this.FileName := FileName
            this.Section := Section
            this.Key := Key
            this.Value := this.Read()
            this.saveState := saveState
            if (this.Value == "") {
                this.Value := default
            }
        }

        Read() {
            return this.Value := IniRead(this.FileName, this.Section, this.Key, "")
        }

        Write(New_Value := "") {
            if (this.saveState) {
                if (New_Value != "") {
                    this.Value := New_Value
                }
                IniWrite(this.Value, this.FileName, this.Section, this.Key)
            } else {
                if (IniRead(this.FileName, this.Section, this.Key, 0)) {
                    IniDelete(this.FileName, this.Section, this.Key)
                }
            }
        }

        Delete() {
            IniDelete(this.FileName, this.Section, this.Key)
        }
    }
}
