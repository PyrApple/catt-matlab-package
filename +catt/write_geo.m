%
% NOTES: CATT file's first element must be upright on the floor (0, 0, 1).
%        No special character's in any names!
%        Short names only!

% % CHECK that first plane is upright
% [n] = polygon_normals(polygons, nodes);
% 
% if abs(sum(n(:,1) - [0, 0, 1]')) > 1e-10
%     warning('CATT requires first plane to be upright! Sorry :(');
% end

function [] = write_geo(filename, geo)

% open file
fid = fopen(filename, 'w');

% file header
fprintf(fid, ';Header Comment\r\n');
fprintf(fid, '\r\n');

% loop over materials
for iMat = 1:length(geo.materials)
    
    % init locals
    material = geo.materials(iMat);
    
    % format line
    line = ['ABS ' material.name];
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