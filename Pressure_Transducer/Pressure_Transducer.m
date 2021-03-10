clear; clc;

m_arduino = arduino;
pressureTransducer = 'A0';
zeroPressureVoltage = 0.5;
maxPressureVoltage = 4.5;
maxPressure = 500;

lastTime = datetime('now');
while true
    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    
    currentTime = datetime('now');
    dt = currentTime - lastTime;
    fprintf('%.2f psi [%.2f ms]\n', pressure, milliseconds(dt));
    lastTime = currentTime;
end