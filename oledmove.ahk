#Requires AutoHotkey v2.0
#SingleInstance Force

^!Enter::ApplyMargin()

GetCurrentMargin() {
    margins := [10, 20, 30, 40]

    days := DateDiff(A_Now, "20000101000000", "Days")
    index := Mod(days, margins.Length) + 1

    return margins[index]
}

ApplyMargin() {
    margin := GetCurrentMargin()

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
