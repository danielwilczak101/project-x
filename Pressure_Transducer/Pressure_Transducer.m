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


    % Oxygen
    if (dtStart > 500 && dtStart < 2000)
        writeDigitalPin(m_arduino, silenoidPin, 0);
         % Turn on valve
    elseif (dtStart > 2000 && dtStart < 2500)
         % Turn off valve
        writeDigitalPin(m_arduino, silenoidPin, 1);
    elseif (dtStart > 3000 && dtStart < 11000)
         % Turn on valve
        writeDigitalPin(m_arduino, silenoidPin, 0);
    elseif (dtStart > 11001)
        % Turn off valve
        writeDigitalPin(m_arduino, silenoidPin, 1);
    end

    % Ignition
    if (dtStart > 2000)
        writeDigitalPin(m_arduino, starterPin, 0);
    elseif(dtStart > 3000)
        writeDigitalPin(m_arduino, starterPin, 1);
    end


    lastTime = currentTime;
end
