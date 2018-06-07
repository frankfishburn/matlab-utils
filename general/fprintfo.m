function msg = fprintfo( varargin )
% Simple modification of fprintf that deletes x characters before printing.
% Good for messages that update without polluting the command window.
%
% Behaves like fprintf() but with an additional first parameter which is
% number of characters to be overwritten
%
% msglen = fprintfo( msglen , [fprintf input] );
%
% Usage:
%  msg = 0;
%  for i = 1:1000
%      msg = fprintfo( msg, 'Processing %i of %i', i, 1000 );
%  end
%  fprintfo( msg, 'Done!' );
number_to_overwrite = varargin{1}(1);
if numel(varargin{1})==1
    lastfprintfo = uint64(0);
else
    lastfprintfo = varargin{1}(2);
end

% Don't update if too soon since last time (Java might implode)
if ~isempty(varargin{2})
    delta = toc(lastfprintfo);
    if delta<.5
        msg = varargin{1};
        return
    end
end

fprintf(repmat('\b',[1 number_to_overwrite])); % Delete characters
fprintf(repmat(' ' ,[1 number_to_overwrite])); % Overwrite w/ spaces (needed for some terminal apps)
fprintf(repmat('\b',[1 number_to_overwrite])); % Delete spaces

% Write new message and output number of characters and current time
msg = [uint64(fprintf(varargin{2:end})) toc(lastfprintfo)];

end
