*--------------------------------------------------------------------*
* Display Exception Text in Popup
*--------------------------------------------------------------------*

DATA g_otr_text TYPE string.
DATA g_msg TYPE symsg.

PERFORM set_demo_exception_text CHANGING g_otr_text.
PERFORM display_exception_text  USING    g_otr_text.

*&---------------------------------------------------------------------*
*&      Form  SET_DEMO_EXCEPTION_TEXT
*&---------------------------------------------------------------------*
FORM set_demo_exception_text CHANGING c_otr_text.

  " sotr_text-concept
  "   sotr_text-text
  " 12C82F2775C8564A8D8C85C02864E109
  "   A dynamic call of the method &methodname& of the class
  "   &classname& failed; there is a type error in the parameter
  "   &parameter&.

  DATA l_msg  TYPE symsg.
  DATA l_msgv TYPE syst_msgv.
  DATA l_idx  TYPE numc1 VALUE 1.

  CALL METHOD cl_message_helper=>get_otr_text_raw
    EXPORTING
      textid = '12C82F2775C8564A8D8C85C02864E109'
    IMPORTING
      result = DATA(l_otr_text).

  REPLACE '&classname&'  IN l_otr_text WITH 'CL_SYSTEM_TRANSACTION_STATE'.
  REPLACE '&methodname&' IN l_otr_text WITH 'GET_ON_END_OF_TRANSACTION'.
  REPLACE '&parameter&'  IN l_otr_text WITH 'ON_END_OF_TRANSACTION'.

  c_otr_text = l_otr_text.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_EXCEPTION_TEXT
*&---------------------------------------------------------------------*
FORM display_exception_text USING i_otr_text.

  DATA l_msgv TYPE c LENGTH 60.
  DATA l_idx  TYPE numc1 VALUE 1.

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

  SPLIT i_otr_text AT space INTO TABLE DATA(l_msgwords).

  LOOP AT l_msgwords ASSIGNING FIELD-SYMBOL(<msgword>).
    IF ( strlen( l_msgv ) + strlen( | | ) + strlen( <msgword> ) ) LE 60.

      IF l_msgv IS INITIAL.
        l_msgv = <msgword>.
      ELSE.
        l_msgv = l_msgv && | | && <msgword>.
      ENDIF.

      CASE l_idx.
        WHEN 1. l_popup-txt1 = l_msgv.
        WHEN 2. l_popup-txt2 = l_msgv.
        WHEN 3. l_popup-txt3 = l_msgv.
        WHEN 4. l_popup-txt4 = l_msgv.
        WHEN 5. l_popup-txt5 = l_msgv.
        WHEN 6. l_popup-txt6 = l_msgv.
      ENDCASE.

      CONTINUE.
    ENDIF.

    l_idx  = l_idx + 1.
    l_msgv = <msgword>.
  ENDLOOP.

  l_popup-titl = 'Message'.
  l_popup-icon = 'E'. "(I)nfo, (W)arning, (E)rror, (Q)uestion, (C)ritical
  l_popup-btn1 = icon_close && 'Close'.

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

ENDFORM.
