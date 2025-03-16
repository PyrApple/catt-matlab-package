function src = read_source(filePath)

% read_source read data from a catt .loc source file
% 
% src = read_source(filePath)
%
% filePath is a string.
% src is a structure containing source informations (ids and positions)

% abort if restricted keywords found
if( catt.is_parsable(filePath) ) 
    % warning('unsupported keyword in file %s, parsing aborted', filePath);
    src = struct();
    return
end

% load source file
fid = fopen(filePath);

% init locals
srcTemplate = struct('id', -1, 'idStr', '', 'xyz', [-Inf -Inf -Inf], 'aimpos', [-Inf -Inf -Inf]);
src = srcTemplate;

% loop over lines
while true
    
    % get line
    tline = fgetl(fid);

    % discard if end of file
    if ~ischar(tline); break; end
    
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

    elseif( contains(tline, 'POS') )

        tmp = strsplit(tline, '='); tmp = tmp{2};
        s.xyz = str2num(tmp);

    end
   
end

% close file
fclose(fid);

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
