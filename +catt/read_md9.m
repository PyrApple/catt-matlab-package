function [config] = read_md9(filePath)

% read_md9 read data from a catt .md9 file
%
% config = read_md9(filePath)
%
% filePath is a string.
% config is a structure containing info imported from file


% init locals
specs = catt.md9_specs();
fieldNames = fieldnames(specs);
config = struct();

% open file
fid = fopen(filePath, 'r', 'l');

% loop over md9 fields
for iField = 1:length(fieldNames)
    
    % init
    fieldName = fieldNames{iField};
    spec = specs.(fieldName);
    
    % read
    fseek(fid, spec.start, 'bof');
    config.(fieldName) = fread(fid, spec.length, spec.format);
    
    % per-field specific fomatting
    if( strcmp(spec.format, 'uint8=>char') )

        % to line
        config.(fieldName) = config.(fieldName).';

        % crop end
        idEnd = find( config.(fieldName) == char(0), 1 ); % last blank character defines end of string
        config.(fieldName) = config.(fieldName)(1:idEnd-1);

    end

end

% close file
fclose(fid);

% field specific formatting
config.sources_used = config.sources_used.'; % first is letter, second is id

end

% todo: 
% - trim strings upon import based on end b'\x00'
% - constrain source/receiver array sizes