function s = read_interactive_rt60( filePath )

% read_interactive_rt60 read data from interactive rt60 estimation .txt file
% exported from catt.
%
% params = read_interactive_rt60(filePath)
%
% filePath is a string.
% params is a structure containing info imported from file


% init locals
nBands = 6;
freqs = nan(nBands, 1);
T30 = freqs; rt60_Eyring = freqs; rt60_Sabine = freqs;

% loop over lines
fid = fopen( filePath, 'r' );
tline = '';

while( ischar( tline ) == true )
    
    % get new line
    tline = fgetl( fid );
    if( ~ischar( tline ) ); break, end
    
    % general line shaping
    tline = strrep( tline, ',', '.' );
    
    % pre freq bands line
    if( contains( tline, 'The estimated RTs become') )
        
        % jump to freq band def line
        tline = fgetl( fid ); tline = fgetl( fid );
        
        % replace k by 000
        tline = strrep( tline, 'k', '000' );
        
        % split line
        tcell = strsplit(tline, ' ');
        
        % str 2 num
        freqs = cellfun( @(x) str2double( x ), tcell(2:end-1));
        
        % reset locals default
        nBands = length(freqs);
        %
        T30 = nan(nBands, 1);
        rt60_Eyring = T30; rt60_Sabine = T30;
        
        % skip remainder
        continue
    end


    % T-30 line
    if( contains( tline, 'T-30   :') )

        % split line
        tcell = strsplit(tline, ' ');
        
        % str 2 num
        T30 = cellfun( @(x) str2double( x ), tcell(3:end-2));
        if( length(T30) ~= 8 )
            error('missing T30 values in %s', filePath); % you should manually replace every 4 empty spaces sequence with "NaN"
        end
        
        % skip remainder
        continue
    end


    % Sabine line
    if( contains( tline, 'Sabine :') )

        % split line
        tcell = strsplit(tline, ' ');

        % str 2 num
        rt60_Sabine = cellfun( @(x) str2double( x ), tcell(3:end-1));

        % skip remainder
        continue
    end

    % Eyring line
    if( contains( tline, 'Eyring :') )

        % split line
        tcell = strsplit(tline, ' ');

        % str 2 num
        rt60_Eyring = cellfun( @(x) str2double( x ), tcell(3:end-1));

        % skip remainder
        continue
    end

end

% close file
fclose( fid );

% shape output
s = struct('freqs', freqs, 't30', T30, 'rt60_sabine', rt60_Sabine, 'rt60_eyring', rt60_Eyring);
    
end
