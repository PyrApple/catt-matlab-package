function [] = plot_scene(varargin)

% init parser
p = inputParser;
addOptional(p, 'geo', struct(''), @isstruct);
addOptional(p, 'sources', struct(''), @isstruct);
addOptional(p, 'receivers', struct(''), @isstruct);
addOptional(p, 'md9', struct(''), @isstruct);

% parse inputs
parse(p, varargin{:});
geo = p.Results.geo;
md9 = p.Results.md9;
sources = p.Results.sources;
receivers = p.Results.receivers;

% init locals
msize = 24;
fsize = 14;

% init plot
plot3(0, 0, 0, 'handlevisibility', 'off'); hold on,

% plot geo
if( ~isempty(fieldnames(geo)) )
    plot_geo(geo);
end

% default md9
if( isempty(fieldnames(md9)) )
    md9 = struct();
    md9.sources_used = ones(26, 10);
    md9.receivers_used = ones(100, 1);
end


% plot sources
if( ~isempty(fieldnames(sources)) )

    % loop over sources
    for iSrc = 1:length(sources)
        
        % init local 
        source = sources(iSrc);
    
        % get source status (active or not)
        letterId = double(source.idStr(1)) - 64;
        numId = str2double(source.idStr(2));
        isActive = md9.sources_used(letterId, numId);
    
        % define color based on status
        if( isActive ); c = [1 .3 .3]; else c = [0.8 0.5 0.5]; end
    
        % plot source
        plot3(source.xyz(1), source.xyz(2), source.xyz(3), 'ok', 'markerfacecolor', c, 'markersize', msize);
        text(source.xyz(1), source.xyz(2), source.xyz(3), source.idStr, 'horizontalalignment', 'center', 'fontsize', fsize);
    
    end

end


% plot receivers
if( ~isempty(fieldnames(receivers)) )

    % loop over receivers
    for iRcv = 1:length(receivers)
        
        % init local 
        receiver = receivers(iRcv);
        
        % get receiver status (active or not)
        isActive = md9.receivers_used(receiver.id + 1);
    
        % define color based on status
        if( isActive ); c = [.5 .5 1]; else c = [0.7 0.7 0.9]; end
    
        % plot source
        plot3(receiver.xyz(1), receiver.xyz(2), receiver.xyz(3), 'ok', 'markerfacecolor', c, 'markersize', msize);
        text(receiver.xyz(1), receiver.xyz(2), receiver.xyz(3), receiver.idStr, 'horizontalalignment', 'center', 'fontsize', fsize);
    
    end

end

% format plot
hold off,


%% local functions 

function [] = plot_geo(geo)

% init locals
cornerIds = [geo.corners.id];

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
axis equal,
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
view([-45 15]);
title(sprintf('%d materials, %d corners, %d planes', length(geo.materials), length(geo.corners), length(geo.planes)));