; Bean65 NOP test - the whole 8k EEPROM is NOPs ($EA), including the reset vector,
; so the 6502 starts at $EAEA - which is NOPs too

        .setcpu "6502"

ROM_SIZE   = $2000              ; 8k EEPROM
FILL       = $EA                ; NOP

        .res ROM_SIZE, FILL     ; the whole image is NOPs
