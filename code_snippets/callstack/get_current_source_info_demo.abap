*--------------------------------------------------------------------*
* Demo: Get Current Source Info 
*--------------------------------------------------------------------*

REPORT sy-repid.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM demo_level_0.
  SKIP 1.
  ULINE.
  SKIP 1.
  PERFORM demo_level_1.

*&---------------------------------------------------------------------*
*&      Form  DEMO_LEVEL_0
*&---------------------------------------------------------------------*
FORM demo_level_0.

  WRITE: / 'Subroutine:', 'DEMO_LEVEL_0'.

  DATA:
    lv_ignore_levels       TYPE i,
    lv_progname            TYPE dbglprog,
    lv_include             TYPE include,
    lv_eventtype           TYPE dbglevtype,
    lv_eventname           TYPE dbglevent,
    lv_lineno              TYPE i,
    lv_formatted_progname  TYPE dbglprog,
    lv_formatted_eventname TYPE dbglevent.

* Because the SYSTEM_CALLSTACK function is called inside the
* GET_CURRENT_SOURCE_INFO_0 subroutine, no level will be ignored.

  lv_ignore_levels = 0.

  PERFORM get_current_source_info_0
    USING
      lv_ignore_levels
    CHANGING
      lv_progname
      lv_include
      lv_eventtype
      lv_eventname
      lv_lineno
      lv_formatted_progname
      lv_formatted_eventname.

  WRITE:
    / 'Current source info',
    / 'Ignore_levels      :', lv_ignore_levels,
    / 'Progname           :', lv_progname,
    / 'Include            :', lv_include,
    / 'Eventtype          :', lv_eventtype,
    / 'Eventname          :', lv_eventname,
    / 'Lineno             :', lv_lineno,
    / 'Formatted_progname :', lv_formatted_progname,
    / 'Formatted_eventname:', lv_formatted_eventname.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DEMO_LEVEL_1
*&---------------------------------------------------------------------*
FORM demo_level_1.

  WRITE: / 'Subroutine:', 'DEMO_LEVEL_1'.

  DATA:
    lv_ignore_levels       TYPE i,
    lv_progname            TYPE dbglprog,
    lv_include             TYPE include,
    lv_eventtype           TYPE dbglevtype,
    lv_eventname           TYPE dbglevent,
    lv_lineno              TYPE i,
    lv_formatted_progname  TYPE dbglprog,
    lv_formatted_eventname TYPE dbglevent.

* Because the SYSTEM_CALLSTACK function is called in the subroutine
* GET_CURRENT_SOURCE_INFO_1 inside the GET_CURRENT_SOURCE_INFO_1 
* subroutine, one level will be ignored.

  lv_ignore_levels = 1.

  PERFORM get_current_source_info_1
    USING
      lv_ignore_levels
    CHANGING
      lv_progname
      lv_include
      lv_eventtype
      lv_eventname
      lv_lineno
      lv_formatted_progname
      lv_formatted_eventname.

  WRITE:
    / 'Current source info',
    / 'Ignore_levels      :', lv_ignore_levels,
    / 'Progname           :', lv_progname,
    / 'Include            :', lv_include,
    / 'Eventtype          :', lv_eventtype,
    / 'Eventname          :', lv_eventname,
    / 'Lineno             :', lv_lineno,
    / 'Formatted_progname :', lv_formatted_progname,
    / 'Formatted_eventname:', lv_formatted_eventname.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_CURRENT_SOURCE_INFO_0
*&---------------------------------------------------------------------*
FORM get_current_source_info_0
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

  WRITE: / 'Subroutine:', 'GET_CURRENT_SOURCE_INFO_0'.

  DATA:
    ls_callstack TYPE abap_callstack_line,
    lt_callstack TYPE abap_callstack,
    lv_max_level TYPE i,
    lv_offset    TYPE i.

*--------------------------------------------------------------------*

* Determine required call stack level

  IF iv_ignore_levels GT 0.
    lv_max_level = iv_ignore_levels + 2.
  ELSE.
    lv_max_level = 2.
  ENDIF.

*--------------------------------------------------------------------*

* Get callstack data

  CALL FUNCTION 'SYSTEM_CALLSTACK'
    EXPORTING
      max_level = lv_max_level
    IMPORTING
      callstack = lt_callstack.

  CHECK lt_callstack IS NOT INITIAL.

*--------------------------------------------------------------------*

* Get relevant callstack entry

  READ TABLE lt_callstack INTO ls_callstack INDEX lv_max_level.
  IF sy-subrc NE 0.
    READ TABLE lt_callstack INTO ls_callstack INDEX lines( lt_callstack ).
  ENDIF.

*--------------------------------------------------------------------*

* Set export parameters

  ev_progname  = ls_callstack-mainprogram.
  ev_include   = ls_callstack-include.
  ev_eventtype = ls_callstack-blocktype.
  ev_eventname = ls_callstack-blockname.
  ev_lineno    = ls_callstack-line.

*--------------------------------------------------------------------*

* Build formatted progname/classname

  SEARCH ev_progname FOR '='.
  IF sy-fdpos GT 0.
    lv_offset = sy-fdpos + 1.
    ev_formatted_progname = ev_progname+lv_offset.
  ELSE.
    ev_formatted_progname = ev_progname.
  ENDIF.

*--------------------------------------------------------------------*

* Build formatted eventname/methodname

  SEARCH ev_eventname FOR '~'.
  IF sy-fdpos GT 0.
    lv_offset = sy-fdpos + 1.
    ev_formatted_eventname = ev_eventname+lv_offset.
  ELSE.
    ev_formatted_eventname = ev_eventname.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_CURRENT_SOURCE_INFO_1
*&---------------------------------------------------------------------*
FORM get_current_source_info_1
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

  WRITE: / 'Subroutine:', 'GET_CURRENT_SOURCE_INFO_1'.

  PERFORM get_current_source_info_0
    USING
      iv_ignore_levels
    CHANGING
      ev_progname
      ev_include
      ev_eventtype
      ev_eventname
      ev_lineno
      ev_formatted_progname
      ev_formatted_eventname.

ENDFORM.

*--------------------------------------------------------------------*
* Result
*--------------------------------------------------------------------*
* Output
* Subroutine: DEMO_LEVEL_0
* Subroutine: GET_CURRENT_SOURCE_INFO_0
* Current source info
* Ignore_levels      :          0
* Progname           : Y
* Include            : Y
* Eventtype          : FORM
* Eventname          : DEMO_LEVEL_0
* Lineno             :         45
* Formatted_progname : Y
* Formatted_eventname: DEMO_LEVEL_0
*
* Subroutine: DEMO_LEVEL_1
* Subroutine: GET_CURRENT_SOURCE_INFO_1
* Subroutine: GET_CURRENT_SOURCE_INFO_0
* Current source info
* Ignore_levels      :          1
* Progname           : Y
* Include            : Y
* Eventtype          : FORM
* Eventname          : DEMO_LEVEL_1
* Lineno             :         93
* Formatted_progname : Y
* Formatted_eventname: DEMO_LEVEL_1
