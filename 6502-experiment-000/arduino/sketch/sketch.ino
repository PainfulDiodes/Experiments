// 6502 bus monitor for Arduino Mega 2560
// Drives the 6502 clock, feeds NOP ($EA) on every CPU read,
// and logs address (hex), data (hex) and R/W (binary)
// Serial commands: space = single step, c = run at 4Hz, v = stop

// Address Bus
const char A[] = {A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15}; // 6502 9-20,22-25 Output

// Data Bus
const char D[] = {22,23,24,25,26,27,28,29}; // 6502 33-26 Input/Output

// Control
const char RW =    30; // 6502 34 Output (high = read)
const char RESET = 32; // 6502 40 Input (active low)

// Clock
const char CLK =   31; // 6502 37 (PHI2) Input

const byte NOP = 0xEA;

bool running = false;

void setup() {
  Serial.begin(115200);

  // digital pins default to input mode

  pinMode(CLK, OUTPUT);
  pinMode(RESET, OUTPUT);

  // Hold RESET low for a few clock cycles, then release
  digitalWrite(RESET, LOW);
  for (int i = 0; i < 5; i++) {
    digitalWrite(CLK, HIGH);
    digitalWrite(CLK, LOW);
  }
  digitalWrite(RESET, HIGH);

  Serial.println("space = step, c = run, v = stop");
  Serial.println("addr data rw");
}

void loop() {
  if (Serial.available() > 0) {
    char c = Serial.read();
    if (c == ' ') clockCycle();
    if (c == 'c') running = true;
    if (c == 'v') running = false;
  }

  if (running) clockCycle();
}

// One full clock cycle: falling edge, then rising edge, then log
void clockCycle() {
  // Clock low, release the data bus
  digitalWrite(CLK, LOW);
  for (int i = 0; i < 8; i++) pinMode(D[i], INPUT);
  delay(125);

  unsigned int a = 0;
  for (int i = 0; i < 16; i++) bitWrite(a, i, digitalRead(A[i]));
  int rw = digitalRead(RW);

  // CPU read: drive NOP onto the data bus before the clock goes high
  if (rw == HIGH) {
    for (int i = 0; i < 8; i++) {
      pinMode(D[i], OUTPUT);
      digitalWrite(D[i], bitRead(NOP, i));
    }
  }

  // Clock high
  digitalWrite(CLK, HIGH);
  delay(125);

  byte d = 0;
  for (int i = 0; i < 8; i++) bitWrite(d, i, digitalRead(D[i]));

  char s[16];
  sprintf(s, "%04X %02X   %d", a, d, rw);
  Serial.println(s);
}
