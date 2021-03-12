clear; clc;

m_arduino = arduino;
pressureTransducer = 'A0';
zeroPressureVoltage = 0.5;
maxPressureVoltage = 4.5;
maxPressure = 500;

actuateSignal = 0;
lastValveTime = datetime('now');
lastTime = datetime('now');
while true
    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    
    currentTime = datetime('now');
    dt = currentTime - lastTime;
    fprintf('%.2f psi - %.2f V [%.2f ms]\n', pressure, pressureTransudcerVoltage, milliseconds(dt));
    lastTime = currentTime;
    
    timeSinceValve = currentTime - lastValveTime;
    if (milliseconds(timeSinceValve) > 1000)
       if (actuateSignal == 0)
           actuateSignal = 1;
       else
           actuateSignal = 0;
       end
       
       writeDigitalPin(m_arduino, 'D10', actuateSignal);
       fprintf('actuate');
       lastValveTime = currentTime;
    end
end