function [time, red, green, blue, activity] = organize_raw_dimesimeter_file(file, varargin)
%This function organizes the data in "file" and saves it in 5 columns in
%"savefile" if needed where "savefile" is the varargin
%Time is in seconds of MATLAB time, so divide by 86400 to get MATLAB time

%get start time and interval
f = fopen(file);
fscanf(f, '%s', 1);
fscanf(f, '%s', 1);
year = fscanf(f, '%d', 1);
month = fscanf(f, '%d', 1);
day = fscanf(f, '%d', 1);
hour = fscanf(f, '%d', 1);
minute = fscanf(f, '%d', 1);
int = fscanf(f, '%d', 1);
start = [num2str(month), '/', num2str(day), '/20', num2str(year), ' ', num2str(hour), ':', num2str(minute)];
frewind(f);

%get data
raw = textread(file, '%d');

%organize data in to rgba
for i = 24:8:length(raw)
    time(i/8 - 2) = datenum(start) + (int/86400)*(i/8 - 3);
    red(i/8 - 2) = 256*raw(i - 7) + raw(i - 6);
    green(i/8 - 2) = 256*raw(i - 5) + raw(i - 4);
    blue(i/8 - 2) = 256*raw(i - 3) + raw(i - 2);
    activity(i/8 - 2) = 256*raw(i - 1) + raw(i);
    
    if(mod(activity(i/8 - 2), 2) > 0)
        red(i/8 - 2) = red(i/8 - 2)/5;
        green(i/8 - 2) = green(i/8 - 2)/5;
        blue(i/8 - 2) = blue(i/8 - 2)/5;
    end
    activity(i/8 - 2) = activity(i/8 - 2)/2;
end

% figure(8)
% plot(time, red)
% datetick2('x')
time = time*86400;
fclose(f);

%spit it out in a nice format if needed
if(length(varargin) > 0)
    savefile = char(varargin(1));
end
f = fopen(savefile, 'w');
for i = 1:length(time)
    fprintf(f, '%.2f\t%.2f\t%.2f\t%.2f\t%.2f\r\n', time(i), red(i), green(i), blue(i), activity(i));
end
fclose(f);

