clear all
close all
clc
hold off

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

eof = zeros(length(activity), 1);
for i = 1:length(activity) - 5
    if(min(activity(i:i + 5)) > 2)
        break;
    end
end

activity(i:length(activity)) = [];
CS(i:length(CS)) = [];
lux(i:length(lux)) = [];
time(i:length(time)) = [];


%mark inactive periods
notworn = zeros(1, length(activity));
for i = 6:length(activity) - 5
    if((median(activity(i - 5:i + 5)) < .06) && (max(activity(i - 2:i + 2)) < .1))
        notworn(i) = 1;
    end
end

%mark covered periods
covered = zeros(1, length(lux));
for i = 6:length(lux) - 5
    if((median(lux(i - 5:i + 5)) < 1) && (max(lux(i - 2:i + 2)) < 1) && (mod(time(i), 1) < (20/24)) && (mod(time(i), 1) > (8/24)))
        covered(i) = 1;
    end
end

activity = gaussian(activity, 4, 1/180);
CS = gaussian(CS, 4, 1/180);

i = 0;
numdays = 7;
start = '24-Feb-2012 00:00';
while(i < (time(length(time)) - time(1)))
    
    q = find((time >= datenum(start) + i) & (time <= datenum(start) + i + 5));
    t = time(q);
    a = activity(q);
    C = CS(q);
    datestr(t(1))
    
    figure(1)
    % h = area(time, notworn)
    % set(h, 'facecolor', [1 .5 .5])
    % hold on
    plot(t, a, 'k')
%     datetick2('x')
    set(gca, 'fontsize', 18)
    title(['\fontsize{18}Activity - ', datestr(t(1)), ' to ', datestr(t(length(t)))])
    datetick2('x', 'mm/dd')
%     tstamp = t(1) - mod(t(1), 1):1:t(length(t));
%     set(gca, 'xtick', tstamp)
%     set(gca, 'xticklabel', datestr(tstamp, 'dd-mmm'))
%     drawnow
%     pause
    saveas(gcf, ['P:\hamner\miscellaneous MATLAB\Apr2012\lemur dimesimeter\figures\activity_', datestr(t(1), 'dd'), datestr(t(1), 'mmm'), datestr(t(1), 'yyyy'), '.jpg'])
    %time(1):1:t(length(t))
    
    figure(2)
    % h = area(t, covered)
    % set(h, 'facecolor', [1 .5 .5])
    % hold on
    plot(t, C, 'k')
%     datetick2('x')
    set(gca, 'fontsize', 18)
    title(['\fontsize{18}CS - ', datestr(t(1)), ' to ', datestr(t(length(t)))])
    datetick2('x', 'mm/dd')
%     set(gca, 'xtick', [t(1):1:t(length(t))])
%     set(gca, 'xticklabel', datestr(t(1):1:t(length(t)), 'dd-mmm'))
%     drawnow
    saveas(gcf, ['P:\hamner\miscellaneous MATLAB\Apr2012\lemur dimesimeter\figures\CS_', datestr(t(1), 'dd'), datestr(t(1), 'mmm'), datestr(t(1), 'yyyy'), '.jpg'])
    i = i + 5;
    
    q = [];
    t = [];
    a = [];
    C = [];
    
    figure(9)
    plot(time, CS)
    datetick2('x')
end
