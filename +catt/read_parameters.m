function s = read_parameters( filePath )
        
% read data from full parameter estimation export

% init 
s = struct();

% read file
fid = fopen(filePath, 'r');
data = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);
lines = data{1}; 

% read frequencies
idx = find(contains(lines, '"Measure"'), 1, 'first');
tmp = lines{idx};
tmp = strrep(tmp, 'k', '000');
tmp = strrep(tmp, '"', '');
tmp = str2double( strsplit(tmp) );
tmp = tmp(~isnan(tmp));
s.freqs = tmp;

% init read parameters
params = {};
params{end+1} = struct('name', 'c7', 'header', '"C-7"	"(h)"');
params{end+1} = struct('name', 'd50', 'header', '"D-50"	"(h)"');
params{end+1} = struct('name', 'c50', 'header', '"C-50"	"(h)"');
params{end+1} = struct('name', 'u50', 'header', '"U-50"	"(h)"');
params{end+1} = struct('name', 'c80', 'header', '"C-80"	"(h)"');
params{end+1} = struct('name', 'rr160', 'header', '"RR160"	"(h)"');
params{end+1} = struct('name', 'ts', 'header', '"Ts"	"(h)"');
params{end+1} = struct('name', 'rt60', 'header', '"RT''"	"(h)"');
params{end+1} = struct('name', 'edt', 'header', '"EDT"	"(h)"');
params{end+1} = struct('name', 't15', 'header', '"T-15"	"(h)"');
params{end+1} = struct('name', 't20', 'header', '"T-20"	"(h)"');
params{end+1} = struct('name', 't30', 'header', '"T-30"	"(h)"');
params{end+1} = struct('name', 'rt60_sabine', 'header', '"T-Sabine"');
params{end+1} = struct('name', 'rt60_eyring', 'header', '"T-Eyring"');
params{end+1} = struct('name', 'rt60_ref', 'header', '"Ref RT"');
params{end+1} = struct('name', 'j_lf', 'header', '"J-LF"	"(h)"');
params{end+1} = struct('name', 'l_j', 'header', '"L-J"	"(h)"');
params{end+1} = struct('name', 'spl', 'header', '"SPL"	"(h)"');
params{end+1} = struct('name', 'g', 'header', '"G "	"(h)"');
params{end+1} = struct('name', 'g80', 'header', '"G-80"	"(h)"');
params{end+1} = struct('name', 'noise_off', 'header', '"noise off"	"(h)"');
params{end+1} = struct('name', 'iacc', 'header', '"IACC"	"(h)"');
params{end+1} = struct('name', 'abs_mean', 'header', '"Mean abs."');
params{end+1} = struct('name', 'scat_mean', 'header', '"Mean scat."');

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
