
%% BUCK CONVERTER - EFFICIENCY VS LOAD
% 12 V input, 150 kHz PWM, 45% duty cycle
% Open-loop Simscape model

clearvars;
clc;

model = 'buck_converter_model';
loadBlock = [model '/Resistor'];

Vin = 12;
RL = 0.067;  % Inductor series resistance (Ohm)

% Four load conditions
Rloads = [10, 5, 3.333, 2.5];

% Store results
results = zeros(length(Rloads), 7);

% Load model
load_system(model);

% Preserve original model settings
originalR = get_param(loadBlock, 'R');
originalStep = get_param(model, 'MaxStep');

% Run all simulations without changing saved model
try
    for k = 1:length(Rloads)

        R = Rloads(k);

        % Set parameters for this simulation
        in = Simulink.SimulationInput(model);
        in = in.setBlockParameter(loadBlock, ...
            'R', num2str(R, 12));
        in = in.setModelParameter('MaxStep', '1e-7');

        % Run simulation
        simOut = sim(in);

        % Read logged signals
        iin = simOut.Iin_sim;
        il = simOut.IL_sim;
        vout = simOut.Vout_sim;

        % Extract steady-state samples (15-20 ms)
        ti = iin.Time;
        ii = squeeze(iin.Data);

        tl = il.Time;
        li = squeeze(il.Data);

        tv = vout.Time;
        vv = squeeze(vout.Data);

        idxI = ti >= 0.015;
        idxL = tl >= 0.015;
        idxV = tv >= 0.015;

        % Time-weighted averages
        avg = @(t,x) trapz(t,x)/(t(end)-t(1));

        Pin = avg(ti(idxI), Vin*ii(idxI));
        Pout = avg(tv(idxV), vv(idxV).^2/R);
        PL = avg(tl(idxL), RL*li(idxL).^2);

        Vavg = avg(tv(idxV), vv(idxV));
        Iout = avg(tv(idxV), vv(idxV)/R);

        eta = 100*Pout/Pin;

        results(k,:) = ...
            [R, Iout, Vavg, Pin, Pout, PL, eta];

        fprintf('Load %.3f Ohm: %.2f %% efficiency\n', ...
            R, eta);
    end

catch ME
    fprintf('Simulation error: %s\n', ME.message);
    rethrow(ME);
end

% Create results table
T = array2table(results, 'VariableNames', { ...
    'Load_Ohm', ...
    'OutputCurrent_A', ...
    'OutputVoltage_V', ...
    'InputPower_W', ...
    'OutputPower_W', ...
    'InductorLoss_W', ...
    'Efficiency_Percent'});

T.OtherLosses_W = T.InputPower_W ...
    - T.OutputPower_W - T.InductorLoss_W;

disp(T);

% Save data
writetable(T, 'buck_efficiency_vs_load.csv');

% Plot efficiency against actual output current
figure('Color','w');

plot(T.OutputCurrent_A, T.Efficiency_Percent, ...
    '-o', 'LineWidth', 2, 'MarkerSize', 8);

xlabel('Output Current (A)');
ylabel('Efficiency (%)');
title('Buck Converter - Efficiency vs Load Current');

grid on;
ylim([0 100]);

exportgraphics(gcf, ...
    'buck_efficiency_vs_load.png', ...
    'Resolution', 300);

% Check physical consistency
if any(T.OtherLosses_W < -0.01)
    warning('Negative residual losses detected. Review model.');
end

fprintf('\nAnalysis complete.\n');
fprintf('Model parameters were not permanently changed.\n');
