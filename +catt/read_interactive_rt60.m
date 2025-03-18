function s = read_interactive_rt60(filePath)

% read_interactive_rt60 read data from interactive rt60 estimation .txt file
% exported from catt.
%
% params = read_interactive_rt60(filePath)
%
% filePath is a string.
% params is a structure containing info imported from file.

% read file
fid = fopen(filePath, 'r');
data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);
lines = data{1};

% init locals
s = struct();

% read frequencies
idx = find(contains(lines, 'The estimated RTs become:'), 1, 'first');
tmp = lines{idx+2};
tmp = strrep(tmp, 'k', '000');
tmp = str2double( strsplit(tmp) );
tmp = tmp(~isnan(tmp));
s.freqs = tmp;

% init read parameters
params = {};
params{end+1} = struct('name', 'rt60_eyring', 'header', 'Eyring :');
params{end+1} = struct('name', 'rt60_sabine', 'header', 'Sabine :');
params{end+1} = struct('name', 't30', 'header', 'T-30   :');

% loop over headers
for iParam = 1:length(params)

    % init locals
    param = params{iParam};
    
    % find line
    idx = find(contains(lines, param.header), 1, 'first');
    if( isempty(idx) )
        warning('could not find expected %s parameter (%s)', param.header, filePath);
        continue
    end
    
    % extract line
    tmp = lines{idx};
    
    % shape line
    tmp = strrep(tmp, param.header, '');
    tmp = strip(tmp);
    tmp = strrep(tmp, ',', '.');
    tmp = strsplit(tmp);
    
    % convert to double
    tmp = str2double(tmp);
    s.(param.name) = tmp(1:length(s.freqs));

end

end
