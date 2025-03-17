
% init
% filePath = fullfile(pwd, 'unit_tests', 'saintgermain.geo');
filePath = fullfile(pwd, 'unit_tests', 'saintgermain2.geo');
% filePath = fullfile(pwd, 'unit_tests', 'athenee.geo');
% filePath = fullfile(pwd, 'unit_tests', 'fogg2.geo');
% filePath = fullfile(pwd, 'unit_tests', 'snail.geo');

geo = catt.read_geo(filePath);
catt.plot_scene('geo', geo, 'facealpha', 0.7, 'showlegend', false);

% clear
% % filePath = fullfile(pwd, 'unit_tests', 'cube_ambi1st.mat');
% filePath = fullfile(pwd, 'unit_tests', 'cube_ambi2nd.mat');
% % filePath = fullfile(pwd, 'unit_tests', 'nd_omni.mat');
% % filePath = fullfile(pwd, 'unit_tests', 'cube_bin.mat');
% 
% [ir, fs] = catt.read_ir_mat(filePath);
% 
% 
% filePath = fullfile(pwd, 'unit_tests', 'cube_ambi2nd.wav');
% [ir2, fs] = audioread(filePath);
% 
% % debug plot
% ir = ir / max(max(abs(ir)));
% ir2 = ir2 / max(max(abs(ir2)));
% plot(ir);

