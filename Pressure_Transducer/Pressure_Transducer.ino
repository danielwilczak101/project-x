const int pressureTransducer = A0;
const float zeroPressureVoltage = 0.5;
const float maxPressureVoltage = 4.5;
const int maxPressure = 500;
const int baudRate = 9600;

void setup() {
  Serial.begin(baudRate);
}

void loop() {
  int val = analogRead(pressureTransducer); //0-1023
  float voltage = (val / 1023.0f) * 4.5f; //max pressure transducer voltage is 
  float pressure = ((voltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
  
  Serial.print(pressure);
  Serial.println(" psi");
}
