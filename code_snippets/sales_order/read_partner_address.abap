*--------------------------------------------------------------------*
* Sales Order - Read Partner Address
*--------------------------------------------------------------------*

TABLES:
  vbak.

SELECT-OPTIONS:
  s_vbeln FOR vbak-vbeln.

PARAMETERS:
  p_parvw TYPE vbpa-parvw DEFAULT 'AG'.

DATA:
  ls_vbeln TYPE tms_s_vbeln_range,
  lt_vbeln TYPE tms_t_vbeln_range.

LOOP AT s_vbeln ASSIGNING FIELD-SYMBOL(<s_vbeln>).
  ls_vbeln = <s_vbeln>.
  COLLECT ls_vbeln INTO lt_vbeln.
ENDLOOP.

CHECK lt_vbeln IS NOT INITIAL.

SELECT
    vbpa~vbeln,
    adrc~name1
  FROM
    vbpa
  INNER JOIN
    adrc ON vbpa~adrnr EQ adrc~addrnumber
  INTO TABLE @DATA(lt_output)
  WHERE
    vbpa~parvw EQ @p_parvw AND
    vbpa~vbeln IN @lt_vbeln.

cl_demo_output=>display( lt_output ).
