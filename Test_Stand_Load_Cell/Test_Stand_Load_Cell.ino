#include "HX711.h"
HX711 scale;

#define DOUT 3
#define CLK 2
#define calibration -22500
#define lengthToLoadCell 16.54 //inches
#define lengthToThrust 7.46 //inches

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("EPPL VILE Test Stand Load Cell");

  scale.begin(DOUT, CLK);
  scale.set_scale(calibration);
  scale.tare();
}

float calculateThrust(float loadcell)
{
  return loadcell * (lengthToLoadCell / lengthToThrust);
}

void loop() {
  // put your main code here, to run repeatedly:
  float reading = scale.get_units();
  //Serial.print(millis());
  //Serial.print(",");
  Serial.print(calculateThrust(reading), 5);
  //Serial.print(",");
  Serial.println();
}
