*--------------------------------------------------------------------*
* Replace All Chars with 'space' Except 'X' using REGEX
*--------------------------------------------------------------------*

DATA l_text TYPE string VALUE 'y__X__y'.

REPLACE ALL OCCURRENCES OF REGEX '[^X]' IN l_text WITH | | IGNORING CASE.
WRITE |.| && l_text && |.|.

*--------------------------------------------------------------------*
* Result
*--------------------------------------------------------------------*
* .   X   .
