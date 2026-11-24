
%% Buck Converter - Theoretical Analysis

clear;
clc;
close all;

% Circuit parameters
Vin = 12;          % Input voltage (V)
Vout = 5;          % Target output voltage (V)
Iout = 2;          % Target output current (A)

L = 68e-6;         % Inductance (H)
C = 470e-6;        % Output capacitance (F)
fs = 150e3;        % Switching frequency (Hz)

% Ideal buck converter calculations
D = Vout / Vin;
Rload = Vout / Iout;

deltaIL = (Vin - Vout) * D / (L * fs);
deltaVout = deltaIL / (8 * fs * C);

% Display results
fprintf('BUCK CONVERTER ANALYSIS\n');
fprintf('-----------------------\n');
fprintf('Input Voltage: %.2f V\n', Vin);
fprintf('Output Voltage: %.2f V\n', Vout);
fprintf('Output Current: %.2f A\n', Iout);
fprintf('Duty Cycle: %.2f %%\n', D * 100);
fprintf('Load Resistance: %.2f Ohms\n', Rload);
fprintf('Inductor Current Ripple: %.3f A\n', deltaIL);
fprintf('Ideal Voltage Ripple: %.3f mV\n', deltaVout * 1000);
