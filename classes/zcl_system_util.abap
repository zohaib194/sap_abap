* <not yet completed>

*--------------------------------------------------------------------*
* ZCL_SYSTEM_UTIL
* System Utility Class
*--------------------------------------------------------------------*

CLASS zcl_system_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_current_source_info
      IMPORTING
        !iv_ignore_levels       TYPE i DEFAULT 0
      EXPORTING
        !ev_progname            TYPE dbglprog
        !ev_include             TYPE include
        !ev_eventtype           TYPE dbglevtype
        !ev_eventname           TYPE dbglevent
        !ev_lineno              TYPE numeric
        !ev_formatted_progname  TYPE dbglprog
        !ev_formatted_eventname TYPE dbglevent .
    
  PROTECTED SECTION.
  PRIVATE SECTION.
  
ENDCLASS.

CLASS zcl_system_util IMPLEMENTATION.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_SYSTEM_UTIL=>GET_CURRENT_SOURCE_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_IGNORE_LEVELS               TYPE        I (default =0)
* | [<---] EV_PROGNAME                    TYPE        DBGLPROG
* | [<---] EV_INCLUDE                     TYPE        INCLUDE
* | [<---] EV_EVENTTYPE                   TYPE        DBGLEVTYPE
* | [<---] EV_EVENTNAME                   TYPE        DBGLEVENT
* | [<---] EV_LINENO                      TYPE        NUMERIC
* | [<---] EV_FORMATTED_PROGNAME          TYPE        DBGLPROG
* | [<---] EV_FORMATTED_EVENTNAME         TYPE        DBGLEVENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_current_source_info.
    "importing iv_ignore_levels       type i default 0
    "exporting ev_progname            type dbglprog
    "exporting ev_include             type include
    "exporting ev_eventtype           type dbglevtype
    "exporting ev_eventname           type dbglevent
    "exporting ev_lineno              type numeric
    "exporting ev_formatted_progname  type dbglprog
    "exporting ev_formatted_eventname type dbglevent

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

  ENDMETHOD.

ENDCLASS.
