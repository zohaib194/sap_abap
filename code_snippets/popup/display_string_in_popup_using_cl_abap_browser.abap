*--------------------------------------------------------------------*
* Display String in Popup Using CL_ABAP_BROWSER
*--------------------------------------------------------------------*

DATA l_gui_on.
DATA l_string TYPE string.

CALL FUNCTION 'GUI_IS_AVAILABLE'
  IMPORTING
    return = l_gui_on.

IF l_gui_on IS INITIAL.
  RETURN.
ENDIF.

CONCATENATE
    '<html><body>'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
    'sed do eiusmod tempor incididunt ut labore et dolore magna'
    'aliqua. Ut enim ad minim veniam, quis nostrud exercitation'
    'ullamco laboris nisi ut aliquip ex ea commodo consequat.'
    'Duis aute irure dolor in reprehenderit in voluptate velit'
    'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint'
    'occaecat cupidatat non proident, sunt in culpa qui officia'
    'deserunt mollit anim id est laborum.'
    '</body></html>'
  INTO l_string.

CALL METHOD cl_abap_browser=>show_html
  EXPORTING
    title       = 'Title'
    size        = cl_abap_browser=>small
    html_string = l_string.
