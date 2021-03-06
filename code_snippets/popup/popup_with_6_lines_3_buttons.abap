*--------------------------------------------------------------------*
* Popup with 6 lines and 3 buttons
*--------------------------------------------------------------------*

DATA:
  BEGIN OF l_popup,
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
  END OF l_popup.

l_popup-titl = 'Popup Dialog Title'.
l_popup-icon = 'Q'. "(I)nfo, (W)arning, (E)rror, (Q)uestion, (C)ritical
l_popup-txt1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '.
l_popup-txt2 = 'Vestibulum varius arcu quis quam condimentum pellentesque.'.
l_popup-txt3 = 'Sed nec pretium tellus. Nulla interdum ligula ac sem'.
l_popup-txt4 = 'hendrerit convallis. Phasellus semper dignissim rutrum.'.
l_popup-txt5 = 'Donec efficitur pellentesque lorem in pretium.'.
l_popup-txt6 = 'Praesent auctor bibendum enim nec laoreet.'.
l_popup-btn1 = icon_okay   && 'Yes'.
l_popup-btn2 = icon_cancel && 'No'.
l_popup-btn3 = icon_dummy  && 'Cancel'.

CALL FUNCTION 'POPUP_FOR_INTERACTION'
  EXPORTING
    headline       = l_popup-titl
    text1          = l_popup-txt1
    text2          = l_popup-txt2
    text3          = l_popup-txt3
    text4          = l_popup-txt4
    text5          = l_popup-txt5
    text6          = l_popup-txt6
    button_1       = l_popup-btn1
    button_2       = l_popup-btn2
    button_3       = l_popup-btn3
    ticon          = l_popup-icon
  IMPORTING
    button_pressed = l_popup-ok_code.

CASE l_popup-ok_code.
  WHEN 1. WRITE 'Yes'.
  WHEN 2. WRITE 'No'.
  WHEN 3. WRITE 'Cancel'.
ENDCASE.
