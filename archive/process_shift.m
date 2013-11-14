clear all
close all
clc
hold off

shift = 'day';

%pull in raw file
[FileName,PathName] = uigetfile('*.txt', 'Choose raw file to process');
path = [PathName, FileName];

f = fopen(path);
fscanf(f, '%d', 1);
id = fscanf(f, '%d', 1)
fclose(f);

%organize raw file
dummy = tempname;
organize_raw_dimesimeter_file(path, dummy);

%process organized file
[time, lux, CLA, activity, temp, x, y] = process_raw_dime_09Aug2011(dummy, id);
time = time/86400;
CS = CSCalc_postBerlin_12Aug2011(CLA);
time = time - (3/24);
activity(activity > 1) = 1;

%pull in shift info
path = ['C:\Users\jonesg5\Desktop\SanFrancisco\shiftDates\', shift, '\', FileName];
f = fopen(path);
start = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
fscanf(f, '%s', 1);
stop = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
start = datenum(start);
stop = datenum(stop);

%select shift
q = find((time >= start) & (time <= stop));
time = time(q);
activity = activity(q);
lux = lux(q);
CS = CS(q);

%work schedule
work = zeros(length(time), 1);
path = ['C:\Users\jonesg5\Desktop\SanFrancisco\workSchedules\', FileName];
f = fopen(path);
while(~feof(f))
    start = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
    fscanf(f, '%s', 1);
    stop = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
    fgetl(f);
    
    start = datenum(start);
    stop = datenum(stop);
    q = find((time >= start) & (time <= stop));
    work(q) = max(activity)/2;
    q = [];
end

%omit
omit = zeros(length(time), 1);
path = ['C:\Users\jonesg5\Desktop\SanFrancisco\omitTimes\', FileName];
f = fopen(path);
while(~feof(f))
    start = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
    fscanf(f, '%s', 1);
    stop = [fscanf(f, '%s', 1), ' ', fscanf(f, '%s', 1)];
    fgetl(f);
    
    start = datenum(start);
    stop = datenum(stop);
    q = find((time >= start) & (time <= stop));
    omit(q) = max(activity)/2;
    q = [];
end

t = time;

q = find(omit > 0);
time(q) = [];
activity(q) = [];
CS(q) = [];
lux(q) = [];
q = [];

%filter
activity = gaussian(activity, 4, 1/180);
CS = gaussian(CS, 4, 1/180);

figure(1)
h = area(t, work);
set(h, 'facecolor', [.5 1 0])
hold on
h = area(t, omit);
set(h, 'facecolor', [1 0 0 ]);
plot(time, CS, 'k', 'linewidth', 2)
xlim([time(1) time(length(time))])
% datetick2('x')
ticks = time(1):round((length(time)/480)/7):time(length(time));
set(gca, 'xtick', ticks)
set(gca, 'xticklabel', datestr(ticks, 'mm/dd'))
set(gca, 'fontsize', 18)
xlabel('\fontsize{18}Time')
ylabel('\fontsize{18}CS')
set(gca, 'tickdir', 'out')
legend('work', 'omitted', 'CS')
figure(2)
h = area(t, work);
set(h, 'facecolor', [.5 1 0]);
hold on
h = area(t, omit);
set(h, 'facecolor', [1 0 0 ]);
plot(time, activity, 'k', 'linewidth', 2)
% datetick2('x')
ticks = time(1):round((length(time)/480)/7):time(length(time));
set(gca, 'xtick', ticks)
set(gca, 'xticklabel', datestr(ticks, 'mm/dd'))
xlabel('\fontsize{18}Time')
ylabel('\fontsize{18}Activity')
set(gca, 'fontsize', 18)
set(gca, 'tickdir', 'out')
legend('work', 'omitted', 'activity')

[magnitude, angle] = cos24_1(CS, activity, time)

q = find(omit > 0);
work(q) = [];
q = [];

q = find(work > 0);
worklux = median(lux(q));
workCS = median(CS(q));
workactivity = median(activity(q));
q = [];

%miller plot
ta2 = zeros(480, 1);
tc2 = zeros(480, 1);
count2 = zeros(480, 1);
for i = 1:length(time)
    bin2 = 1 + floor((mod(time(i), 1) + 15/86400)*480);
    ta2(bin2) = ta2(bin2) + activity(i);
    tc2(bin2) = tc2(bin2) + CS(i);
    count2(bin2) = count2(bin2) + 1;
end
ta2 = ta2./count2;
tc2 = tc2./count2;

figure(3)
h = area(180/86400:180/86400:1, ta2)
set(h, 'facecolor', [0 0 0]);
hold on
h = area(180/86400:180/86400:1, tc2)
datetick('x', 'HH:MM')
set(h, 'facecolor', [1 .5 .5]);
set(gca, 'fontsize', 18)
xlabel('\fontsize{18}Time of Day')
ylabel('\fontsize{18}CS')
legend('Activity', 'CS')
title('\fontsize{18}Dimesimeter 218 - 24 hour profile - day shift')




