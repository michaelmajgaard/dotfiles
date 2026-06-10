#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Settings ---
global margin := 30
global step := 10
global presets := [10, 20, 30, 40, 50]
global presetIndex := 3

; Set to true if you want automatic periodic shifting
global autoShift := false

; Every 30 minutes, rotate margin if autoShift is enabled
SetTimer(AutoRotateMargin, 30 * 60 * 1000)

; Win + Up = apply current margin to active window
#Up::ApplyMargin()

; Win + Alt + Plus = increase margin
#!=:: {
    global margin, step
    margin += step
    ApplyMargin()
    ToolTip("Margin: " margin "px")
    SetTimer(() => ToolTip(), -1000)
}

; Win + Alt + Minus = decrease margin
#!-:: {
    global margin, step
    margin := Max(0, margin - step)
    ApplyMargin()
    ToolTip("Margin: " margin "px")
    SetTimer(() => ToolTip(), -1000)
}

; Win + Alt + M = cycle margin presets
#!m:: {
    global presets, presetIndex, margin

    presetIndex += 1
    if presetIndex > presets.Length
        presetIndex := 1

    margin := presets[presetIndex]
    ApplyMargin()
    ToolTip("Margin preset: " margin "px")
    SetTimer(() => ToolTip(), -1000)
}

; Win + Alt + R = random margin between 10 and 60 px
#!r:: {
    global margin
    margin := Random(10, 60)
    ApplyMargin()
    ToolTip("Random margin: " margin "px")
    SetTimer(() => ToolTip(), -1000)
}

; Win + Alt + A = toggle automatic rotation
#!a:: {
    global autoShift
    autoShift := !autoShift
    ToolTip("Auto shift: " (autoShift ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

ApplyMargin() {
    global margin

    hwnd := WinExist("A")
    if !hwnd
        return

    ; Do not move desktop/taskbar/shell windows
    class := WinGetClass("ahk_id " hwnd)
    if class = "Shell_TrayWnd" || class = "Progman" || class = "WorkerW"
        return

    ; Restore if maximized, otherwise WinMove may not work properly
    if WinGetMinMax("ahk_id " hwnd) = 1
        WinRestore("ahk_id " hwnd)

    monitor := GetMonitorWorkArea(hwnd)

    x := monitor.left + margin
    y := monitor.top + margin
    w := monitor.right - monitor.left - margin * 2
    h := monitor.bottom - monitor.top - margin * 2

    WinMove(x, y, w, h, "ahk_id " hwnd)
}

AutoRotateMargin() {
    global autoShift, presets, presetIndex, margin

    if !autoShift
        return

    presetIndex += 1
    if presetIndex > presets.Length
        presetIndex := 1

    margin := presets[presetIndex]
    ApplyMargin()
}

GetMonitorWorkArea(hwnd) {
    WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " hwnd)

    centerX := wx + ww / 2
    centerY := wy + wh / 2

    count := MonitorGetCount()

    Loop count {
        MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)

        if centerX >= left && centerX <= right && centerY >= top && centerY <= bottom {
            return {
                left: left,
                top: top,
                right: right,
                bottom: bottom
            }
        }
    }

    ; Fallback to primary monitor
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    return {
        left: left,
        top: top,
        right: right,
        bottom: bottom
    }
}
