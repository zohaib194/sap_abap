*--------------------------------------------------------------------*
* Class zcl_conv_exit Definition
*--------------------------------------------------------------------*
CLASS zcl_conv_exit DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS input
      IMPORTING
        i_value TYPE any
      EXPORTING
        e_value TYPE any.

    CLASS-METHODS output
      IMPORTING
        i_value TYPE any
      EXPORTING
        e_value TYPE any.

  PRIVATE SECTION.

    CLASS-METHODS convert
      IMPORTING
        i_value     TYPE any
        i_direction TYPE any
      EXPORTING
        e_value     TYPE any.

ENDCLASS.

*--------------------------------------------------------------------*
* Class zcl_conv_exit Implementation
*--------------------------------------------------------------------*
CLASS zcl_conv_exit IMPLEMENTATION.

  METHOD input.

    convert(
      EXPORTING
        i_value     = i_value
        i_direction = 'INPUT'
      IMPORTING
        e_value     = e_value ).

  ENDMETHOD.

  METHOD output.

    convert(
      EXPORTING
        i_value     = i_value
        i_direction = 'OUTPUT'
      IMPORTING
        e_value     = e_value ).

  ENDMETHOD.

  METHOD convert.

    DATA l_func TYPE funcname VALUE 'CONVERSION_EXIT_&1_&2'.

    DESCRIBE FIELD i_value OUTPUT-LENGTH DATA(l_len)
                           EDIT MASK     DATA(l_mask).

    REPLACE  '=='   IN l_mask WITH space.
    CONDENSE l_mask NO-GAPS.
    CHECK    l_mask IS NOT INITIAL.
    REPLACE  '&1'   IN l_func WITH l_mask.
    REPLACE  '&2'   IN l_func WITH i_direction.

    TRY.
        DATA lo_data TYPE REF TO data.
        CREATE DATA lo_data TYPE c LENGTH l_len.
      CATCH cx_root INTO DATA(l_exc).
        RETURN.
    ENDTRY.

    CHECK  lo_data IS BOUND.
    ASSIGN lo_data->* TO FIELD-SYMBOL(<value>).
    CHECK  <value> IS ASSIGNED.

    CALL FUNCTION l_func
      EXPORTING
        input         = i_value
      IMPORTING
        output        = <value>
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

    e_value = <value>.

  ENDMETHOD.

ENDCLASS.
