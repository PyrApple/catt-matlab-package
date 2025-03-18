function [md9] = read_md9(filePath)

% read_md9 read data from a catt .md9 file
%
% md9 = read_md9(filePath)
%
% filePath is a string.
% md9 is a structure containing info imported from file.


% init locals
specs = catt.md9_specs();
fieldNames = fieldnames(specs);
md9 = struct();

% open file
fid = fopen(filePath, 'r', 'l');

% loop over md9 fields
for iField = 1:length(fieldNames)
    
    % init
    fieldName = fieldNames{iField};
    spec = specs.(fieldName);
    
    % read
    fseek(fid, spec.start, 'bof');
    md9.(fieldName) = fread(fid, spec.length, spec.format);
    
    % per-field specific fomatting
    if( strcmp(spec.format, 'uint8=>char') )

        % to line
        md9.(fieldName) = md9.(fieldName).';

        % crop end
        idEnd = find( md9.(fieldName) == char(0), 1 ); % last blank character defines end of string
        md9.(fieldName) = md9.(fieldName)(1:idEnd-1);

    end

end

% close file
fclose(fid);

% field specific formatting
md9.sources_used = md9.sources_used.'; % first is letter, second is id

end

% todo: 
% - trim strings upon import based on end b'\x00'
% - constrain source/receiver array sizes