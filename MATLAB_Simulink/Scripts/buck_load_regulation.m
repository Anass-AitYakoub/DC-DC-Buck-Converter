
%% Buck Converter - Load Regulation Analysis

clear;
clc;
close all;

Rload = [10; 5; 3.333; 2.5];
Iout = [0.509; 1.009; 1.503; 1.989];
Vout = [5.085; 5.047; 5.009; 4.972];
Vpeak = [7.924; 7.700; 7.489; 7.290];

% Output voltage error relative to 5 V
Error_percent = (Vout - 5) / 5 * 100;

% Results table
results = table(Rload, Iout, Vout, Vpeak, Error_percent);

disp(results);

% Export results to CSV
writetable(results, 'buck_load_test_results.csv');

% Plot load regulation
figure('Color', 'w');

plot(Iout, Vout, '-o', 'LineWidth', 1.8);
hold on;

yline(5, '--', 'Target: 5 V');

xlabel('Output Current (A)');
ylabel('Output Voltage (V)');
title('Buck Converter - Load Regulation');
legend('Simulated Voltage', 'Target Voltage', ...
    'Location', 'best');

grid on;
ylim([4.9 5.15]);

exportgraphics(gcf, 'buck_load_regulation.png', ...
    'Resolution', 300);
