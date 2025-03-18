function rcv = read_receiver(filePath)

% read_receiver read data from a catt .loc receiver file
% 
% rcv = read_receiver(filePath)
%
% filePath is a string.
% rcv is a structure containing receiver informations (ids and positions).

% abort if restricted keywords found
if( catt.is_parsable(filePath) ) 
    warning('unsupported keyword in file %s, parsing aborted', filePath);
    rcv = struct();
    return
end

% load receiver file
fid = fopen(filePath);

% init locals
rcvTemplate = struct('id', -1, 'idStr', '', 'xyz', [-Inf -Inf -Inf]);
rcv = rcvTemplate;

% loop over lines
while true
    
    % get line
    tline = fgetl(fid);

    % discard if end of file
    if ~ischar(tline); break; end
    
    % shape data
    data = str2num(tline);

    % discard if not a valid receiver line
    if( isempty(data) ); continue; end

    % extract data
    r = rcvTemplate;
    r.id = data(1);
    r.idStr = sprintf('%02d', data(1));
    r.xyz = data(2:4);
    
    % save to locals
    rcv(end+1) = r;

end

% close file
fclose(fid);

% remove first (dummy) 
rcv(1) = [];

% sort 
[~, idx] = sort([rcv.id]);
rcv = rcv(idx);
