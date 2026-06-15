#Requires AutoHotkey v2.0
#SingleInstance Force

global margins := [32, 40, 48, 56, 64]
global marginIndex := 1

; Ctrl + Alt + Enter
^!Enter::ApplyMargin()

; Ctrl + Alt + C
^!c::CenterFocusedWindow()

; Ctrl + Alt + -
^!-::ResizeFocusedWindow(-32)

; Win + Alt + M
#!m:: {
    global margins, marginIndex

    marginIndex += 1
    if marginIndex > margins.Length
        marginIndex := 1

    ApplyMargin()

    ToolTip("Margin: " margins[marginIndex] "px")
    SetTimer(() => ToolTip(), -1000)
}

ApplyMargin() {
    global margins, marginIndex

    margin := margins[marginIndex]

    hwnd := WinExist("A")
    if !hwnd
        return

    if WinGetMinMax("ahk_id " hwnd) = 1
        WinRestore("ahk_id " hwnd)

    MonitorGetWorkArea(1, &left, &top, &right, &bottom)

    WinMove(
        left + margin,
        top + margin,
        (right - left) - margin * 2,
        (bottom - top) - margin * 2,
        "ahk_id " hwnd
    )
}

CenterFocusedWindow() {
    hwnd := WinExist("A")
    if !hwnd
        return

    if WinGetMinMax("ahk_id " hwnd) = 1
        WinRestore("ahk_id " hwnd)

    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)

    newX := left + ((right - left) - w) // 2
    newY := top + ((bottom - top) - h) // 2

    WinMove(newX, newY,,, "ahk_id " hwnd)
}

ResizeFocusedWindow(delta) {
    hwnd := WinExist("A")
    if !hwnd
        return

    if WinGetMinMax("ahk_id " hwnd) = 1
        WinRestore("ahk_id " hwnd)

    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)

    newW := Max(100, w + delta)
    newH := Max(100, h + delta)

    WinMove(x, y, newW, newH, "ahk_id " hwnd)
}
