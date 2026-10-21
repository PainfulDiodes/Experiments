; Bean65 port read test - read a memory mapped "port" with absolute addressing, NOP, loop

        .setcpu "6502"

; The 8k EEPROM ghosts across the top 32k, so the image is assembled as if at $8000-$9FFF.
; The CPU's reset vector at $FFFC is read from the same EEPROM byte as $9FFC.

ROM_START  = $8000              ; start of the 8k image (EEPROM offset $0000)
RESET_VEC  = $9FFC              ; reset vector - read by the CPU as $FFFC
ROM_END    = $A000              ; end of the 8k image (first address after it)
FILL       = $EA                ; padding byte - NOP

; With no address decoding the EEPROM ghosts across all 64k, so a byte in the image
; acts as the port: $4321 and $8321 are the same EEPROM byte (offset $0321)

PORT       = $4321              ; the "port" address read by the program
PORT_BYTE  = $8321              ; where the port byte sits in the image

        .org ROM_START

reset:  LDA PORT                ; single read of the port
        NOP
        JMP reset

; Padding: .res count, fill - reserves count bytes of fill.
; * is the current address, so PORT_BYTE - * is the number of bytes from here
; to the port byte, and RESET_VEC - * from there to the reset vector.

        .res PORT_BYTE - *, FILL

        .byte $A5               ; the "port" value - a distinctive value

        .res RESET_VEC - *, FILL

        .word reset             ; reset vector

        .res ROM_END - *, FILL  ; pad to the end of the image
