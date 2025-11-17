function [s, tot] = calc_surface(geo)

% calculate surface associated to each material in geo (for Sabine like RT
% estimations)
%
% s = calc_surface(geo)
%
% geo is a structure containing info imported from geo file.

% init locals
s = struct();

% loop over planes
for iPlane = 1:length(geo.planes)
    
    % init locals
    plane = geo.planes(iPlane);
    
    % get plane corner ids
    [tf, idx] = ismember(plane.corners, [geo.corners.id]);
    ids = idx(tf);
    
    % get corner coordinates
    xyz = vertcat(geo.corners(ids).xyz);
    
    % calculate plane area
    if size(xyz, 1) == 3
        
        % Triangle: 0.5 * |cross(v1,v2)|
        v1 = xyz(2,:) - xyz(1,:);
        v2 = xyz(3,:) - xyz(1,:);
        area = 0.5 * norm(cross(v1, v2));

    elseif size(xyz, 1) == 4
        
        % Quad: split into two triangles and sum
        v1 = xyz(2,:) - xyz(1,:);
        v2 = xyz(4,:) - xyz(1,:);
        v3 = xyz(3,:) - xyz(2,:);
        v4 = xyz(4,:) - xyz(2,:);
        area = 0.5 * (norm(cross(v1, v2)) + norm(cross(v3, v4)));

    else
        error('only support triangles or quads');
    end
    
    % save to locals
    if( ~isfield(s, plane.material) )
        s.(plane.material) = area;
    else
        s.(plane.material) = s.(plane.material) + area;
    end

end

% calculate total surface: init
fieldNames = fieldnames(s);
tot = 0;

% calculate total surface: loop over materials
for iField = 1:length(fieldNames)
    tot = tot + s.(fieldNames{iField});
end