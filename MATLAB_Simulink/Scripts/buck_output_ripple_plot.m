
%% Buck Converter - Output Voltage Ripple Plot

t = out.Vout_sim.Time;
v = out.Vout_sim.Data;

% Steady-state interval
idx = t >= 0.0198 & t <= 0.0199;

t_ms = t(idx) * 1000;
v_zoom = v(idx);

Vripple = max(v_zoom) - min(v_zoom);

figure('Color', 'w');

plot(t_ms, v_zoom, 'LineWidth', 1.5);

xlabel('Time (ms)');
ylabel('Output Voltage (V)');
title('Buck Converter - Output Voltage Ripple');

grid on;
xlim([19.8 19.9]);

subtitle(sprintf('Peak-to-peak ripple: %.2f mV', ...
    Vripple * 1000));

exportgraphics(gcf, 'buck_output_voltage_ripple.png', ...
    'Resolution', 300);
