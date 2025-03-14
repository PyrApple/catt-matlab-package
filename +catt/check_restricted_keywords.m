function foundRestrictedKeyword = check_restricted_keywords(filePath)

% check_restricted_keywords check for presence of restricted keyword in
% file at filePath. Restricted keywords such as 'LOCAL', 'GLOBAL', etc. are
% not supported by the parsers in the toolbox
%
% foundRestrictedKeyword = check_restricted_keywords(filePath)
%
% filePath is a string.
% foundRestrictedKeyword is boolean.

% init locals
foundRestrictedKeyword = false;

% read file
fid = fopen(filePath, 'r');
data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);
lines = data{1}; 

% % to lower case 
% lines = lower(lines);

% sanity check for unsupported keywords
keywords = {'GLOBAL', 'INCLUDE', 'LOCAL', 'IF', 'ENDIF'};

% loop over restricted keywords
for iWord = 1:length(keywords)
    
    % init locals
    word = keywords{iWord};

    % find lines containing word
    idx = find( cellfun(@(x) contains(x, word), lines) );

    % remove commented lines
    idx = idx( ~startsWith( strip(lines(idx)), ';' ) );

    % trigger unsupported message
    if( ~isempty( idx ) )
        foundRestrictedKeyword = true;
        warning('unsupported keyword "%s" in file %s', word, filePath);
    end

end
