function geo = read_geo(filePath)

% read_geo read info from .geo file
%
% geo = read_geo(filePath)
%
% filePath is a string.
% geo is a structure containing info imported from geo file.
% 
% notes:
% - avoid long material names (there is a hard limit in catt of ... chars)
% - avoid special characters in material names
% - there might be a constraint on the normal of the first plane defined in
%   the geo file
% - fix .geo files where catt added linebreaks when planes definition was
%   too long

% init locals
geo = struct();
currentSection = 'materials';
materials = struct('name', '', 'absorption', [], 'scattering', [], 'color', []);
corners = struct('id', 0, 'xyz', []);
planes = struct('id', 0, 'name', '', 'corners', [], 'material', '');

% abort if restricted keywords found
if( catt.is_parsable(filePath) ) 
    % warning('unsupported keyword in file %s, parsing aborted', filePath);
    return;
end

% open file
fid = fopen(filePath, 'r');
data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);
lines = data{1}; 

% loop over file content
for iLine = 1:length(lines)

    % read line 
    line = lines{iLine};
    
    % skip empty lines
    if isempty(line); continue; end
    
    % skip comments
    if startsWith(line, ';'); continue; end
    
    % switch to corner section 
    if startsWith(line, 'CORNERS'); currentSection = 'corners'; continue; end

    % switch to planes section 
    if startsWith(line, 'PLANES'); currentSection = 'planes'; continue; end
    
    % section specific processing
    switch currentSection

        case 'materials'

            % discard if not material line
            % if ~startsWith(line, 'ABS'); warning('unexpected line: %s', line); continue; end
            
            % save to locals
            materials(end+1) = process_line_material(line);
            
        case 'corners'

            % format corner line
            tmp = sscanf(line, '%f').';

            % discard if not only number line
            % if( isempty(tmp) ); continue; end

            % save to locals
            corners(end+1) = struct('id', tmp(1), 'xyz', tmp(2:4));

        case 'planes'
            
            % discard if line not valid
            if( sum( ismember(line, '/') ) < 2 )
                warning('plane discared (line break not supported):\n %s', line);
                continue
            end

            % save to locals
            planes(end+1) = process_line_plane(line);

        otherwise
            error('undefined section %s', currentSection)
    end

end

% remove dummys
materials(1) = [];
corners(1) = [];
planes(1) = [];

% save to locals
geo.materials = materials;
geo.corners = corners;
geo.planes = planes;

% % check that first plane is upright
% [n] = polygon_normals(polygons, nodes);
% 
% if abs(sum(n(:,1) - [0, 0, 1]')) > 1e-10
%     warning('CATT requires first plane to be upright');
% end

end


function material = process_line_material(line)
    
% init locals
material = struct();

% extract name (lowered as catt not case-sensitive and some .geo file alternate)
tmp = strip(extractBetween(lower(line), 'abs', '='));
material.name = lower(tmp{1});

% extrac absorption
tmp = extractBetween(line, '<', '>');
absorption = sscanf(strrep( tmp{1}, ':', '' ), '%f').';

% extract scattering
scattering = [0 0 0 0 0 0 0 0];
if( length(tmp) == 2 )
    scattering = sscanf(strrep( tmp{2}, ':', '' ), '%f').';
end

% homogeneise num. el in abs/scat
nElmt = 8;
material.absorption = [absorption zeros(nElmt-length(absorption), 1)];
material.scattering = [scattering zeros(nElmt-length(scattering), 1)];

% extract color
tmp = extractBetween(line, '{', '}');
material.color = sscanf(tmp{1}, '%f').';

end


function plane = process_line_plane(line)

% init locals
plane = struct();

% extract first half (plane id and name)
tmp = extractBetween(line, '[', '/');
tmp = strsplit(strip(tmp{1}));
plane.id = sscanf(tmp{1}, '%d');
plane.name = tmp{2};

% extract second half (coner ids and material name)
tmp = extractBetween(line, '/', ']');
tmp = strsplit(tmp{1}, '/');

plane.corners = sscanf(tmp{1}, '%d').';
plane.material = lower(strip(tmp{2}));

end


