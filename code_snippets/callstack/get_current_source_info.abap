*&---------------------------------------------------------------------*
*&      Form  GET_CURRENT_SOURCE_INFO
*&---------------------------------------------------------------------*
*       Get Current Source Info (SYSTEM_CALLSTACK)
*----------------------------------------------------------------------*
FORM get_current_source_info
  USING
    iv_ignore_levels       TYPE i
  CHANGING
    ev_progname            TYPE dbglprog
    ev_include             TYPE include
    ev_eventtype           TYPE dbglevtype
    ev_eventname           TYPE dbglevent
    ev_lineno              TYPE numeric
    ev_formatted_progname  TYPE dbglprog
    ev_formatted_eventname TYPE dbglevent.

  DATA:
    ls_callstack TYPE abap_callstack_line,
    lt_callstack TYPE abap_callstack,
    lv_max_level TYPE i,
    lv_offset    TYPE i.

* Determine required call stack level

  IF iv_ignore_levels GT 0.
    lv_max_level = iv_ignore_levels + 2.
  ELSE.
    lv_max_level = 2.
  ENDIF.

* Get callstack data

  CALL FUNCTION 'SYSTEM_CALLSTACK'
    EXPORTING
      max_level = lv_max_level
    IMPORTING
      callstack = lt_callstack.

  CHECK lt_callstack IS NOT INITIAL.

* Get relevant callstack entry

  READ TABLE lt_callstack INTO ls_callstack INDEX lv_max_level.
  IF sy-subrc NE 0.
    READ TABLE lt_callstack INTO ls_callstack INDEX lines( lt_callstack ).
  ENDIF.

* Set export parameters

  ev_progname  = ls_callstack-mainprogram.
  ev_include   = ls_callstack-include.
  ev_eventtype = ls_callstack-blocktype.
  ev_eventname = ls_callstack-blockname.
  ev_lineno    = ls_callstack-line.

* Build formatted progname/classname

  SEARCH ev_progname FOR '='.
  IF sy-fdpos GT 0.
    lv_offset = sy-fdpos + 1.
    ev_formatted_progname = ev_progname+lv_offset.
  ELSE.
    ev_formatted_progname = ev_progname.
  ENDIF.

* Build formatted eventname/methodname

  SEARCH ev_eventname FOR '~'.
  IF sy-fdpos GT 0.
    lv_offset = sy-fdpos + 1.
    ev_formatted_eventname = ev_eventname+lv_offset.
  ELSE.
    ev_formatted_eventname = ev_eventname.
  ENDIF.

ENDFORM.
