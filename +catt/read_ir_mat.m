function [ir, fs] = read_ir_mat(filePath)

% read_ir_mat load an impulse response exported from CATT as a .mat file.
%
% [ir, fs] = read_ir_mat(filePath)
% 
% filePath is a string.
% ir is a matrix containing audio data, in the same order as that exported
% by catt in .wav files (for omni, binaural, and ambisonic formats).
% fs is a sampling frequency.

% load file
s = load(filePath);

% extract fs
fs = s.TUCT_fs;
s = rmfield(s, 'TUCT_fs');

% extract audio from struct fields to matrix
channelNames = fieldnames(s);

% define channel ordering for omni, binaural, and ambi (fuma) export
switch length(channelNames)
    
    case 1
        
        pattern = {'_OMNI'};
    
    case 2
       
        pattern = {'_BIN_L', '_BIN_R'};
    
    otherwise

        % same channel ordering as that of wav file exported from CATT
        pattern = {'BF_W','BF_X','BF_Y','BF_Z','BF_R','BF_S','BF_T','BF_U','BF_V','BF_K','BF_L','BF_M','BF_N','BF_O','BF_P','BF_Q'};

end

% extract ids from struct fields names based on patterns
ids = cellfun( @(x) find( contains(channelNames, x) ), pattern, 'uniformoutput', false);
selVect = cellfun(@(x) ~isempty(x), ids);
ids = cell2mat( ids(selVect) );

% extract channels from struct to mat
ir = [];
for iCh = 1:length(ids)
    ir = [ir; s.(channelNames{ ids(iCh) })];
end
ir = ir.';
