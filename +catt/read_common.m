function lines = read_common(filePath)

% read_common loads a text file and cleans it
%
% lines = read_common(filePath)
%
% filePath is a string.
% lines is a cell with each element a line.

% load lines from file
fid = fopen(filePath, 'r');
data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);
lines = data{1}; 

% remove empty lines
selVect = ~cellfun('isempty', lines);
lines = lines(selVect);

% strip leading / ending zeros
lines = strip(lines);

% remove commented lines
selVect = cellfun(@(x) ~startsWith(x, ';'), lines);
lines = lines(selVect);

% return empty if restricted keywords found
if( ~is_parsable(lines, filePath) ) 
    lines = {};
    return
end

end


%% local functions

function isParsable = is_parsable(lines, filePath)

% init locals
isParsable = true;
keywords = {'GLOBAL', 'INCLUDE', 'LOCAL', 'IF', 'ENDIF', 'SOURCEDEFS'};

% loop over restricted keywords
for iWord = 1:length(keywords)
    
    % init locals
    word = keywords{iWord};

    % search for keyword
    idx = find( cellfun(@(x) contains(x, word), lines), 1 );

    % keyword found? log warning
    if( ~isempty( idx ) )
        isParsable = false;
        warning('unsupported keyword "%s" in file %s', word, filePath);
    end

end

end