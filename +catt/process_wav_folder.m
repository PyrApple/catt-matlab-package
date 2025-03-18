function [] = process_wav_folder(inputFolder, varargin)

% process_wav_folder process all the .wav in a folder (norm, to ambix,
% etc.), saving the resulting .wav files to a separate output folder
%
% [] = process_wav_folder(inputFolder, 'outputfolder', outputFolder, 'norm', true, 'resample', 48000, 'toambix', true);
%
% inputfolder is a char
% outputfolder is a char (optional, default is <inputfolder>_out)
% norm is a boolean (optional, same norm value applied to all files)
% resample is a frequency 
% toambix is a bool, requiring to convert to ambix format (from catt's fuma)

% init parser
p = inputParser;
addParameter(p, 'outputfolder', '', @ischar);
addParameter(p, 'norm', false, @islogical);
addParameter(p, 'toambix', false, @islogical);
addParameter(p, 'resample', 0, @isnumeric);

% parse inputs
parse(p, varargin{:});
outputFolder = p.Results.outputfolder;
applyNorm = p.Results.norm;
toAmbix = p.Results.toambix;
fsTarget = p.Results.resample;

% default output folder
if( strcmp(outputFolder, '') )
    outputFolder = [inputFolder '_out'];
end

% deal with existing output folder
if( isfolder( outputFolder) )
    
    % prompt user
    overwrite = input('output folder exists, risk overwrite if names match? Y/N [N]:','s');

    % discard
    if( ~strcmp(overwrite, 'Y') )
        fprintf('processing aborted \n');
        return
    end

end

% create output folder if need be
if( ~isfolder( outputFolder) ); mkdir(outputFolder); end

% get list of files
fileList = dir(fullfile(inputFolder, '*.wav')); 

% init norm
peakValue = 1;
if( applyNorm ); peakValue = getPeakValue(fileList); end

% loop over files
for iFile = 1:length(fileList)
    
    % init locals
    file = fileList(iFile);

    % load 
    filePath = fullfile(file.folder, file.name);
    [buffer, fs] = audioread(filePath);

    % resample
    if( fsTarget ~= 0 && fs ~= fsTarget)
        buffer = resample(buffer, fsTarget, fs);
        fs = fsTarget;
    end

    % fuma to ambix
    fileName = file.name;
    if( toAmbix )
        buffer = catt.convert_fuma_ambix(buffer);
        fileName = strrep(fileName, '_BF.', '_Ambix.');
    end
    
    % apply norm
    buffer = 0.99 * buffer / peakValue;

    % save
    filePath = fullfile(outputFolder, fileName);
    audiowrite(filePath, buffer, fs);

end

end


%% local functions

function peakValue = getPeakValue(fileList)

% init locals
peakValue = -Inf;

% loop over files
for iFile = 1:length(fileList)
    
    % init locals
    file = fileList(iFile);

    % load 
    filePath = fullfile(file.folder, file.name);
    [buffer, ~] = audioread(filePath);
    
    % update peak value
    tmp = max(max( abs( buffer )));
    peakValue = max(peakValue, tmp);

end

end
