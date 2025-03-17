%% init

% init paths
folderPath = fullfile(pwd, 'assets');

% define functions to be tested and test files
configs = {};
configs{end+1} = struct('name', 'amst');
% configs{end+1} = struct('name', 'athenee');
configs{end+1} = struct('name', 'coupled');
configs{end+1} = struct('name', 'cube');
configs{end+1} = struct('name', 'dumbbells');
configs{end+1} = struct('name', 'elysees');
configs{end+1} = struct('name', 'fogg');
% configs{end+1} = struct('name', 'morgan');
configs{end+1} = struct('name', 'orsay');
configs{end+1} = struct('name', 'pleyel');
% configs{end+1} = struct('name', 'saintgermain');
configs{end+1} = struct('name', 'shoebox');
configs{end+1} = struct('name', 'snail');
configs{end+1} = struct('name', 'vienne');

% loop over tests
for iConfig = 1:length(configs)
    
    % init locals
    config = configs{iConfig};
    
    % 'geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9

    % load geo
    filePath = fullfile(folderPath, [config.name '.geo']);
    geo = catt.read_geo(filePath);

    % load md9
    filePath = fullfile(folderPath, [config.name '.md9']);
    md9 = catt.read_md9(filePath);

    % load sources
    filePath = fullfile(folderPath, [config.name '_src.loc']);
    sources = catt.read_source(filePath);

    % load receiver
    filePath = fullfile(folderPath, [config.name '_rec.loc']);
    receivers = catt.read_receiver(filePath);

    % plot
    catt.plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9);
    
    % save
    filePath = fullfile(pwd, 'figures', [config.name '.png']);
    saveas(gcf, filePath);
    fprintf('save %s\n', config.name);

end


