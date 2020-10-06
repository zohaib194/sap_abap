TYPES:
  BEGIN OF ty_s_matnr,
    in  TYPE mara-matnr,
    out TYPE mara-matnr,
  END OF ty_s_matnr.

DATA:
  gs_matnr TYPE ty_s_matnr,
  gt_matnr TYPE TABLE OF ty_s_matnr.

gs_matnr-in = '33'.

zcl_conv_exit=>input(
    EXPORTING
      i_value = gs_matnr-in
    IMPORTING
      e_value = gs_matnr-out ).

APPEND gs_matnr TO gt_matnr.

gs_matnr-in = '0000000000000033'.

zcl_conv_exit=>output(
    EXPORTING
      i_value = gs_matnr-in
    IMPORTING
      e_value = gs_matnr-out ).

APPEND gs_matnr TO gt_matnr.

cl_demo_output=>display( data = gt_matnr
                         name = 'Result' ).
