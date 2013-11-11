function [time, lux, CLA, activity, temp, x, y] = raw2processed_18Jan2012()

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

%choose filename for processed
[FileName,PathName] = uiputfile('*.txt', 'Save processed file');
path = [PathName, FileName];

%process organized file
[time, lux, CLA, activity, temp, x, y] = process_raw_dime_09Aug2011(dummy, id);
time = time/86400;
CS = CSCalc_postBerlin_12Aug2011(CLA);

%save processed file
f = fopen(path, 'w');
fprintf(f, 'Time\tLux\tCLA\tCS\tActivity\tx\ty\r\n');
for i = 1:length(time)
    fprintf(f, '%s\t%.2f\t%.2f\t%.4f\t%.4f\t%.4f\t%.4f\r\n', datestr(time(i), 'HH:MM:SS mm/dd/yy'), lux(i), CLA(i), CS(i), activity(i), x(i), y(i));
end
fclose(f);

delete(dummy);

end

