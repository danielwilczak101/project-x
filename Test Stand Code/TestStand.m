fprintf('Clearing Workspace\n');
clear; clc;

fprintf('Initializing Arduino\n');
m_arduino = arduino('/dev/cu.usbmodem1424401', 'Uno', 'libraries', 'basicHX711/basic_HX711'); % Arduino Reference
pressureTransducer = 'A0'; % Pressure Transducer (Analog 0)

fprintf('Initializing Variables\n');
silenoidPin = 'D10'; % Silenoid for Oxygen (Digital 10)
starterPin = 'D9'; % Relay to allow voltage to match stick starter setup (Digital 9)

writeDigitalPin(m_arduino, silenoidPin, 1);
writeDigitalPin(m_arduino, starterPin, 0);

% Pressure Transducer
maxPressure = 500; % Maximum Pressure output by pressure transducer (psi)
zeroPressureVoltage = 0.5; % 0 psi
maxPressureVoltage = 4.5; % maxPressure at 4.5v

% Loadcell
loadCell = addon(m_arduino, 'basicHX711/basic_HX711', {'D3', 'D2'});
cal = calibration(100, 3500);
cal.tare_weight = 8525806.27000000;
cal.scale_factor = 84.4797390306853;

% Timing
startTime = datetime('now'); % Time program starts
lastTime = startTime; % Used for finding deltaTime in loop
lastLoadCellReading = startTime;
loadCellReading = 0;

fprintf('Start\n');
while true
    currentTime = datetime('now');
    dt = milliseconds(currentTime - lastTime); % Time since last loop in milliseconds
    dtStart = milliseconds(currentTime - startTime); % Time since start of program milliseconds
    dtLoadCell = milliseconds(currentTime - lastLoadCellReading); % time since last load cell reading

    pressureTransudcerVoltage = readVoltage(m_arduino, pressureTransducer);
    pressure = ((pressureTransudcerVoltage - zeroPressureVoltage) / (maxPressureVoltage - zeroPressureVoltage)) * maxPressure;
    
    % only read at 10hz
    if (dtLoadCell >= 100) 
        loadCellReading = get_weight(cal, loadCell);
    end
    
    fprintf('%.2f psi - %.2f V - %.2f load [%.2f ms]\n', pressure, pressureTransudcerVoltage, loadCellReading, dt);
    
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
