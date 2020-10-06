*--------------------------------------------------------------------*
* Popup with 6 lines and 3 buttons
*--------------------------------------------------------------------*

DATA:
  BEGIN OF popup,
    titl(60) TYPE c,
    icon(01) TYPE c,
    txt1(60) TYPE c,
    txt2(60) TYPE c,
    txt3(60) TYPE c,
    txt4(60) TYPE c,
    txt5(60) TYPE c,
    txt6(60) TYPE c,
    btn1(20) TYPE c,
    btn2(20) TYPE c,
    btn3(20) TYPE c,
    ok_code  TYPE c,
  END OF popup.

popup-titl = 'Popup Dialog Title'.
popup-icon = 'Q'. "(I)nfo, (W)arning, (E)rror, (Q)uestion, (C)ritical
popup-txt1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '.
popup-txt2 = 'Vestibulum varius arcu quis quam condimentum pellentesque.'.
popup-txt3 = 'Sed nec pretium tellus. Nulla interdum ligula ac sem'.
popup-txt4 = 'hendrerit convallis. Phasellus semper dignissim rutrum.'.
popup-txt5 = 'Donec efficitur pellentesque lorem in pretium.'.
popup-txt6 = 'Praesent auctor bibendum enim nec laoreet.'.
popup-btn1 = icon_okay   && 'Yes'.
popup-btn2 = icon_cancel && 'No'.
popup-btn3 = icon_dummy  && 'Cancel'.

CALL FUNCTION 'POPUP_FOR_INTERACTION'
  EXPORTING
    headline       = popup-titl
    text1          = popup-txt1
    text2          = popup-txt2
    text3          = popup-txt3
    text4          = popup-txt4
    text5          = popup-txt5
    text6          = popup-txt6
    button_1       = popup-btn1
    button_2       = popup-btn2
    button_3       = popup-btn3
    ticon          = popup-icon
  IMPORTING
    button_pressed = popup-ok_code.

CASE popup-ok_code.
  WHEN 1. WRITE 'Yes'.
  WHEN 2. WRITE 'No'.
  WHEN 3. WRITE 'Cancel'.
ENDCASE.
