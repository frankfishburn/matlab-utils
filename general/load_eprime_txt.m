function data = load_eprime_txt( filename )
% Read E-Prime .txt data files into a table
% Usage: data = load_eprime_txt( filename )
warning('off','MATLAB:iofun:UnsupportedEncoding');
fid = fopen( filename , 'r' , 'n' , 'utf-16'  );
warning('on','MATLAB:iofun:UnsupportedEncoding');

prev_row = 0;
current_row = nan;

data = table;
warning('off','MATLAB:table:RowsAddedExistingVars');

tline = fgetl( fid );
while ischar(tline)
   
    tline = strip(tline);
    
    if strcmp(tline,'*** LogFrame Start ***')
        current_row = prev_row + 1;
    end
    if strcmp(tline,'*** LogFrame End ***')
        prev_row = current_row;
        current_row = nan;
    end
    if strcmp(tline,'Level: 1')
        break;
    end
    
    if isnan(current_row), tline = fgetl(fid); continue; end
    
    [key,value] = parse_line( tline );
    
    if ~isempty(key) && ~isempty(value)
        data.(key){current_row,1} = value;
    end
    
    tline = fgetl(fid);
end
fclose(fid);
warning('on','MATLAB:table:RowsAddedExistingVars');

end

function [key,value] = parse_line(line)
cind = strfind(line,':');
if ~isempty(cind)
    key = line(1:cind-1);
    value = line(cind+2:end);
    dots = strfind(key,'.');
    if ~isempty(dots)
        key = key(dots(end)+1:end);
    end
else
    key = [];
    value = [];
end
end
