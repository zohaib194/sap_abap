*--------------------------------------------------------------------*
* Demo: Generate Field Catalog Using Class CL_SALV_TABLE
*--------------------------------------------------------------------*

REPORT sy-repid.

*--------------------------------------------------------------------*
* TYPES
*--------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_outtab,
    mark   TYPE xfeld,
    chkbox TYPE xfeld,
    field1 TYPE char10,
    field2 TYPE char20,
    field3 TYPE char30,
    dummy  TYPE char1,
  END OF ty_s_outtab.

*--------------------------------------------------------------------*
* DATA
*--------------------------------------------------------------------*
DATA:
  gs_outtab   TYPE ty_s_outtab,
  gt_outtab   TYPE TABLE OF ty_s_outtab,
  gs_layout   TYPE lvc_s_layo,
  gt_fieldcat TYPE lvc_t_fcat,
  go_alv_grid TYPE REF TO cl_gui_alv_grid.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM alv_fill_outtab.
  PERFORM alv_layout_change     CHANGING gs_layout.
  PERFORM alv_fieldcat_generate USING    gt_outtab CHANGING gt_fieldcat.
  PERFORM alv_fieldcat_change   CHANGING gt_fieldcat.
  PERFORM alv_display_outtab    USING    gs_layout gt_fieldcat gt_outtab.

*&---------------------------------------------------------------------*
*& Form ALV_FILL_OUTTAB
*&---------------------------------------------------------------------*
FORM alv_fill_outtab .

  DEFINE append_outtab.
    CLEAR gs_outtab.
    gs_outtab-field1 = &1.
    gs_outtab-field2 = &2.
    gs_outtab-field3 = &3.
    APPEND gs_outtab TO gt_outtab.
  END-OF-DEFINITION.

  append_outtab:
    'Value 1' 'Value 0001' 'Value 000000000001',
    'Value 2' 'Value 0002' 'Value 000000000002',
    'Value 3' 'Value 0003' 'Value 000000000003',
    'Value 4' 'Value 0004' 'Value 000000000004',
    'Value 5' 'Value 0005' 'Value 000000000005'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ALV_LAYOUT_CHANGE
*&---------------------------------------------------------------------*
FORM alv_layout_change
  CHANGING
    cs_layout TYPE lvc_s_layo.

  cs_layout-cwidth_opt = abap_true.
  cs_layout-box_fname  = 'MARK'.
  cs_layout-zebra      = abap_true.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ALV_FIELDCAT_GENERATE
*&---------------------------------------------------------------------*
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
      " Build a local copy from the import table because it
      " should not be sent to CL_SALV_TABLE=>FACTORY.

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

*&---------------------------------------------------------------------*
*& Form ALV_FIELDCAT_CHANGE
*&---------------------------------------------------------------------*
FORM alv_fieldcat_change
  CHANGING
    ct_fieldcat TYPE lvc_t_fcat.

  FIELD-SYMBOLS:
    <ls_fieldcat> TYPE lvc_s_fcat.

  DEFINE fieldcat_set_text.
    IF <ls_fieldcat> IS ASSIGNED.
      <ls_fieldcat>-scrtext_s  = &1.
      <ls_fieldcat>-scrtext_m  = &2.
      <ls_fieldcat>-scrtext_l  = &3.
      <ls_fieldcat>-colddictxt = ''.  "S,M,L,R
      <ls_fieldcat>-selddictxt = 'L'. "S,M,L,R
      <ls_fieldcat>-tipddictxt = 'L'. "S,M,L,R
    ENDIF.
  END-OF-DEFINITION.

  LOOP AT ct_fieldcat ASSIGNING <ls_fieldcat>.
    CASE <ls_fieldcat>-fieldname.
      WHEN 'MARK'.
        <ls_fieldcat>-tech = abap_true.

      WHEN 'CHKBOX'.
        <ls_fieldcat>-checkbox = abap_true.
        fieldcat_set_text 'Chkbox'   'Checkbox'  'Checkbox'.

      WHEN 'FIELD1'.
        fieldcat_set_text 'F1-short' 'F1-medium' 'F1-long text'.

      WHEN 'FIELD2'.
        fieldcat_set_text 'F2-short' 'F2-medium' 'F2-long text'.

      WHEN 'FIELD3'.
        fieldcat_set_text 'F3-short' 'F3-medium' 'F3-long text'.

      WHEN OTHERS.
        <ls_fieldcat>-tech = abap_true.
    ENDCASE.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ALV_DISPLAY_OUTTAB
*&---------------------------------------------------------------------*
FORM alv_display_outtab
  USING
    is_layout   TYPE lvc_s_layo
    it_fieldcat TYPE lvc_t_fcat
    it_outtab   TYPE table.

  CHECK it_fieldcat IS NOT INITIAL.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      is_layout_lvc   = is_layout
      it_fieldcat_lvc = it_fieldcat
    TABLES
      t_outtab        = it_outtab
    EXCEPTIONS
      OTHERS          = 2.

ENDFORM.
