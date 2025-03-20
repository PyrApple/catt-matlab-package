% init paths
folderPath = fullfile(pwd, 'assets');

% init configs
configs = {};
configs{end+1} = struct('suffix', 'receiver', 'pattern', '_rec.loc', 'output', 'tmp_rec.loc');
configs{end+1} = struct('suffix', 'source', 'pattern', '_src.loc', 'output', 'tmp_src.loc');
configs{end+1} = struct('suffix', 'geo', 'pattern', '.geo', 'output', 'tmp.geo');
configs{end+1} = struct('suffix', 'md9', 'pattern', '.md9', 'output', 'tmp.md9');

% loop over configs
for iConfig = 1:length(configs)

    % init locals
    config = configs{iConfig};
    
    % get list of files
    fileList = dir( fullfile(folderPath, ['*' config.pattern]) );

    % loop over files
    for iFile = 1:length(fileList)
        
        % init locals
        file = fileList(iFile);
        
        % discard if file is output file 
        if( strcmp(file.name, config.output) ); continue; end
        
        % read file
        filePath = fullfile(file.folder, file.name);
        obj = catt.(['read_' config.suffix])(filePath);
        fprintf('read %s\n', filePath);

        % discard empty struct (fail to load)
        if( isempty(fieldnames(obj)) ); continue; end

        % write file
        filePath = fullfile(folderPath, config.output);
        catt.(['write_' config.suffix])(filePath, obj);
        fprintf('write %s\n', filePath);
        
        % format log
        fprintf('\n');
    end
end