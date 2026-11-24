
%% Buck Converter - Fixed PWM vs Soft-Start
% Comparison at approximately 1.5 A

clc;
close all;

%% 1. Run the fixed PWM model

fixed = sim('buck_converter_model');

t_fixed = fixed.Vout_sim.Time;
v_fixed = fixed.Vout_sim.Data;

%% 2. Run the Soft-Start model

soft = sim('buck_converter_softstart');

t_soft = soft.Vout_sim.Time;
v_soft = soft.Vout_sim.Data;

%% 3. Calculate results

Vsteady_fixed = mean(v_fixed(t_fixed >= 0.015));
Vsteady_soft = mean(v_soft(t_soft >= 0.015));

Vpeak_fixed = max(v_fixed);
Vpeak_soft = max(v_soft);

OS_fixed = (Vpeak_fixed - Vsteady_fixed) ...
    / Vsteady_fixed * 100;

OS_soft = (Vpeak_soft - Vsteady_soft) ...
    / Vsteady_soft * 100;

reduction = (OS_fixed - OS_soft) / OS_fixed * 100;

%% 4. Plot comparison

figure('Color', 'w');

plot(t_fixed * 1000, v_fixed, ...
    'LineWidth', 1.6);
hold on;

plot(t_soft * 1000, v_soft, ...
    'LineWidth', 1.8);

yline(5, '--', 'Target: 5 V', 'LineWidth', 1.2);

xlabel('Time (ms)');
ylabel('Output Voltage (V)');
title('Buck Converter - Soft-Start Comparison');

legend('Fixed PWM (45%)', ...
    'Soft-Start (5 ms)', ...
    'Target 5 V', ...
    'Location', 'best');

grid on;
xlim([0 20]);

%% 5. Export the figure

exportgraphics(gcf, ...
    'buck_softstart_comparison.png', ...
    'Resolution', 300);

%% 6. Display comparison results

fprintf('\nSOFT-START COMPARISON\n');
fprintf('-----------------------------\n');
fprintf('Fixed PWM peak: %.3f V\n', Vpeak_fixed);
fprintf('Soft-Start peak: %.3f V\n', Vpeak_soft);
fprintf('Fixed PWM overshoot: %.2f %%\n', OS_fixed);
fprintf('Soft-Start overshoot: %.2f %%\n', OS_soft);
fprintf('Overshoot reduction: %.2f %%\n', reduction);
