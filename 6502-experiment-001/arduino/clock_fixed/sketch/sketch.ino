// Fixed 6502 clock from Timer 1 - based on Nick Gammon's timer examples:
// https://www.gammon.com.au/forum/?id=11504
// Fast PWM mode with ICR1 as TOP, output on OC1A (Mega pin 11)

const byte CLK = 11;              // Timer 1 "A" output: OC1A - 6502 pin 37
const byte RESET = 32;            // 6502 pin 40 (active low)
const long frequency = 2000000L;  // 2MHz

void setup ()
{
  pinMode (CLK, OUTPUT);
  TCCR1A = bit (WGM11) | bit (COM1A1);
  TCCR1B = bit (WGM12) | bit (WGM13) | bit (CS10);
  ICR1 = (F_CPU / frequency) - 1;       // period
  OCR1A = ((ICR1 + 1) / 2) - 1;         // 50% duty cycle

  // reset the 6502 now the clock is running
  pinMode (RESET, OUTPUT);
  digitalWrite (RESET, LOW);
  delay (10);
  digitalWrite (RESET, HIGH);
}

void loop () { }
