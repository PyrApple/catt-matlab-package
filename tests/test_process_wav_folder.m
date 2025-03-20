
% init
inputFolder = fullfile(pwd, 'assets', 'wav_export');
outputFolder = fullfile(pwd, 'assets', 'wav_export_tmp');

% batch process
catt.process_wav_folder(inputFolder, 'outputfolder', outputFolder, 'norm', true, 'resample', 48000, 'toambix', true);

