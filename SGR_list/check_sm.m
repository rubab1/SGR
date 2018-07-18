function stuff  = check_sm(gpstime)
%check_sm Verifies IFO status at a given time
%
% check_sm(gpstime, h1sciencelist, h2sciencelist) verifies which LIGO
% detectors were in science mode at a given time, and shows the duration of multi-detector coincident data.
% 
% It  returns a vectior on detector status in the form of:
% [H1 H2 L1 H1H2 H1L1 H2L1 All None]
% where elements corresponding to a locked detector will be 1, and others
% remain to be 0. No two elements in the vector can be 1 at the sam etime.
%
% Created for Columbia Experimental Gravity (GECo)
% by Rubab Khan (a product of Bangladesh)
% on July 04, 2007.

stuff = [0 0 0 0 0 0 0 0];
t = gpstime;
h1sciencelist = 'S5H1v00_segs.txt';
h2sciencelist = 'S5H2v00_segs.txt';
l1sciencelist = 'S5L1v00_segs.txt';
h1 = false; h2 = false; l1 = false;
h1st = []; h2st = []; l1st = []; st = [];
h1en = []; h2en = []; l1en = []; en = [];


[temp1,temp2] = system(sprintf('%s %d', 'tconvert', gpstime));
disp(['For event at ' temp2]);
disp([ 'GPS  time ' num2str(gpstime)])
disp('{{{');

load(h1sciencelist);
no1 = S5H1v00_segs(:,1);
st1 = S5H1v00_segs(:,2);
en1 = S5H1v00_segs(:,3);
ln1 = S5H1v00_segs(:,4);
M = length(st1);
for j = 1:M
    rr=find(t>=st1(j)&t<=en1(j));
    r = size(rr);
    if r(2) ~= 0;
        disp(['H1 is in Science Mode: H1 ' num2str(no1(j)) ' ' num2str(st1(j))...
            ' ' num2str(en1(j)) ' ' num2str(ln1(j))]);
      	h1 = true; h1st = st1(j); h1en = en1(j);
        break;
    elseif j==M
        disp('H1 is not in Science Mode');
    end
end

load(h2sciencelist);
no2 = S5H2v00_segs(:,1);
st2 = S5H2v00_segs(:,2);
en2 = S5H2v00_segs(:,3);
ln2 = S5H2v00_segs(:,4);
N = length(st2);
for j = 1:N
    ss=find(t>=st2(j)&t<=en2(j));
    s = size(ss);
    if s(2) ~= 0;
        disp(['H2 is in Science Mode: H2 ' num2str(no2(j)) ' ' num2str(st2(j))...
            ' ' num2str(en2(j)) ' ' num2str(ln2(j))]);
		 h2 = true;  h2st = st2(j); h2en = en2(j);
        break;
    elseif j==N
        disp('H2 is not in Science Mode');
    end
end

load(l1sciencelist);
no3 = S5L1v00_segs(:,1);
st3 = S5L1v00_segs(:,2);
en3 = S5L1v00_segs(:,3);
ln3 = S5L1v00_segs(:,4);
P = length(st3);
for j = 1:P
    qq=find(t>=st3(j)&t<=en3(j));
    q = size(qq);
    if q(2) ~= 0;
        disp(['L1 is in Science Mode: L1 ' num2str(no3(j)) ' ' num2str(st3(j))...
            ' ' num2str(en3(j)) ' ' num2str(ln3(j))]);
		 l1 = true; l1st = st3(j); l1en = en3(j);
        break;
    elseif j==P
        disp('L1 is not in Science Mode');
    end
end

if (h1&l1)
	 dur = (min(h1en, l1en) - max(h1st, l1st));
	 disp(['H1L1 coincident duration is ' num2str(dur)]);
end


if (h2&l1)
	 dur = (min(h2en, l1en) - max(h2st, l1st));
	 disp(['H2L1 coincident duration is ' num2str(dur)]);
end


if (h1&h2)
	 dur = (min(h1en, h2en) - max(h1st, h2st));
	 disp(['H1H2 coincident duration is ' num2str(dur)]);
end


if (h1&h2&l1)
	 dur = (min([h1en h2en l1en]) - max([h1st h2st l1st]));
	 disp(['Triple coincident duration is ' num2str(dur)]);
end

if (h1&~h2&~l1)
   stuff(1) = 1; 
end

if (~h1&h2&~l1)
   stuff(2) = 1; 
end

if (~h1&~h2&l1)
   stuff(3) = 1; 
end

if (h1&h2&~l1)
   stuff(4) = 1; 
end

if (h1&~h2&l1)
   stuff(5) = 1; 
end

if (~h1&h2&l1)
   stuff(6) = 1; 
end

if (h1&h2&l1)
   stuff(7) = 1; 
end

if (~h1&~h2&~l1)
   stuff(8) = 1; 
end

disp('}}}');
disp('-----');
disp('-----');
return
