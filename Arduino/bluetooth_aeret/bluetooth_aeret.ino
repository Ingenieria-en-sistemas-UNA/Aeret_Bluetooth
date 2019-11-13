#include <SoftwareSerial.h>// import the serial library
SoftwareSerial Bluetooth(10, 11); // RX, TX

int ledpin = 13; // led on D13 will show blink on / off
int openBox = 8;
int closeBox = 7;
int speedBox = 9;
int bluetoothData; // the data given from Computer

void setup() {
    Serial.println("Type AT commands!"); // put your setup code here, to run once:
    Bluetooth.begin(9600);
    Serial.println("Bluetooth On please press 1 or 0 blink LED ..");
    pinMode(ledpin, OUTPUT);
    pinMode(openBox, OUTPUT);
    pinMode(closeBox, OUTPUT);
    pinMode(speedBox, OUTPUT);
}

void loop() {
// put your main code here, to run repeatedly:
    analogWrite(speedBox, 200);
    if (Bluetooth.available()) {
        bluetoothData = Bluetooth.read();
        if (bluetoothData == '1') { // if number 1 pressed ….
            digitalWrite(ledpin, 1);
            digitalWrite(openBox,HIGH);
            delay(400);
            digitalWrite(openBox, LOW);
            digitalWrite(closeBox, LOW);
            Bluetooth.print('1');
            Serial.println("LED  On D13 ON ! ");
        }
        if (bluetoothData == '0') { // if number 0 pressed ….
            digitalWrite(ledpin, 0);
            digitalWrite(closeBox,HIGH);
            delay(500);
            digitalWrite(openBox, LOW);
            digitalWrite(closeBox, LOW);
            Bluetooth.print('0');
            Serial.println("LED  On D13 Off ! ");
        }
        if (bluetoothData == '9') { // if number 0 pressed ….
            digitalWrite(ledpin, 0);
            Bluetooth.print('9');
            Serial.println("Off ! ");
        }
    }
    delay(100);// prepare for next data …
}
