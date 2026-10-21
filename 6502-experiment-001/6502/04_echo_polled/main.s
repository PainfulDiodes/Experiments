; Bean65 polled echo test - wait for a character from BeanPort, then wait until
; BeanPort can accept a write, then echo the character back

        .setcpu "6502"

STATUS     = $7F00              ; BeanPort status register (A0 = 0)
DATA       = $7F01              ; BeanPort data register (A0 = 1)
RX_READY   = %00000001          ; status bit 0: a character is waiting to be read
TX_READY   = %00000010          ; status bit 1: BeanPort can accept a write

; The 8k EEPROM ghosts across the top 32k, so the image is assembled as if at $8000-$9FFF.
; The CPU's reset vector at $FFFC is read from the same EEPROM byte as $9FFC.

ROM_START  = $8000              ; start of the 8k image (EEPROM offset $0000)
RESET_VEC  = $9FFC              ; reset vector - read by the CPU as $FFFC
ROM_END    = $A000              ; end of the 8k image (first address after it)
FILL       = $EA                ; padding byte - NOP

        .org ROM_START

reset:
rx_wait:
        LDA STATUS              ; wait until a character is waiting
        AND #RX_READY
        BEQ rx_wait
        LDX DATA                ; read it into X

tx_wait:
        LDA STATUS              ; wait until BeanPort can accept a write
        AND #TX_READY
        BEQ tx_wait
        STX DATA                ; echo it

        JMP rx_wait

; Padding: .res count, fill - reserves count bytes of fill.
; * is the current address, so RESET_VEC - * is the number of bytes from here
; to the reset vector.

        .res RESET_VEC - *, FILL

        .word reset             ; reset vector

        .res ROM_END - *, FILL  ; pad to the end of the image
