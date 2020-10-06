*&---------------------------------------------------------------------*
*&      Form  CALL_SMART_FORM
*&---------------------------------------------------------------------*
*       Call Smart Form
*----------------------------------------------------------------------*
FORM call_smart_form.

  DATA:
    BEGIN OF ls_ssf,
      sf_name              TYPE tdsfname,
      fm_name              TYPE rs38l_fnam,
      control_parameters   TYPE ssfctrlop,
      output_options       TYPE ssfcompop,
      document_output_info TYPE ssfcrespd,
      job_output_info      TYPE ssfcrescl,
      job_output_options   TYPE ssfcresop,
    END OF ls_ssf.

  DATA:
    BEGIN OF ls_ssf_data,
      cover_data TYPE bcss_faxcv,
    END OF ls_ssf_data.

  ls_ssf-sf_name = 'BCS_FAX_COVER'.
  
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = ls_ssf-sf_name
    IMPORTING
      fm_name            = ls_ssf-fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  IF sy-subrc NE 0.
    " Error reading function module for smartform &.
    MESSAGE i534(sls) WITH ls_ssf-sf_name.
    RETURN.
  ENDIF.

  CALL FUNCTION ls_ssf-fm_name
    EXPORTING
      control_parameters   = ls_ssf-control_parameters
      output_options       = ls_ssf-output_options
      cover_data           = ls_ssf-cover_data
    IMPORTING
      document_output_info = ls_ssf-document_output_info
      job_output_info      = ls_ssf-job_output_info
      job_output_options   = ls_ssf-job_output_options
    EXCEPTIONS
      formatting_error     = 1
      internal_error       = 2
      send_error           = 3
      user_canceled        = 4
      OTHERS               = 5.

  IF sy-subrc NE 0.
    " Error while printing smart form &1
    MESSAGE i051(n2ds) WITH ls_ssf-sf_name.
    RETURN.
  ENDIF.

ENDFORM.
