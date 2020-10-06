*--------------------------------------------------------------------*
* Restrict Select-Options
*--------------------------------------------------------------------*

REPORT sy-repid.

TABLES t100.

*--------------------------------------------------------------------*
* SELECTION-SCREEN
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
SELECT-OPTIONS s_selop1 FOR t100-arbgb.
SELECT-OPTIONS s_selop2 FOR t100-arbgb.
SELECT-OPTIONS s_selop3 FOR t100-arbgb.
SELECT-OPTIONS s_selop4 FOR t100-arbgb.
SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
* INITIALIZATION
*--------------------------------------------------------------------*
INITIALIZATION.
  PERFORM selscr_restrict_selopt USING 'S_SELOP1' '__X_______'.
  PERFORM selscr_restrict_selopt USING 'S_SELOP2' '_________X'.
  PERFORM selscr_restrict_selopt USING 'S_SELOP3' '_______XXX'.
  PERFORM selscr_restrict_selopt USING 'S_SELOP4' '___XXXX___'.
  PERFORM selscr_restrict_selopt USING '' ''. "<<-- final call

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  SELSCR_RESTRICT_SELOPT
*&---------------------------------------------------------------------*
FORM selscr_restrict_selopt
  USING
    iv_name
    VALUE(iv_options). "BT CP EQ GE GT LE LT NB NE NP

  STATICS lt_restrict TYPE sscr_restrict.

  IF iv_name IS NOT INITIAL.

    " Replace all chars with 'space' except 'X'.
    REPLACE ALL OCCURRENCES OF REGEX '[^X]'
      IN iv_options WITH | | IGNORING CASE.

    " Fill restriction
    APPEND INITIAL LINE TO lt_restrict-opt_list_tab
         ASSIGNING FIELD-SYMBOL(<ls_opt_list>).

    <ls_opt_list>-name    = iv_name && '_1'.
    <ls_opt_list>-options = iv_options.

    APPEND INITIAL LINE TO lt_restrict-ass_tab
         ASSIGNING FIELD-SYMBOL(<ls_associat>).

    <ls_associat>-kind    = 'S'.
    <ls_associat>-name    = iv_name.
    <ls_associat>-sg_main = '*'.
    <ls_associat>-sg_addy = '*'.
    <ls_associat>-op_main = iv_name && '_1'.
    <ls_associat>-op_addy = iv_name && '_1'.

  ELSE.

    " Apply restriction
    SORT lt_restrict-opt_list_tab BY name.
    DELETE ADJACENT DUPLICATES FROM lt_restrict-opt_list_tab
                          COMPARING name.

    SORT lt_restrict-ass_tab BY name.
    DELETE ADJACENT DUPLICATES FROM lt_restrict-ass_tab
                          COMPARING name.

    CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
      EXPORTING
        restriction            = lt_restrict
      EXCEPTIONS
        too_late               = 1
        repeated               = 2
        selopt_without_options = 3
        selopt_without_signs   = 4
        invalid_sign           = 5
        empty_option_list      = 6
        invalid_kind           = 7
        repeated_kind_a        = 8
        OTHERS                 = 9.

    IF sy-subrc NE 0.
      MESSAGE 'Selection screen restriction could not be applied!'
         TYPE 'I'.
    ENDIF.

  ENDIF.

ENDFORM.
