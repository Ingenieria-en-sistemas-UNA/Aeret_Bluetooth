#include <SoftwareSerial.h>// import the serial library
#include <Servo.h>


SoftwareSerial mySerial(10, 11); // RX, TX

Servo servo;
int angle = 10;
int ledpin = 13; // led on D13 will show blink on / off
int bluetoothData; // the data given from Computer

void setup() {
    servo.attach(8);
    servo.write(angle);
    Serial.begin(4800);
    Serial.println("Type AT commands!"); // put your setup code here, to run once:
    mySerial.begin(9600);
    Serial.println("Bluetooth On please press 1 or 0 blink LED ..");
    pinMode(ledpin, OUTPUT);

}

void loop() {
// put your main code here, to run repeatedly:
    if (mySerial.available()) {
        bluetoothData = mySerial.read();

        if (bluetoothData == '1') { // if number 1 pressed ….
            digitalWrite(ledpin, 1);
            for(angle = 10; angle < 180; angle++)  
            {                                  
              servo.write(angle);               
              delay(15);                   
            } 
            Serial.println("LED  On D13 ON ! ");
        }
        if (bluetoothData == '0') { // if number 0 pressed ….
            digitalWrite(ledpin, 0);
            for(angle = 180; angle > 10; angle--)    
            {                                
              servo.write(angle);           
              delay(15);       
            } 
            Serial.println("LED  On D13 Off ! ");
        }
    }
    delay(100);// prepare for next data …
}
