#include "Oled_eyes.h"
#include "U8g2lib.h"

// SH1106 128x64 OLED on software I2C (clock = A4, data = A5, as wired on the robot).
// Hardware I2C on the Nano R4 corrupted the frames, software I2C is reliable.
U8G2_SH1106_128X64_NONAME_F_SW_I2C u8g2(U8G2_R0, /* clock */ A4, /* data */ A5, U8X8_PIN_NONE);
static int lastFace = -1;

// Eye geometry (screen 128 x 64)
static const int EYE_L = 40, EYE_R = 88;     // eye centres (x)
static const int EYE_Y = 32;                 // eye centre (y)
static const int EYE_W = 24, EYE_H = 32, EYE_RAD = 8;

static void neutralEye(int cx) {
    u8g2.drawRBox(cx - EYE_W / 2, EYE_Y - EYE_H / 2, EYE_W, EYE_H, EYE_RAD);
}

static void drawFace(int face) {
    u8g2.clearBuffer();
    switch (face) {
        case 0:   // faceSleep: closed eyes + a little "z"
            u8g2.drawRBox(EYE_L - 12, EYE_Y - 2, 24, 4, 2);
            u8g2.drawRBox(EYE_R - 12, EYE_Y - 2, 24, 4, 2);
            u8g2.drawLine(108, 6, 116, 6);
            u8g2.drawLine(116, 6, 108, 14);
            u8g2.drawLine(108, 14, 116, 14);
            break;
        case 2:   // faceHappy: "^^" arcs (white disc minus a black disc shifted down)
            u8g2.drawDisc(EYE_L, EYE_Y, 13);
            u8g2.drawDisc(EYE_R, EYE_Y, 13);
            u8g2.setDrawColor(0);
            u8g2.drawDisc(EYE_L, EYE_Y + 8, 13);
            u8g2.drawDisc(EYE_R, EYE_Y + 8, 13);
            u8g2.setDrawColor(1);
            break;
        case 3:   // faceCurious: eyes looking to the side
            neutralEye(EYE_L - 10);
            neutralEye(EYE_R - 10);
            break;
        case 4:   // faceSurprised: big round eyes with a small pupil
            u8g2.drawDisc(EYE_L, EYE_Y, 15);
            u8g2.drawDisc(EYE_R, EYE_Y, 15);
            u8g2.setDrawColor(0);
            u8g2.drawDisc(EYE_L, EYE_Y, 4);
            u8g2.drawDisc(EYE_R, EYE_Y, 4);
            u8g2.setDrawColor(1);
            break;
        case 5:   // faceSad: neutral eyes with the outer top corner cut (drooping lids)
            neutralEye(EYE_L);
            neutralEye(EYE_R);
            u8g2.setDrawColor(0);
            u8g2.drawTriangle(EYE_L - 14, EYE_Y - 18, EYE_L + 6, EYE_Y - 18, EYE_L - 14, EYE_Y - 2);
            u8g2.drawTriangle(EYE_R + 14, EYE_Y - 18, EYE_R - 6, EYE_Y - 18, EYE_R + 14, EYE_Y - 2);
            u8g2.setDrawColor(1);
            break;
        case 1:   // faceNeutral
        default:
            neutralEye(EYE_L);
            neutralEye(EYE_R);
            break;
    }
    u8g2.sendBuffer();   // ~50 ms on software I2C: only done when the face changes
}

// BlockParameter int8 [1,1] Non tunable
void setupFunctionOled_eyes(int8_T  BlockParameter,int size_vector__1){
    u8g2.begin();
}

// face double [1,1]
void stepFunctionOled_eyes(double face,int size_vector_a){
    int f = (int)face;
    if (f != lastFace) {
        drawFace(f);
        lastFace = f;
    }
}
