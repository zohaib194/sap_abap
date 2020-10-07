*--------------------------------------------------------------------*
* ZCL_RTTS_UTIL - RTTS Utility Class
*--------------------------------------------------------------------*

CLASS zcl_rtts_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_components
      IMPORTING
        !i_value         TYPE any
      RETURNING
        VALUE(rt_fields) TYPE ddfields .

    CLASS-METHODS get_fieldcat
      IMPORTING
        !i_value           TYPE any
      RETURNING
        VALUE(rt_fieldcat) TYPE lvc_t_fcat .

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_rtts_util IMPLEMENTATION.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RTTS_UTIL=>GET_COMPONENTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VALUE                        TYPE        ANY
* | [<-()] RT_FIELDS                      TYPE        DDFIELDS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_components.

    DATA:
      lo_type_descr  TYPE REF TO cl_abap_typedescr,
      lo_elem_descr  TYPE REF TO cl_abap_elemdescr,
      lo_struc_descr TYPE REF TO cl_abap_structdescr,
      lo_table_descr TYPE REF TO cl_abap_tabledescr.

    CLEAR rt_fields.

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
          APPEND ls_flddescr TO rt_fields.
        ENDIF.

      WHEN cl_abap_typedescr=>kind_struct.
        TRY .
            lo_struc_descr ?= lo_type_descr.
          CATCH cx_sy_move_cast_error.
        ENDTRY.

        CHECK lo_struc_descr IS BOUND.

        lo_struc_descr->get_ddic_field_list(
          RECEIVING
            p_field_list = rt_fields
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
            p_field_list = rt_fields
          EXCEPTIONS
            not_found    = 1
            no_ddic_type = 2
            OTHERS       = 3 ).
    ENDCASE.

  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RTTS_UTIL=>GET_FIELDCAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VALUE                        TYPE        ANY
* | [<-()] RT_FIELDCAT                    TYPE        LVC_T_FCAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_fieldcat.

    LOOP AT get_components( i_value ) ASSIGNING FIELD-SYMBOL(<ls_field>).
      APPEND INITIAL LINE TO rt_fieldcat ASSIGNING FIELD-SYMBOL(<ls_fieldcat>).

      IF <ls_fieldcat> IS ASSIGNED.
        MOVE-CORRESPONDING <ls_field> TO <ls_fieldcat>.
        <ls_fieldcat>-ref_table      = <ls_field>-reftable.
        <ls_fieldcat>-ref_field      = <ls_field>-reffield.
        <ls_fieldcat>-key            = <ls_field>-keyflag.
        <ls_fieldcat>-decfloat_style = <ls_field>-outputstyle.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
