function geo = read_geo(filePath)

% read_geo read info from .geo file
%
% geo = read_geo(filePath)
%
% filePath is a string.
% geo is a structure containing info imported from geo file.
% 
% notes:
% - the parser will ignore planes defined with linebreaks (catt does that 
%   when the line is too long)

% init locals
geo = struct();
currentSection = 'materials';
materials = struct('name', '', 'absorption', [], 'scattering', [], 'estimate', NaN, 'color', []);
corners = struct('id', 0, 'xyz', []);
planes = struct('id', 0, 'name', '', 'corners', [], 'material', '');

% load file
lines = catt.read_common(filePath);

% if load result is empty, return
if( isempty(lines) ); return; end

% loop over file content
concatLine = false;
for iLine = 1:length(lines)

    % read line 
    if( concatLine )
        line = [line ' ' lines{iLine}];
        concatLine = false;
    else
        line = lines{iLine};
    end
    
    % switch to corner section 
    if startsWith(line, 'CORNERS'); currentSection = 'corners'; continue; end

    % switch to planes section 
    if startsWith(line, 'PLANES'); currentSection = 'planes'; continue; end
    
    % section specific processing
    switch currentSection

        case 'materials'

            % save to locals
            materials(end+1) = process_line_material(line);
            
        case 'corners'

            % format corner line
            tmp = sscanf(line, '%f').';

            % save to locals
            corners(end+1) = struct('id', tmp(1), 'xyz', tmp(2:4));

        case 'planes'
            
            % handle imcomplete lines (linebreak, requires concatenation with n+1)
            if( ~(contains(line, '[') && contains(line, ']')) )

                % flag concatenation required with n+1 line
                concatLine = true;                

                % skip remainder
                continue;
            end

            % skip conditional planes 
            if( sum(ismember(line, '/')) > 2 )
                warning('discard plane sub-division line: %s\n', line);
                continue; 
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

end


%% local functions

function material = process_line_material(line)
    
% init locals
material = struct();

% extract name (lowered as catt not case-sensitive and some .geo file alternate)
tmp = strip(extractBetween(lower(line), 'abs', '='));
material.name = lower(tmp{1});

% extrac absorption
line = strrep(line, ',', '.');
tmp = extractBetween(line, '<', '>');
absorption = sscanf(strrep( tmp{1}, ':', '' ), '%f').';

% extract scattering
scattering = nan(1, 8);
estimate = NaN;
if( length(tmp) == 2 )

    % estimate line 
    if( contains(tmp{2}, 'estimate') )
        estimate = str2double(extractBetween(tmp{2}, '(', ')'));
    % explicit scattering definition
    else
        scattering = sscanf(strrep( tmp{2}, ':', '' ), '%f').';
    end
end

% homogeneise num. el in abs/scat
nBands = 8;
material.absorption = [absorption zeros(nBands-length(absorption), 1)];
material.scattering = [scattering zeros(nBands-length(scattering), 1)];
material.estimate = estimate;

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
material = lower(strip(tmp{2}));

% % handle subdivided planes (won't work for materials with parenthesis in
% % their name)
% tmp = extractBetween(line, '(', ')');
% for iLine = 1:length(tmp)
%     t = tmp{iLine};
%     corners = extractBetween(t, '/', '/');
%     corners = sscanf(corners{1}, '%d').'
%     t = strsplit(t, '/');
%     material = strip(t{3})
% end

% remove potential '*' from material name
if( contains(material, '*') ); material = extractBefore(material, '*'); end
plane.material = material;

end


