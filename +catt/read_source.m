function src = read_source(filePath)

% read_source read data from a catt .loc source file
% 
% src = read_source(filePath)
%
% filePath is a string.
% src is a structure containing source informations (ids and positions).

% init locals
srcTemplate = struct('id', -1, 'idStr', '', 'xyz', nan(1, 3), 'aimpos', nan(1, 3), 'aimangles', nan(1, 2));
src = srcTemplate;

% load file
lines = catt.read_common(filePath);

% if load result is empty, return
if( isempty(lines) ); src = struct(); return; end

% loop over lines
for iLine = 1:length(lines)
    
    % get line
    tline = lines{iLine};
    
    % start of a new source definition
    if( contains(tline, 'SOURCE ') )
        
        % save old source to locals if exists 
        if( exist('s', 'var') ); src(end+1) = s; end

        % init new local source
        s = srcTemplate;
        
        % shape data
        tmp = strsplit(tline, ' '); tmp = tmp{2};
        s.idStr = tmp;

    elseif ( contains(tline, 'AIMPOS') )
    
        tmp = strsplit(tline, '='); tmp = tmp{2};
        s.aimpos = str2num(tmp);

    elseif ( contains(tline, 'AIMANGLES') )
    
        tmp = strsplit(tline, '='); tmp = tmp{2};
        s.aimangles = str2num(tmp);

    elseif( contains(tline, 'POS') )

        tmp = strsplit(tline, '='); tmp = tmp{2};
        s.xyz = str2num(tmp);

    end
   
end

% save last source
if( exist('s', 'var') ); src(end+1) = s; end

% remove first (dummy) 
src(1) = [];

% sort 
[~, idx] = sort({src.idStr});
src = src(idx);

% add extra fields
for iSrc = 1:length(src)
    src(iSrc).id = iSrc;
end
