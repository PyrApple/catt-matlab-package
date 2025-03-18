function s = read_imagesource(filePath)

% read_imagesource read data from image sources .txt file exported from catt.
%
% imagesources = read_imagesource(filePath)
%
% filePath is a string.
% imagesources is a structure containing info imported from file.


% init locals
listener = struct('id', nan, 'pos', [], 'aim', []);
source = struct('id', nan, 'pos', [], 'aim', []);

% loop over lines
fid = fopen( filePath, 'r' );
tline = '';

while( ischar( tline ) == true )
    
    % get new line
    tline = fgetl( fid );
    if( ~ischar( tline ) ); break, end
    
    % general line shaping
    tline = strrep( tline, ',', '.' );

    % listener id line
    if( contains( tline, 'Rec id:') )
        sourceId = str2double( tline(12:13) );
        listener.id = sourceId;
        continue
    end

    % listener pos line
    if( contains( tline, 'Rec pos:') )
        tcell = strsplit(tline, '\t');
        pos = cellfun( @(x) str2double( x ), tcell(2:end-1));
        listener.pos = pos;
        continue
    end
    
    % listener aim line
    if( contains( tline, 'Rec aim:') )
        tcell = strsplit(tline, '\t');
        aim = cellfun( @(x) str2double( x ), tcell(2:end-1));
        listener.aim = aim;
        continue
    end

    % source id line (support unique source)
    if( contains( tline, 'Srd id(s):') )
        source.id = str2double(tline(16));
        continue
    end
    
    % general shape line
    tcell = strsplit(tline, '\t');

    % discard if line is not source image line (first element should be int)
    if( length(tcell) ~= 18 ); continue, end

    % shape line
    A = cellfun( @(x) str2double(strrep(x, '"', '')), tcell(1:end-1));

    % second discard check
    if( sum(isnan( A )) ~= 1 ); continue, end

    % shape line
    A(3) = str2double(tcell{3}(3));

    % order 0, save source position
    order = A(4);
    if( order == 0 )
        source.pos = A(5:7);
    end

    % save image source to locals
    image = struct();
    image.id = A(1);         % #
    image.time = A(2);       % time [ms]
    image.order = A(4);      % order
    image.pos = A(5:7);      % IS(x) [m]
    image.h = A(8);          % H [deg]
    image.v = A(9);          % V [deg]
    image.spl = A(10:end);   % SPL [dB]  (125 250 500 1k 2k 4k 8k 16k)

    % create image source struct if need be
    if( ~exist('images', 'var') )
        images(1) = image;
    else
        images(end+1) = image;
    end

end

% close file
fclose( fid );

% shape output data
listeners(1) = listener;
sources(1) = source;
s = struct('listeners', listener, 'sources', source, 'images', images);
    
end
