function str = bytes2human(bytes)
% Convert bytes to human readable format
%
% string = bytes2human(bytes);
if bytes<=0, str='0 B'; return; end
levels= {'B','KB','MB','GB','TB','PB'};
scale = floor(log(bytes)/log(1024));
if scale>5, scale=5; end
str = [num2str(bytes/1024^scale) ' ' levels{scale+1}];
if nargout==0
    fprintf('%s\n',str);
    clear str;
end
end
