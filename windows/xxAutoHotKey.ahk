#Requires AutoHotkey v2.0
#SingleInstance Force

values := [24, 32, 40, 48]
day := Integer(SubStr(A_Now, 7, 2))

global margin := values[Mod(day - 1, values.length) + 1]

; Ctrl + Alt + Enter
^!Enter::ApplyMarginAndPosition("maximize")

; Ctrl + Alt + C
^!c::CenterFocusedWindow()

; Ctrl + Alt + i
^!i:: ApplyMarginAndPosition("circle_fourths")

; Ctrl + Alt + u
;^!u:: ApplyMarginAndPosition("circle_sixths")

; Ctrl + Alt + d
^!d:: ApplyMarginAndPosition("circle_one_third_columns")

; Ctrl + Alt + t
^!t:: ApplyMarginAndPosition("circle_two_thirds")

; Ctrl + Alt + -
^!-::ResizeFocusedWindow(-256)

ApplyMarginAndPosition(position) {
  hwnd := WinExist("A")
  if !hwnd
      return

  if WinGetMinMax("ahk_id " hwnd) = 1
      WinRestore("ahk_id " hwnd)

  MonitorGetWorkArea(1, &left, &top, &right, &bottom)

  screenW := right - left
  screenH := bottom - top

  WinGetPos(&wl, &wt, &ww, &wh, "ahk_id " hwnd)

  if position = "maximize"
  {
    WinMove(
      left + margin,
      top + margin,
      screenW - margin * 2,
      screenH - margin * 2,
      "ahk_id " hwnd
    )
  }
  else if position = "circle_two_thirds"
  {
    tol := 24
    yTop := top + margin
    hTarget := screenH - margin * 2

    ; Same base column width as one_third layout
    wThird := Floor((screenW - margin * 4) / 3)
    wTarget := 2 * wThird + margin

    xLeft := left + margin
    xRight := right - margin - wTarget

    isRight := Abs(wl - xRight) <= tol
      && Abs(wt - yTop) <= tol
      && Abs(ww - wTarget) <= tol
      && Abs(wh - hTarget) <= tol

    targetX := isRight ? xLeft : xRight
    WinMove(targetX, yTop, wTarget, hTarget, "ahk_id " hwnd)
  }
  else if position = "circle_fourths"
  {
    ; 2x2 grid with equal outer + center gap margins:
    ; 2*w + 3m = screenW, 2*h + 3m = screenH
    wTarget := Floor((screenW - margin * 3) / 2)
    hTarget := Floor((screenH - margin * 3) / 2)

    x1 := left + margin
    x2 := right - margin - wTarget
    y1 := top + margin
    y2 := bottom - margin - hTarget

    ; Clockwise: TL -> TR -> BR -> BL -> TL
    corners := [
      [x1, y1],
      [x2, y1],
      [x2, y2],
      [x1, y2]
    ]

    bestIdx := 1
    bestDist := 0x7FFFFFFF
    Loop corners.Length
    {
      cx := corners[A_Index][1]
      cy := corners[A_Index][2]
      d := Abs(wl - cx) + Abs(wt - cy)
      if (d < bestDist) {
        bestDist := d
        bestIdx := A_Index
      }
    }

    nextIdx := Mod(bestIdx, corners.Length) + 1
    nx := corners[nextIdx][1]
    ny := corners[nextIdx][2]

    WinMove(nx, ny, wTarget, hTarget, "ahk_id " hwnd)
  }
  else if position = "circle_one_third_columns"
  {
    ; 3 equal vertical columns with equal outer + inner gaps:
    ; 3*w + 4m = screenW
    tol := 24
    yTop := top + margin
    hTarget := screenH - margin * 2
    wTarget := Floor((screenW - margin * 4) / 3)

    x1 := left + margin
    x2 := x1 + wTarget + margin
    x3 := x2 + wTarget + margin

    isCol1 := Abs(wl - x1) <= tol && Abs(wt - yTop) <= tol && Abs(ww - wTarget) <= tol && Abs(wh - hTarget) <= tol
    isCol2 := Abs(wl - x2) <= tol && Abs(wt - yTop) <= tol && Abs(ww - wTarget) <= tol && Abs(wh - hTarget) <= tol
    isCol3 := Abs(wl - x3) <= tol && Abs(wt - yTop) <= tol && Abs(ww - wTarget) <= tol && Abs(wh - hTarget) <= tol

    if isCol1
      targetX := x2
    else if isCol2
      targetX := x3
    else if isCol3
      targetX := x1
    else
      targetX := x1 ; first press from "unknown" starts left

    WinMove(targetX, yTop, wTarget, hTarget, "ahk_id " hwnd)
  }
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

  newW := Max(100, w + delta * 4)
  newH := Max(100, h + delta)

  WinMove(x, y, newW, newH, "ahk_id " hwnd)
}
