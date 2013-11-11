clear all
close all
hold off
clc

figure(1)
h = phasorplot(0.1, 2.6, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', 'k')
hold on
h = phasorplot(0.53, -1.8, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', [1 .5 1])
h = phasorplot(0.42, 0.5, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', [.4 .4 1])
th = findall(gcf,'Type','text');
for i = 1:length(th),
    set(th(i),'FontSize',24)
end
title('\fontsize{24}Dimesimeter 220 Phasors')
legend('All Data', 'Night Shift', 'Day Shift', 'location', 'south')
set(gca, 'fontsize', 24)

figure(2)
h = phasorplot(0.23, 2.1, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', 'k')
hold on
h = phasorplot(0.40, -0.7, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', [1 .5 1])
h = phasorplot(0.46, 1.5, .75, 3, 6, 'top', 'left', .1)
set(h, 'linewidth', 3)
set(h, 'color', [.4 .4 1])
th = findall(gcf,'Type','text');
for i = 1:length(th),
    set(th(i),'FontSize',24)
end
title('\fontsize{24}Dimesimeter 218 Phasors')
legend('All Data', 'Night Shift', 'Day Shift', 'location', 'south')
set(gca, 'fontsize', 24)