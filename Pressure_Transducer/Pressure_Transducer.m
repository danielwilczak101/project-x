clear; clc;

m_arduino = arduino;
pressureTransducer = 'A0';
zeroPressureVoltage = 0.5;
maxPressureVoltage = 4.5;
maxPressure = 500;

while true
    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    fprintf('%.2f psi\n', pressure);
end