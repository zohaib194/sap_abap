*&---------------------------------------------------------------------*
*&      Form  READ_SINGLE_TEXT
*&---------------------------------------------------------------------*
*       Read Single Text
*----------------------------------------------------------------------*
FORM read_single_text
  USING
    iv_id       TYPE thead-tdid
    iv_language TYPE thead-tdspras
    iv_name     TYPE thead-tdname
    iv_object   TYPE thead-tdobject
  CHANGING
    ev_text     TYPE clike.

  DATA:
    lt_lines TYPE TABLE OF tline.

  CLEAR: lt_lines, ev_text.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id       = iv_id
      language = iv_language
      name     = iv_name
      object   = iv_object
    TABLES
      lines    = lt_lines
    EXCEPTIONS
      OTHERS   = 8.

  LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<ls_lines>).
    CONCATENATE ev_text <ls_lines>-tdline INTO ev_text.
    CONCATENATE ev_text space INTO ev_text RESPECTING BLANKS.
  ENDLOOP.

ENDFORM.
