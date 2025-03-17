%% init

% get list of functions
fileList = dir( fullfile(pwd, '+catt', '*m') );

% % debug
% fileList = fileList(1);

% loop over files
for iFile = 1:length(fileList)
    
    % init locals
    file = fileList(iFile);
    [~, name] = fileparts(file.name);

    % check function help
    fprintf(2, '\n# %s\n\n', file.name);
    eval( sprintf('help catt.%s', name));   
    fprintf('--------- \n\n');

end
