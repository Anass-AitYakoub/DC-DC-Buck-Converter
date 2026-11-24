
%% Buck Converter - Startup Response

t = out.Vout_sim.Time;
v = out.Vout_sim.Data;

Vsteady = mean(v(t >= 0.015));
Vpeak = max(v);

figure('Color','w');

plot(t * 1000, v, 'LineWidth', 1.5);
hold on;

yline(5, '--', 'Target: 5 V', 'LineWidth', 1.2);
yline(Vsteady, '--', 'Steady state', 'LineWidth', 1.2);

xlabel('Time (ms)');
ylabel('Output Voltage (V)');
title('Buck Converter - Startup Transient Response');
legend('Simulated Vout', 'Target voltage', ...
    'Steady-state voltage', 'Location', 'best');

grid on;
xlim([0 20]);

exportgraphics(gcf, 'buck_startup_response.png', ...
    'Resolution', 300);
