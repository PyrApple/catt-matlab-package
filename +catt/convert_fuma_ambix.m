function bufferOut = convert_fuma_ambix(bufferIn)

% convert_fuma_ambix converts fuma (catt output) to ambix format
%
% bufferOut = convert_fuma_ambix(bufferIn)
%
% bufferIn and bufferOut are audio signal matrices.

% discard if hoa lib not in path
if( exist('convert_N3D_FuMa') ~= 2 )
    warning('need to install HOA library for ambisonic convert: see https://github.com/polarch/Higher-Order-Ambisonics');
    bufferOut = bufferIn;
    return;
end

% channel ordering
bufferOut = convert_N3D_FuMa(bufferIn, 'fuma2n');

% normalisation
bufferOut = convert_N3D_SN3D(bufferOut, 'n2sn');

end