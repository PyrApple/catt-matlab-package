function [] = write_md9(filePath, md9)

% write_md9 write project data to an existing .md9 file.
%
% [] = write_md9(filename, md9)
%
%
% filePath is a string.
% md9 is a structure as that generated by the read_md9 function.


% init locals
specs = catt.md9_specs(); 
fieldNames = fieldnames(specs);

% sanity check on file exists
if( ~isfile(filePath) ); error('write_md9 requires that filePath points to an existing MD9 file'); end

% sanity check on sources_used
if( ~ismatrix(md9.sources_used) || ~isequal( size(md9.sources_used), [26, 10]) )
    error('unexpected sources_used field dimensions');
end

% sanity check on receivers_used
if( ~isvector(md9.receivers_used) || ~(length(md9.receivers_used) == 100) )
    error('unexpected receivers_used field dimensions');
end

% open file
fid = fopen(filePath, 'r+', 'l');

% loop over supported md9 fields
for iField = 1:length(fieldNames)
    
    % init locals
    fieldName = fieldNames{iField};    
    spec = specs.(fieldName);
    data = md9.(fieldName);
    
    % move write pointer
    fseek(fid, spec.start, 'bof');

    % switch over formats
    switch spec.format

        case 'ubit1'
            
            % write
            fwrite(fid, data.', spec.format, 'l');

        case 'uint8=>char'

            % check length
            if( length(data) >= spec.length )

                % warn
                warning('string too long, clipping %s', fieldName); 

                % clip 
                data = data(1:(spec.length-1));

            end

            % append null character (indicates end of string in catt)
            data(end+1) = char(0);

            % write
            fwrite(fid, data, 'uint8', 'l');

        otherwise

            warning('undefined format: %s, skip write', spec.format);
    
    end

end

% close
fclose(fid);

end
