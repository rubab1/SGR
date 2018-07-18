function calibrate_SGR(varargin)
%calibrate_SGR Verifies data calibration for two given GPS timees.
%
% calibrate_SGR(calibrationTime, eventTime, fullFrameList, minuteTrendFrameList, ...
% secondTrendFrameList, channelList, outputFile1, outputFile2, verbose);
% reads L0/L1/L2/L3/etc. level LIGO data frame list from fullFrameList,
% minute-trend frame list from minuteTrendFrameList, and second trend frame
% list from secondTrendFrameList.
%
% Input parameters
% 
% calibrationTime:      8-digit gps time when calibrations was done
% eventTime:            8-digit gps time of instance of interest
% fullFrameList:        ffl file listing full data frames
% minuteTrendFrameList: ffl file listing minute-trend frames
% secondTrendFrameList: ffl files listing second-trend frames
% channelList:          list of channels of interest; create from conlog.
%                           Log into gold, click conlog, search for H1, copy
%                           all, delete stuffs top and end; save as text
%                           file; don't worry about other columns. 
% outputFile1:          output file reporting inconsitency
% outputFile2:          output file reporting non-existing channels
% verbose:              0 or 1; indicates if to write non existing channel
%                           list. Not doing so significantly reduces disk 
%                           access and total run time.
%
% All inputs are optional. Please check the code for default values.
%
% Here is an example of how to create ffl files. It will vary depending on
% the file system. Locally coying necessary frames is strongly recommended
% since reading data from tapes for this code is quite impractical.
%
% To create ffl: ls /home/rubab/TimeMon/LHO/H-M-815/*.gwf >> temp.ffl
%                ls /home/rubab/TimeMon/LHO/H-M-816/*.gwf >> temp.ffl
%                ...
%                /bin/FrDump -d 0 -i temp.ffl > HTimeMon.ffl                
%
% Example: calibrate_SGR(784716588, 788218239, 'list.ffl', 'list_minute.ffl', ...
% 'list_second.ffl', 'channelList.txt', 'calibrationReportAA.txt', ...
% calibrationReportBB.txt', 1)
% 
% Also See: simple_sgr.m
%
% Created for Columbia Experimental Gravity (GECo)
% by Rubab Khan (a product of Bangladesh)
% on November 16, 2006.


warning off all;

%% process input parameters

if nargin < 9
    verbose = 1;
else
    verbose = str2double(varargin(9)); 
end

if nargin < 8
    outname2 = 'calibrationReportBB.txt';
else
    outname2 = varargin(8);
end

if nargin < 7
    outname1 = 'calibrationReportA.txt';
else
    outname1 = varargin(7);
end

if nargin < 6
    listname = 'channelList.txt';
else
    listname = varargin(6);
end

if nargin < 5
    fflfile3 = 'list_second.ffl';
else
    fflfile3 = varargin(5);
end

if nargin < 4
    fflfile2 = 'list_minute.ffl';
else
    fflfile2 = varargin(4);
end

if nargin < 3
    fflfile1 = 'list.ffl';
else
    fflfile1 = varargin(3);
end

if nargin < 2
    gpsTime = 788218239;
else
    gpsTime = str2double(varargin(2));
end

if nargin < 1
    calibrateTime = 784716588;
else
    calibrateTime = str2double(varargin(1)); 
end

%% open files for reading and writing
fid1 = fopen(listname, 'r');
fid2 = fopen(outname1, 'w');
if verbose
    fid3 = fopen(outname2, 'w');
end

%% write gps times in file
fprintf(fid2, 'Given time is %d \n', gpsTime);
fprintf(fid2, 'Calibration time is %d \n\n', calibrateTime);
if verbose
    fprintf(fid3, 'Given time is %d \n', gpsTime);
    fprintf(fid3, 'Calibration time is %d \n\n', calibrateTime);
end

%% process data and write reports

while feof(fid1) == 0
   
   % read and process channel names
   chanName = textscan(fid1, '%s %s %s %s %s %s %s %s %s %s %s', 1);
   chanName = char(chanName{1});

   % use mean channels in trend frames, when needed
   chanName2 = sprintf('%s.mean', chanName);
   
   % initiate data fields
   data1 = NaN;
   data2 = NaN;

   % Read data from frames. First try fuill frames, and then trend frames.
   % If channel is not found anywhere then report it.
   
    try
        data1 = frgetvect(fflfile1, chanName, gpsTime);
    catch
        try
            data1 = frgetvect(fflfile2, chanName2, gpsTime);
        catch
            try
                data1 = frgetvect(fflfile3, chanName2, gpsTime);
            catch
                if verbose
                    fprintf(fid3, 'Channel %s does not exist at given time \n', chanName);
                end
            end
        end            
    end
    
    try
        data2 = frgetvect(fflfile1, chanName, calibrateTime);
    catch
        try
            data2 = frgetvect(fflfile2, chanName2, calibrateTime);
        catch
            try
                data2 = frgetvect(fflfile3, chanName2, calibrateTime);
            catch
                if verbose
                    fprintf(fid3, 'Channel %s does not exist at calibration time \n\n', chanName);
                end
            end
        end        
    end
    
    % Take first entry of returned data regardless of sampling rate
    data1 = data1(1);
    data2 = data2(1);
    
    % write inconsistency report
    
    if ~isnan(data1)  % verify if data was read at all (since channels might not exist)
               
        if (ischar(data1)&ischar(data2))

            if strcmp(data1, data2) == 0
                fprintf(fid2, 'Channel %s data is %s BUT calibration is %s \n\n', chanName, ...
                    data1, data2);
            end
        elseif (ischar(data1)&isnumeric(data2))
                fprintf(fid2, 'Channel %s data is %s BUT calibration is %d \n\n', chanName, ...
                    data1, data2);
        elseif (isnumeric(data1)&ischar(data2))
                fprintf(fid2, 'Channel %s data is %d BUT calibration is %s \n\n', chanName, ...
                    data1, data2);
        elseif (isnumeric(data1)&isnumeric(data2))
            if data1 ~= data2
                fprintf(fid2, 'Channel %s data is %d BUT calibration is %d \n\n', chanName, ...
                    data1, data2);
            end
        else
            fprintf(fid2, 'Channel %s data is %d BUT calibration is %d \n\n', chanName, ...
                    data1, data2);
        end
    end
end

%% close files
fclose(fid1);
fclose(fid2);
if verbose
    fclose(fid3);
end

%% return function        
return
 
