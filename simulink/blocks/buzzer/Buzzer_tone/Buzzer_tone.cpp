#include "Buzzer_tone.h"
#include <Arduino.h>

// Passive buzzer module, LOW-level trigger: the pin must rest HIGH when silent,
// otherwise the transistor stays on and the buzzer is powered without sound.
static int buzzerPin = 3;
static double lastFreq = -1.0;

// Watchdog (RA4M1 WDT, register start mode). If the program stops refreshing it
// for ~1.4 s (Nano frozen by a motor current spike), the chip resets and the
// motors stop. It is refreshed at every step (10 ms) in stepFunctionBuzzer_tone.
static inline void watchdogKick() {
    R_WDT->WDTRR = 0x00;
    R_WDT->WDTRR = 0xFF;
}
static void watchdogStart() {
    R_WDT->WDTCR  = (3u << 12) | (3u << 8) | (8u << 4) | 1u;  // no window, PCLKB/8192, 4096 cycles
    R_WDT->WDTRCR = 0x80;                                      // timeout -> reset (not interrupt)
    watchdogKick();                                            // first refresh starts it
}

// pin int8 [1,1] Non tunable
void setupFunctionBuzzer_tone(int8_T  pin,int size_vector__1){
    buzzerPin = (int)pin;
    pinMode(buzzerPin, OUTPUT);
    digitalWrite(buzzerPin, HIGH);   // silent
    watchdogStart();
}

// freq double [1,1]: note frequency in Hz, 0 = silence
void stepFunctionBuzzer_tone(double freq,int size_vector_a){
    watchdogKick();                  // "I am still alive" (every step)
    if (freq == lastFreq) return;    // only act when the note changes
    lastFreq = freq;
    if (freq > 0.0) {
        tone(buzzerPin, (unsigned int)freq);
    } else {
        noTone(buzzerPin);
        digitalWrite(buzzerPin, HIGH);   // back to the silent level
    }
}
