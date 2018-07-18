function simple_SGR(varargin)
%simple_SGR simplifies inconsistency report produced by calibrate_sgr and
% produces easily reusable *.txt
%
% simeple_SGR(calibrationReport, textOutputFile, matOutputFile) reads the
% inconsistency report produced by calibrate_sgr, produces a 4 column text
% file with columns of Channel name, event time reading, calibration
% reading, and different. Howerver, unless both the reading are not numeric, then it will be
% excluded from this report. Please check the inconsistency report produced
% by calibrate_sgr for such occurance.
%
% To reuse the output file, use the 'textscan' matlab function.
%
% NOTE: Delete the first two lines of the calibrate_sgr produced
% inconsistency report fie.
%
% Input parameters
% 
% calibrationReport:      Inconsistency report produced by calibrate_sgr
% textOutputFile:         4-column text output file to be produced by this
%                           code; the columns will have channelNames, event-data, calibration-data,
%                           and their difefrence.      
%
% Example: simple_SGR('calibrationReportAA.txt', 'calibrationReport.txt');
% 
% Also See: calibrate_sgr.m
%
% Created for Columbia Experimental Gravity (GECo)
% by Rubab Khan (a product of Bangladesh)
% on November 16, 2006.


warning off all;

%% process input parameters

if nargin < 1
    oldfile = 'calibrationReportAA.txt';
else
    oldfile = varargin(1);
end

if nargin < 2
    newfile = 'calibrationReport.txt';
else
    newfile = varargin(2);
end


%% open file for reading
fid1 = fopen(oldfile, 'r');
fid2 = fopen(newfile, 'w');

%% read and process data

while feof(fid1) == 0
    
       % read and process data
       try
           rawdata = textscan(fid1, '%s %s %s %s %n %s %s %s %n', 1);
       catch
       end
       
       channels = char(rawdata{2});
       data = rawdata{5};
       calibration = rawdata{9};
       difference = data  - calibration;
       
       fprintf(fid2, '%s          %e          %e          %e \n\n', channels,...
           data, calibration, difference);
            
end

%% close files
fclose(fid1);
fclose(fid2);

%% return function        
return
 
