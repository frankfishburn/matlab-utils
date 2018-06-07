function newtime = time_convert(seconds)
% Converts seconds (numeric) to hh:mm:ss.xxx (string)
% Usage: time = time_convert(seconds)
hours=0; minutes=0;
if seconds >= 3600
   hours=floor(seconds/3600);
   seconds=mod(seconds,3600);
end
if seconds >= 60
   minutes=floor(seconds/60);
   seconds=mod(seconds,60);
end
msec=round((seconds-floor(seconds))*1000);
seconds=floor(seconds);
newtime=sprintf('%02i:%02i:%02i.%03i',hours,minutes,seconds,msec);
if nargout==0
   disp(newtime);
   clear newtime;
end
end
