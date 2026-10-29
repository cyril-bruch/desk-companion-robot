#include "Buzzer_tone.h"
#include <Arduino.h>

// Passive buzzer module, LOW-level trigger: the pin must rest HIGH when silent,
// otherwise the transistor stays on and the buzzer is powered without sound.
static int buzzerPin = 3;
static double lastFreq = -1.0;

// pin int8 [1,1] Non tunable
void setupFunctionBuzzer_tone(int8_T  pin,int size_vector__1){
    buzzerPin = (int)pin;
    pinMode(buzzerPin, OUTPUT);
    digitalWrite(buzzerPin, HIGH);   // silent
}

// freq double [1,1]: note frequency in Hz, 0 = silence
void stepFunctionBuzzer_tone(double freq,int size_vector_a){
    if (freq == lastFreq) return;    // only act when the note changes
    lastFreq = freq;
    if (freq > 0.0) {
        tone(buzzerPin, (unsigned int)freq);
    } else {
        noTone(buzzerPin);
        digitalWrite(buzzerPin, HIGH);   // back to the silent level
    }
}
