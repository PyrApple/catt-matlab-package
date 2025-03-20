function rcv = read_receiver(filePath)

% read_receiver read data from a catt .loc receiver file
% 
% rcv = read_receiver(filePath)
%
% filePath is a string.
% rcv is a structure containing receiver informations (ids and positions).

% init locals
rcvTemplate = struct('id', -1, 'idStr', '', 'xyz', nan(1, 3), 'aimpos', nan(1, 3));
rcv = rcvTemplate;

% load file
lines = catt.read_common(filePath);

% if load result is empty, return
if( isempty(lines) ); rcv = struct(); return; end

% convert to array
tmp = cellfun(@str2num, lines, 'UniformOutput', false);
lines = cell2mat(tmp);

% loop over lines
for iLine = 1:size(lines, 1)
    
    % init locals
    t = lines(iLine, :);

    % extract data
    r = rcvTemplate;
    r.id = t(1);
    r.idStr = sprintf('%02d', t(1));
    r.xyz = t(2:4);

    % optional aim pos
    if( length(t) == 7 ); r.aimpos = t(5:7); end
    
    % save to locals
    rcv(end+1) = r;

end

% remove first (dummy) 
rcv(1) = [];

% sort 
[~, idx] = sort([rcv.id]);
rcv = rcv(idx);
