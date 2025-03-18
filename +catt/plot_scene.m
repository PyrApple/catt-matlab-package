function [] = plot_scene(varargin)

% plot_scene plots a catt scene.
%
% [] = plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9, 'facealpha', 0.3, 'showlegend', false);
%
% every input is optional.

% init parser
p = inputParser;
addParameter(p, 'geo', struct(''), @isstruct);
addParameter(p, 'sources', struct(''), @isstruct);
addParameter(p, 'receivers', struct(''), @isstruct);
addParameter(p, 'md9', struct(''), @isstruct);
addParameter(p, 'facealpha', 0.3, @isfloat);
addParameter(p, 'showlegend', false, @islogical);

% parse inputs
parse(p, varargin{:});
geo = p.Results.geo;
md9 = p.Results.md9;
sources = p.Results.sources;
receivers = p.Results.receivers;
facealpha = p.Results.facealpha;
showlegend = p.Results.showlegend;

% init locals
msize = 24;
fsize = 14;

% init plot
plot3(0, 0, 0, 'handlevisibility', 'off');
titleStr = '';
hold on,

% default md9
if( isempty(fieldnames(md9)) )
    md9 = struct();
    md9.sources_used = ones(26, 10);
    md9.receivers_used = ones(100, 1);
else
    titleStr = [ titleStr 'Project: ' md9.project_name ',' ];
end

% plot geo
if( ~isempty(fieldnames(geo)) )
    plot_geo(geo, facealpha, showlegend);
    titleStr = [ titleStr ' ' sprintf('%d materials, %d corners, %d planes', length(geo.materials), length(geo.corners), length(geo.planes)) ];
end

% plot sources
if( ~isempty(fieldnames(sources)) )

    % loop over sources
    for iSrc = 1:length(sources)
        
        % init local 
        source = sources(iSrc);
    
        % get source status (active or not)
        letterId = double(source.idStr(1)) - 64;
        numId = str2double(source.idStr(2)) + 1; % +1 because catt sources ids start from 0
        isActive = md9.sources_used(letterId, numId);
    
        % define color based on status
        if( isActive ); c = [1 .4 .4]; else c = [0.9 0.7 0.7]; end
    
        % plot source
        plot3(source.xyz(1), source.xyz(2), source.xyz(3), 'ok', 'markerfacecolor', c, 'markersize', msize, 'handlevisibility', 'off');
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
        if( isActive ); c = [.6 .6 1]; else c = [0.8 0.8 0.9]; end
    
        % plot source
        plot3(receiver.xyz(1), receiver.xyz(2), receiver.xyz(3), 'ok', 'markerfacecolor', c, 'markersize', msize, 'handlevisibility', 'off');
        text(receiver.xyz(1), receiver.xyz(2), receiver.xyz(3), receiver.idStr, 'horizontalalignment', 'center', 'fontsize', fsize);
    
    end

end

% format plot
axis equal,
title(titleStr);
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
view([-45 15]);
hold off,

end


%% local functions 

function [] = plot_geo(geo, facealpha, showlegend)

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
    
    % handle unknown materials (e.g. when using catt syntax matName(rgb) in geo file)
    if( isempty(materialId) )
        warning('undefined materials: %s', plane.material);
        material = struct('color', [0 0 0]);
    end

    % plot plane
    c = material.color / 255;
    patch(corners_xyz(:, 1), corners_xyz(:, 2), corners_xyz(:, 3), c, 'facealpha', facealpha);

end

% add legend
if( showlegend )

    % loop over materials
    for iMat = 1:length(geo.materials)
        h(iMat) = patch(NaN, NaN, geo.materials(iMat).color / 255, 'facealpha', facealpha);
    end

    % add Legend
    matNames = cellfun(@(x) strrep(x, '_', '-'), {geo.materials.name}, 'UniformOutput', false);
    legend(h, matNames);
end

end