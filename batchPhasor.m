function batchPhasor
%BATCHPHASOR Summary of this function goes here
%   Detailed explanation goes here

addpath('archive');

%% Set input file paths
projectDir = 'C:\Users\jonesg5\Desktop\SanFrancisco';
dataDir = fullfile(projectDir,'data');
scheduleDir = fullfile(projectDir,'workSchedules');
shiftCalendarPath = fullfile(projectDir,'shiftCalendar.xlsx');

%% Import data
% Import the shift calendar
[sn,dayShiftStart,dayShiftEnd,...
    nightShiftStart,nightShiftEnd,transitionStart,transitionEnd] = ...
    importShiftCalendar(shiftCalendarPath);
% Create a struct of organized data
subject = struct;
for i1 = 1:numel(sn)
    % Assign data from shift calendar
    subject(i1).sn = sn(i1);
    subject(i1).dayShift(1) = dayShiftStart(i1);
    subject(i1).dayShift(2) = dayShiftEnd(i1);
    subject(i1).nightShift(1) = nightShiftStart(i1);
    subject(i1).nightShift(2) = nightShiftEnd(i1);
    subject(i1).transition(1) = transitionStart(i1);
    subject(i1).transition(2) = transitionEnd(i1);
    
    % Import Daysimeter data
    dataPath = fullfile(dataDir,[num2str(sn(i1)),'processed.txt']);
    [subject(i1).Time,subject(i1).CS,subject(i1).Activity] = ...
        importProcessed(dataPath);
    
    % Import shift schedule
    schedulePath = fullfile(scheduleDir,[num2str(sn(i1)),'.txt']);
    [subject(i1).shiftStart,subject(i1).shiftEnd] = ...
        importSchedule(schedulePath);
end

end

