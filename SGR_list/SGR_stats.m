function SGR_stats(input_file)

GPS_time = [];
i = 1;
fid = fopen(input_file);

try
while feof(fid) == 0   
    line = textscan(fid,'%s',10);    
    [temp, GPS_temp] = system(sprintf('%s %s %s %s %s', 'tconvert', ...
       char(line{1}(3)), char(line{1}(2)), char(line{1}(4)), char(line{1}(6))));
   disp(sprintf('%s %s %s %s %s', 'tconvert', ...
       char(line{1}(3)), char(line{1}(2)), char(line{1}(4)), char(line{1}(6))));
    GPS_time(i) = str2double(GPS_temp); %#ok<AGROW>
    i = i+1;       
end
catch
end

N = length(GPS_time);

for j = 1: N    
    stat_matrix(j,:) = check_sm(GPS_time(j)); %#ok<AGROW>
end

disp(['For ' input_file ' -']);
disp(['Total events ' num2str(N)]);
disp([num2str(((sum(stat_matrix(:,1)))/N)*100) '% H1     only lock']);
disp([num2str(((sum(stat_matrix(:,2)))/N)*100) '%   H2   only lock']);
disp([num2str(((sum(stat_matrix(:,3)))/N)*100) '%     L1 only lock']);
disp([num2str(((sum(stat_matrix(:,4)))/N)*100) '% H1H2   only lock']);
disp([num2str(((sum(stat_matrix(:,5)))/N)*100) '% H1  L1 only lock']);
disp([num2str(((sum(stat_matrix(:,6)))/N)*100) '%   H2L1 only lock']);
disp([num2str(((sum(stat_matrix(:,7)))/N)*100) '% H1H2L1      lock']);
disp([num2str(((sum(stat_matrix(:,8)))/N)*100) '% No          lock']);

fclose(fid);

return