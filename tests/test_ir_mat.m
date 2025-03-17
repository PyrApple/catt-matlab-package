
% load mat
filePath = fullfile(pwd, 'assets', 'cube_ambi2nd.mat');
[ir1, fs1] = catt.read_ir_mat(filePath);

% load wav
filePath = fullfile(pwd, 'assets', 'cube_ambi2nd.wav');
[ir2, fs2] = audioread(filePath);

% plot references
subplot(3,1,1); plot(ir1); ylabel('mat');
subplot(3,1,2); plot(ir2); ylabel('wav')

% get diff (after norm) 
ir1 = ir1 / max(max(abs(ir1)));
ir2 = ir2 / max(max(abs(ir2)));
ir = ir1 - ir2;

% plot diff
subplot(3,1,3); plot(ir); ylabel('diff');

