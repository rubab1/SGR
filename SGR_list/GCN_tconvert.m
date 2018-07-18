function GCN_tconvert(GCN_time)
%GCN_convert Converts GCN style time seconds to HH:MM:SS style
%
% GCN_convert(GCN_time) Converts GCN style time seconds to GPS style. GCN time formats counts seconds will midnight that day, and gives the n-th second, which should be smaller than 86400.
%
% Created for Columbia Experimental Gravity (GECo)
% by Rubab Khan (a product of Bangladesh)
% on July 04, 2007.

H = floor(GCN_time/3600);

M = floor((GCN_time - H*3600)/60);

S = GCN_time - H*3600 - M*60;

message = strcat(num2str(H), ':', num2str(M), ':', num2str(S));

disp(message);

return