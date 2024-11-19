
% todo dpq
% - support empty lines between CORNERS and data, PLANES and data
% - support ABS or abs
% - change output structure organisation 

function geo = read_geo(filename)

% init locals
currentSection = 'materials';
materials = struct('name', '', 'absorption', [], 'scattering', [], 'color', []);
corners = struct('id', 0, 'xyz', []);
planes = struct('id', 0, 'name', '', 'corners', [], 'material', '');

% open file
fid = fopen(filename);

% loop over file content
while ~feof(fid)

    % read line 
    line = fgetl(fid);
    
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
            tmp = sscanf(line, '%f');

            % discard if not only number line
            % if( isempty(tmp) ); continue; end

            % save to locals
            corners(end+1) = struct('id', tmp(1), 'xyz', tmp(2:4));

        case 'planes'
                
            % save to locals
            planes(end+1) = process_line_plane(line);

        otherwise
            error('undefined section %s', currentSection)
    end

    

end

% close file
fclose(fid);

% remove dummys
materials(1) = [];
corners(1) = [];
planes(1) = [];

% save to locals
geo.materials = materials;
geo.corners = corners;
geo.planes = planes;

end


function material = process_line_material(line)
    
% init locals
material = struct();

% extract name
tmp = strip(extractBetween(line, 'ABS', '='));
material.name = tmp{1};

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
plane.material = strip(tmp{2});

end


