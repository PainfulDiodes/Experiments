; Bean65 reset vector test - all NOPs, with the reset vector set to a recognisable address

        .setcpu "6502"

; The 8k EEPROM ghosts across the top 32k, so the image is assembled as if at $8000-$9FFF.
; The CPU's reset vector at $FFFC is read from the same EEPROM byte as $9FFC.

ROM_START  = $8000              ; start of the 8k image (EEPROM offset $0000)
RESET_VEC  = $9FFC              ; reset vector - read by the CPU as $FFFC
ROM_END    = $A000              ; end of the 8k image (first address after it)
FILL       = $EA                ; padding byte - NOP

        .org ROM_START

; Padding: .res count, fill - reserves count bytes of fill.
; * is the current address, so RESET_VEC - * is the number of bytes from here
; to the reset vector.

        .res RESET_VEC - *, FILL

        .word $1234             ; reset vector

        .res ROM_END - *, FILL  ; pad to the end of the image
