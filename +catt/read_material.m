function materials = read_material(filePath)

% load material from currated GEO.LOC file (only material definition section
%  
% [materials] = read_material(filePath)
% 
% materials is a struct array containing materials ids, absorption and scattering

% load receiver file
fid = fopen(filePath);

% init locals
matTemplate = struct('name', '', 'abs', [], 'scat', [], 'color', []);
materials = matTemplate;

% loop over lines
while true
    
    % get line
    tline = fgetl(fid);

    % discard if end of file
    if ~ischar(tline); break; end

    % discard if line not a material line
    if( ~startsWith(tline, 'abs') ); continue; end
    
    % init locals
    mat = matTemplate;

    % split strings: init
    idsLeftArrow = strfind(tline, '<');
    idsRightArrow = strfind(tline, '>');
    idsLeftBrace = strfind(tline, '{');
    idsRightBrace = strfind(tline, '}');

    % shape data: name
    tlineName = strsplit(tline, '='); tlineName = tlineName{1};
    tlineName = strrep(tlineName, 'ABS', '');
    tlineName = strtrim(tlineName);
    mat.name = tlineName;

    % shape data: abs
    tlineAbs = tline( (idsLeftArrow(1)+1):(idsRightArrow(1)-1) );
    tlineAbs = strrep(tlineAbs, ':', '');
    tlineAbs = strtrim(tlineAbs);
    tlineAbs = strsplit(tlineAbs);
    mat.abs = str2double(tlineAbs);

    % shape data: scattering
    if( length(idsLeftArrow) == 2 )
        
        tlineScat = tline( (idsLeftArrow(2)+1):(idsRightArrow(2)-1) );
        tlineScat = strrep(tlineScat, ':', '');
        tlineScat = strtrim(tlineScat);
        tlineScat = strsplit(tlineScat);
        mat.scat = str2double(tlineScat);

    end

    % shape data: color
    if( length(idsLeftBrace) == 1 )
        
        tlineCol = tline( (idsLeftBrace+1):(idsRightBrace-1) );
        tlineCol = strtrim(tlineCol);
        tlineCol = strsplit(tlineCol);
        mat.color = str2double(tlineCol);

    end
    
    % save to locals
    materials(end+1) = mat;

end

% close file
fclose(fid);

% remove first (dummy) 
materials(1) = [];

return 


%% debug

filePath = '/Users/pyrus/Projects/Treble/GA models exchange/Theatre_Athenee/Treble/model/materials_catt.txt';
materials = catt.read_material(filePath);

materials
