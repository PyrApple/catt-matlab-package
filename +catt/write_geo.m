function [] = write_geo(filename, geo)

% write_geo write scene data to a .geo catt file
%
% [] = write_geo(filename, geo)
% 
%
% filePath is a string.
% geo is a structure as that generated by the read_geo function.


% open file
fid = fopen(filename, 'w');

% file header
fprintf(fid, ';File automatically generated from Matlab script\r\n');
fprintf(fid, '\r\n');

% loop over materials
for iMat = 1:length(geo.materials)
    
    % init locals
    material = geo.materials(iMat);
    
    % format line
    line = ['ABS ' material.name ' ='];
    line = sprintf('%s <%.1f %.1f %.1f %.1f %.1f %.1f : %.1f %.1f > L', line, material.absorption);
    line = sprintf('%s <%.1f %.1f %.1f %.1f %.1f %.1f : %.1f %.1f > ', line, material.scattering);
    line = sprintf('%s { %d %d %d }\r\n', line, material.color);

    % write line to file
    fprintf(fid, line);
end

% write corners header
fprintf(fid, '\r\n');
fprintf(fid, 'CORNERS\r\n');
fprintf(fid, '\r\n');

% loop over corners
for iCorner = 1:length(geo.corners)
    
    % init locals
    corner = geo.corners(iCorner);

    % write line to file
    fprintf(fid, '%d %.3f %.3f %.3f\r\n', corner.id, corner.xyz);

end

% write planes header
fprintf(fid, '\r\n');
fprintf(fid, 'PLANES\r\n');
fprintf(fid, '\r\n');

% loop over planes
for iPlane = 1:length(geo.planes)
    
    % init locals
    plane = geo.planes(iPlane);

    % format line
    line = sprintf('[ %d %s / ', plane.id, plane.name);
    line = [line ' ' sprintf('%d ', plane.corners)];
    line = sprintf('%s / %s ]\r\n', line, plane.material);

    % write line to file
    fprintf(fid, line);
end

% close file
fclose(fid);

end