#include <stdlib.h>

int led = 13;

void setup() {
  Serial.begin(9600);
  Serial.flush();
  pinMode(led, OUTPUT);
}

void setLeds(int brightness){
  analogWrite(led, brightness);
}

void process_command(char command[]){
  Serial.println(command);
  String str_command = command;
  char carray[4];
  
  if (str_command.substring(0,2) == "wl"){
    String num = str_command.substring(3);
    num.toCharArray(carray,4);
    setLeds(atoi(carray));
  }
}

void loop() {
  int i=0;
  char commandbuffer[100];

  if(Serial.available()){
     delay(100);
     while( Serial.available() && i< 99) {
        commandbuffer[i++] = Serial.read();
     }
     commandbuffer[i++]='\0';
  }

  if(i>0)
     process_command((char*)commandbuffer);
}
