*--------------------------------------------------------------------*
* Demo: Generate Fieldcat Using RTTS Services
*--------------------------------------------------------------------*

DATA gt_t100 TYPE TABLE OF t100.
DATA lt_fieldcat TYPE lvc_t_fcat.

SELECT * FROM t100 INTO TABLE lt_t100 UP TO 33 ROWS.

PERFORM get_fieldcat USING lt_t100 CHANGING lt_fieldcat.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
  EXPORTING
    i_callback_program = sy-repid
    it_fieldcat_lvc    = lt_fieldcat
  TABLES
    t_outtab           = lt_t100
  EXCEPTIONS
    OTHERS             = 2.

*&---------------------------------------------------------------------*
*&      Form  GET_FIELDCAT
*&---------------------------------------------------------------------*
*       Generate Fieldcat Using RTTS Services
*----------------------------------------------------------------------*
FORM get_fieldcat USING    i_value     TYPE any
                  CHANGING et_fieldcat TYPE lvc_t_fcat.

  DATA:
    lo_type_descr  TYPE REF TO cl_abap_typedescr,
    lo_elem_descr  TYPE REF TO cl_abap_elemdescr,
    lo_struc_descr TYPE REF TO cl_abap_structdescr,
    lo_table_descr TYPE REF TO cl_abap_tabledescr.

  DATA:
    lt_fields TYPE ddfields.

  DESCRIBE FIELD i_value TYPE DATA(l_type).

  CASE l_type.
    WHEN cl_abap_typedescr=>typekind_char.
      IF strlen( i_value ) EQ 0.
        CALL METHOD cl_abap_typedescr=>describe_by_data
          EXPORTING
            p_data      = i_value
          RECEIVING
            p_descr_ref = lo_type_descr.
      ELSE.
        CALL METHOD cl_abap_typedescr=>describe_by_name
          EXPORTING
            p_name         = i_value
          RECEIVING
            p_descr_ref    = lo_type_descr
          EXCEPTIONS
            type_not_found = 1
            OTHERS         = 2.
      ENDIF.

    WHEN OTHERS.
      CALL METHOD cl_abap_typedescr=>describe_by_data
        EXPORTING
          p_data      = i_value
        RECEIVING
          p_descr_ref = lo_type_descr.
  ENDCASE.

  CHECK lo_type_descr IS BOUND.

  CASE lo_type_descr->kind.
    WHEN cl_abap_typedescr=>kind_elem.
      TRY .
          lo_elem_descr ?= lo_type_descr.
        CATCH cx_sy_move_cast_error.
      ENDTRY.

      CHECK lo_elem_descr IS BOUND.

      lo_elem_descr->get_ddic_field(
        RECEIVING
          p_flddescr   = DATA(ls_flddescr)
        EXCEPTIONS
          not_found    = 1
          no_ddic_type = 2
          OTHERS       = 3 ).

      IF sy-subrc EQ 0.
        APPEND ls_flddescr TO lt_fields.
      ENDIF.

    WHEN cl_abap_typedescr=>kind_struct.
      TRY .
          lo_struc_descr ?= lo_type_descr.
        CATCH cx_sy_move_cast_error.
      ENDTRY.

      CHECK lo_struc_descr IS BOUND.

      lo_struc_descr->get_ddic_field_list(
        RECEIVING
          p_field_list = lt_fields
        EXCEPTIONS
          not_found    = 1
          no_ddic_type = 2
          OTHERS       = 3 ).

    WHEN cl_abap_typedescr=>kind_table.
      TRY .
          lo_table_descr ?= lo_type_descr.
          lo_struc_descr ?= lo_table_descr->get_table_line_type( ).
        CATCH cx_sy_move_cast_error.
      ENDTRY.

      CHECK lo_struc_descr IS BOUND.

      lo_struc_descr->get_ddic_field_list(
        RECEIVING
          p_field_list = lt_fields
        EXCEPTIONS
          not_found    = 1
          no_ddic_type = 2
          OTHERS       = 3 ).
  ENDCASE.

  LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<ls_field>).
    APPEND INITIAL LINE TO et_fieldcat ASSIGNING FIELD-SYMBOL(<ls_fieldcat>).

    IF <ls_fieldcat> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_field> TO <ls_fieldcat>.
      <ls_fieldcat>-ref_table      = <ls_field>-reftable.
      <ls_fieldcat>-ref_field      = <ls_field>-reffield.
      <ls_fieldcat>-key            = <ls_field>-keyflag.
      <ls_fieldcat>-decfloat_style = <ls_field>-outputstyle.
      UNASSIGN <ls_fieldcat>.
    ENDIF.
  ENDLOOP.

ENDFORM.
