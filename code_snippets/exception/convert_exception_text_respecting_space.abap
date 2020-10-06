*--------------------------------------------------------------------*
* Convert Exception Text Respecting Space
*--------------------------------------------------------------------*

DATA g_otr_text TYPE string.
DATA g_msg TYPE symsg.

PERFORM set_demo_exception_text       CHANGING g_otr_text.
PERFORM convert_exception_text_to_msg USING g_otr_text CHANGING g_msg.

MESSAGE i000(55) WITH g_msg-msgv1 g_msg-msgv2 g_msg-msgv3 g_msg-msgv4.

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
*&      Form  CONVERT_EXCEPTION_TEXT_TO_MSG
*&---------------------------------------------------------------------*
FORM convert_exception_text_to_msg USING    i_otr_text
                                   CHANGING c_msg TYPE symsg.

  DATA l_msgv TYPE syst_msgv.
  DATA l_idx  TYPE numc1 VALUE 1.

  SPLIT i_otr_text AT space INTO TABLE DATA(l_msgwords).

  LOOP AT l_msgwords ASSIGNING FIELD-SYMBOL(<msgword>).
    IF ( strlen( l_msgv ) + strlen( | | ) + strlen( <msgword> ) ) LE 50.

      IF l_msgv IS INITIAL.
        l_msgv = <msgword>.
      ELSE.
        l_msgv = l_msgv && | | && <msgword>.
      ENDIF.

      CASE l_idx.
        WHEN 1. c_msg-msgv1 = l_msgv.
        WHEN 2. c_msg-msgv2 = l_msgv.
        WHEN 3. c_msg-msgv3 = l_msgv.
        WHEN 4. c_msg-msgv4 = l_msgv.
      ENDCASE.

      CONTINUE.
    ENDIF.

    l_idx  = l_idx + 1.
    l_msgv = <msgword>.
  ENDLOOP.

ENDFORM.
