clear all
close all
hold off
fclose('all')
clc

organize_raw_dimesimeter_file('4A_20111103.txt', '4A_20111103matlab.txt');
[time, lux, CLA, activity, temp, x, y] = process_raw_dime_09Aug2011('4A_20111103matlab.txt', 150);
time = time/86400;
CS = CSCalc_postBerlin_12Aug2011(CLA);

f = fopen('4A_20111103processed.txt', 'w');
fprintf(f, 'Time\tLux\tCLA\tCS\tActivity\tx\ty\r\n');
for i = 1:length(time)
    fprintf(f, '%s\t%.2f\t%.2f\t%.4f\t%.4f\t%.4f\t%.4f\r\n', datestr(time(i), 'HH:MM:SS mm/dd/yy'), lux(i), CLA(i), CS(i), activity(i), x(i), y(i));
end
fclose(f);