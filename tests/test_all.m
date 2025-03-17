%% init

% init paths
folderPath = fullfile(pwd, 'assets');

% define functions to be tested and test files
configs = {};
configs{end+1} = struct('fname', 'read_md9', 'spattern', '*.md9');
configs{end+1} = struct('fname', 'read_geo', 'spattern', '*.geo');
configs{end+1} = struct('fname', 'read_material', 'spattern', '*.geo');
configs{end+1} = struct('fname', 'read_receiver', 'spattern', '*rec.loc');
configs{end+1} = struct('fname', 'read_source', 'spattern', '*src.loc');
configs{end+1} = struct('fname', 'read_imagesource', 'spattern', '*_ism.txt');
configs{end+1} = struct('fname', 'read_interactive_rt60', 'spattern', '*_rt60.txt');
configs{end+1} = struct('fname', 'read_parameters', 'spattern', '*_meas.txt');
configs{end+1} = struct('fname', 'read_ir_mat', 'spattern', '*.mat');

% % not included in test:
% write_geo
% plot_scene
% read_ir_mat

% loop over tests
for iConfig = 1:length(configs)
    
    % init locals
    config = configs{iConfig};

    % get list of files
    fileList = dir(fullfile(folderPath, config.spattern));
    fprintf('%s num. files: %d \n', config.fname, length(fileList));
    
    % loop over files
    for iFile = 1:length(fileList)
        
        % shape file path
        file = fileList(iFile);
        filePath = fullfile(file.folder, file.name);

        % test method
        fprintf('# %s(%s) \n', config.fname, file.name);
        s = catt.(config.fname)(filePath);

        % show output
        if( strcmp( config.fname, 'read_ir_mat' ) ); continue; end
        s
    
    end

end


