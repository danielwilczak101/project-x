clear; clc;

m_arduino = arduino; % Arduino Reference
pressureTransducer = 'A0'; % Pressure Transducer (Analog 0)
silenoidPin = 'D10'; % Silenoid for Oxygen (Digital 10)
starterPin = 'D9'; % Relay to allow voltage to match stick starter setup (Digital 9)

% Pressure Transducer
maxPressure = 500; % Maximum Pressure output by pressure transducer (psi)
zeroPressureVoltage = 0.5; % 0 psi
maxPressureVoltage = 4.5; % maxPressure at 4.5v

% Timing
startTime = datetime('now'); % Time program starts
lastTime = startTime; % Used for finding deltaTime in loop

while true
    currentTime = datetime('now');
    dt = milliseconds(currentTime - lastTime); % Time since last loop in milliseconds
    dtStart = milliseconds(currentTime - startTime); % Time since start of program milliseconds
    
    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    fprintf('%.2f psi - %.2f V [%.2f ms]\n', pressure, pressureTransudcerVoltage, dt);
    
    % Puff
    if (dtStart < 500)
        writeDigitalPin(m_arduino, silenoidPin, 1);
        fprintf('oxygen\n');
    elseif (dtStart < 2500)
        writeDigitalPin(m_arduino, silenoidPin, 0);
        fprintf('no oxygen\n');
    end
    
    % Starter
    if (dtStart < 5000)
        writeDigitalPin(m_arduino, starterPin, 1);
        fprintf('starter\n');
    else
        writeDigitalPin(m_arduino, starterPin, 0);
        fprintf('no starter\n');
    end
    
    % Main O2 Supply
    if (dtStart > 2500 && dtStart < 12500)
        writeDigitalPin(m_arduino, silenoidPin, 1);
        fprintf('oxygen\n');
    elseif (dtStart > 2500)
        writeDigitalPin(m_arduino, silenoidPin, 0);
        fprintf('no oxygen\n');
    end
    
    lastTime = currentTime;
end