function batchPhasor
%BATCHPHASOR Summary of this function goes here
%   Detailed explanation goes here

addpath('archive');

%% Set input file paths
projectDir = 'C:\Users\jonesg5\Desktop\SanFrancisco';
dataDir = fullfile(projectDir,'data');
scheduleDir = fullfile(projectDir,'workSchedules');
omitDir = fullfile(projectDir,'omitTimes');
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
        importTimes(schedulePath);
    
    % Import omit times
    omitPath = fullfile(omitDir,[num2str(sn(i1)),'.txt']);
    [subject(i1).omitStart,subject(i1).omitEnd] = importTimes(omitPath);
    
    %% Pre-process data
    % Apply a gaussian filter to CS and Actvity
    subject(i1).filtCS = gaussian(subject(i1).CS, 4, 1/180);
    subject(i1).filtActivity = gaussian(subject(i1).Activity, 4, 1/180);
    
    % Find omitted data points
    subject(i1).omitIdx = false(numel(subject(i1).Time),1);
    for i2 = 1:numel(subject(i1).omitStart)
    subject(i1).omitIdx = subject(i1).Time >= subject(i1).omitStart(i2) ...
        & subject(i1).Time <= subject(i1).omitEnd(i2) ...
        | subject(i1).omitIdx;
    end
    
    % Find data points when the subject was on day shift
    subject(i1).dayIdx = xor((...
        subject(i1).Time >= subject(i1).dayShift(1) ...
        & subject(i1).Time <= subject(i1).dayShift(2)),...
        subject(i1).omitIdx);
    
    % Find data points when the subject was on night shift
    subject(i1).nightIdx = xor((...
        subject(i1).Time >= subject(i1).nightShift(1) ...
        & subject(i1).Time <= subject(i1).nightShift(2)),...
        subject(i1).omitIdx);
    
    % Find data points when the subject was on transition
    subject(i1).transitionIdx = xor((...
        subject(i1).Time >= subject(i1).transition(1) ...
        & subject(i1).Time <= subject(i1).transition(2)),...
        subject(i1).omitIdx);
    
    %% Analyze data
    % Phasor analysis of day shift
    [subject(i1).phasorMagnitudeDay, subject(i1).phasorAngleDay] = ...
        cos24_1(subject(i1).filtCS(subject(i1).dayIdx),...
        subject(i1).filtActivity(subject(i1).dayIdx),...
        subject(i1).Time(subject(i1).dayIdx));
    
    % Phasor analysis of night shift
    [subject(i1).phasorMagnitudeNight, subject(i1).phasorAngleNight] = ...
        cos24_1(subject(i1).filtCS(subject(i1).nightIdx),...
        subject(i1).filtActivity(subject(i1).nightIdx),...
        subject(i1).Time(subject(i1).nightIdx));
    
    % Phasor analysis of transition
    [subject(i1).phasorMagnitudeTrans, subject(i1).phasorAngleTrans] = ...
        cos24_1(subject(i1).filtCS(subject(i1).transitionIdx),...
        subject(i1).filtActivity(subject(i1).transitionIdx),...
        subject(i1).Time(subject(i1).transitionIdx));
end

%% Prep data for output
output = cell(numel(subject)+1,4);
output{1,1} = 'sn';
output{1,2} = 'day shift phasor magnitude';
output{1,3} = 'night shift phasor magnitude';
output{1,4} = 'transition phasor magnitude';
for j1 = 1:numel(subject)
    output{j1+1,1} = subject(j1).sn;
    output{j1+1,2} = subject(j1).phasorMagnitudeDay;
    output{j1+1,3} = subject(j1).phasorMagnitudeNight;
    output{j1+1,4} = subject(j1).phasorMagnitudeTrans;
end

end

