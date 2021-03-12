clear; clc;

m_arduino = arduino;
pressureTransducer = 'A0';
actuatorPin = 'D10';
starterPin = 'D9';

zeroPressureVoltage = 0.5;
maxPressureVoltage = 4.5;
maxPressure = 500;

actuateSignal = 0;
lastValveTime = datetime('now');
lastTime = datetime('now');
while true
    currentTime = datetime('now');
    dt = currentTime - lastTime;
    
    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    fprintf('%.2f psi - %.2f V [%.2f ms]\n', pressure, pressureTransudcerVoltage, milliseconds(dt));
    
    timeSinceValve = currentTime - lastValveTime;
    if (milliseconds(timeSinceValve) > 1000)
       if (actuateSignal == 0)
           actuateSignal = 1;
       else
           actuateSignal = 0;
       end
       
       writeDigitalPin(m_arduino, actuatorPin, actuateSignal);
       writeDigitalPin(m_arduino, starterPin, actuateSignal);
       fprintf('actuate\n');
       lastValveTime = currentTime;
    end
    lastTime = currentTime;
end