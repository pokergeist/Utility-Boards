/*************************************************************
 * Power Loss Alarm
 *
 * 2022-01-23  Added alarm routine, multitone.
 * 2021-12-19  Added disable beeper on reset.
 * 2021-11-30  Original.
 *************************************************************/

// MCU: ItsyBitsy 32u4. 3v3, 8 MHz (Adafruit #3675)
// TDK PS1420P02CT Piezo Buzzer sans oscillator.

// pin definitions
#define PWR_SENSE   A11         // GPIO 12
#define TONE_OUT     11         // PWM
#define LED_EXTERNAL 10
#define CHARGE_STATUS 7

#define EXT_LED_OFF  HIGH
#define EXT_LED_ON   LOW

#define ALARM_TIME_ON    750
#define ALARM_TIME_OFF    50
#define ALARM_FREQ      1940
//#define ALARM_FREQ_ALT  2744
#define ALARM_FREQ_ALT   729

#define NOTIFY_TIME_ON   750
#define NOTIFY_TIME_OFF  250

#define ACTIVE_TIME_ON     5
#define ACTIVE_TIME_OFF 1495

bool power_lost = false;
bool beeper_disabled;
bool alt_freq = false;
bool both_LEDs = true;  // startup only

void alarm_cycle(unsigned int time_on, unsigned int time_off, unsigned long frequency=0) {
  digitalWrite(LED_EXTERNAL, EXT_LED_ON);
  if (both_LEDs) digitalWrite(LED_BUILTIN, HIGH);
  if (not beeper_disabled and frequency) tone(TONE_OUT, frequency, time_on);
  delay(time_on);
  digitalWrite(LED_EXTERNAL, EXT_LED_OFF);
  if (both_LEDs) digitalWrite(LED_BUILTIN, LOW);
  delay(time_off);
}

void setup() {
  Serial.begin(9600);
  delay(300);
  // inputs
  pinMode(PWR_SENSE, INPUT);             // connected to USB/2 voltage divider
  pinMode(CHARGE_STATUS, INPUT_PULLUP);  // active low of charger IC
  // outputs
  pinMode(LED_BUILTIN,  OUTPUT);
  pinMode(LED_EXTERNAL, OUTPUT);  // active low
  pinMode(TONE_OUT,     OUTPUT);
  // power-up display & test
  alarm_cycle(400, 200, ALARM_FREQ_ALT);
  alarm_cycle(400, 200, ALARM_FREQ_ALT);
  both_LEDs = false;
  beeper_disabled = analogRead(PWR_SENSE) < 1024/8;
}

void loop() {
  if (analogRead(PWR_SENSE) < 1024/8) {
    alt_freq = not alt_freq;
    Serial.println("POWER LOST!");
    power_lost = true;
    alarm_cycle(ALARM_TIME_ON, ALARM_TIME_OFF, ((alt_freq)?ALARM_FREQ_ALT:ALARM_FREQ));
  } else {
    // power is on
    beeper_disabled = false;
    if (power_lost) {
      Serial.println("Power Was Lost");
      alarm_cycle(NOTIFY_TIME_ON, NOTIFY_TIME_OFF);
    } else {
      // no glitches
      Serial.println("power okay");
      alarm_cycle(ACTIVE_TIME_ON, ACTIVE_TIME_OFF);
    }
  }
  // set charging LED (built-in)
  digitalWrite(LED_BUILTIN, (digitalRead(CHARGE_STATUS) == LOW) ? HIGH : LOW);
  Serial.print("Charge Status: ");
  Serial.println((digitalRead(CHARGE_STATUS) == LOW) ? "LOW" : "HIGH");
}
