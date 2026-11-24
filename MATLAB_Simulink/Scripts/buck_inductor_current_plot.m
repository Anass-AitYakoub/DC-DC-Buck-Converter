
%% Buck Converter - Inductor Current Ripple

t = out.IL_sim.Time;
iL = out.IL_sim.Data;

% Display last 0.1 ms
idx = t >= 0.0198 & t <= 0.0199;

figure('Color', 'w');

plot(t(idx) * 1000, iL(idx), 'LineWidth', 1.5);
hold on;

xlabel('Time (ms)');
ylabel('Inductor Current (A)');
title('Buck Converter - Inductor Current Ripple');

grid on;
legend('Inductor current', 'Location', 'best');

exportgraphics(gcf, 'buck_inductor_current_ripple.png', ...
    'Resolution', 300);
