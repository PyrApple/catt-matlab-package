%% init

% init paths
folderPath = fullfile(pwd, 'assets');

% get list of geo files
fileList = dir(fullfile(folderPath, '*.geo'));

% loop over files 
for iFile = 1:length(fileList)
    
    % read file 
    file = fileList(iFile);
    filePath = fullfile(file.folder, file.name);
    geo = catt.read_geo(filePath);

    % estimate surface
    [smat, tot] = catt.calc_surface(geo);
    
    fprintf('%s area: %.0fm2 \n', file.name, tot);

end
