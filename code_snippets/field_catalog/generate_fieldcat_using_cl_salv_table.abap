*&---------------------------------------------------------------------*
*&      Form  ALV_FIELDCAT_GENERATE
*&---------------------------------------------------------------------*
*       Generate Field Catalog Using CL_SALV_TABLE
*----------------------------------------------------------------------*
FORM alv_fieldcat_generate
  USING
    it_table    TYPE table
  CHANGING
    ct_fieldcat TYPE lvc_t_fcat.

  DATA:
    lr_table TYPE REF TO data.

  FIELD-SYMBOLS:
    <lt_table> TYPE ANY TABLE.

  TRY .
      " Get a local copy from the import table because
      " it should not be sent to CL_SALV_TABLE=>FACTORY.

      GET REFERENCE OF it_table INTO lr_table.
      ASSIGN lr_table->* TO <lt_table>.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(lr_salv_table)
        CHANGING
          t_table      = <lt_table> ).

      ct_fieldcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
        r_columns      = lr_salv_table->get_columns( )
        r_aggregations = lr_salv_table->get_aggregations( ) ).

    CATCH cx_root.
  ENDTRY.

ENDFORM.
