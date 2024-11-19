function [] = plot_geo(geo)

% init locals
cornerIds = [geo.corners.id];

% init plot 
plot(0, 'HandleVisibility','off');

% loop over planes 
for iPlane = 1:length(geo.planes)

    % init locals
    plane = geo.planes(iPlane);
    corners_xyz = [];

    % get plane corners 
    for iCorner = 1:length(plane.corners)
        
        cornerId = plane.corners(iCorner);
        id = find(cornerIds == cornerId);
        corner = geo.corners(id);
        corners_xyz = [corners_xyz; corner.xyz];

    end

    % get plane material
    materialId = find( ismember({geo.materials.name}, plane.material) );
    material = geo.materials(materialId);

    % plot plane
    c = material.color / 255;
    patch(corners_xyz(:, 1), corners_xyz(:, 2), corners_xyz(:, 3), c, 'facealpha', 0.2);

end

% format plot
hold off,
axis equal,
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
view([-45 15]);
title(sprintf('%d materials, %d corners, %d planes', length(geo.materials), length(geo.corners), length(geo.planes)));