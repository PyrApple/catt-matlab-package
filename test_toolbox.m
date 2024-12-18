%% init

% define project config
config = struct();
config.folder = fullfile(pwd, 'CattProject_Cube');
config.in = fullfile(config.folder, 'IN');
config.out = fullfile(config.folder, 'OUT');
config.md9 = fullfile(config.in, 'CATT.MD9');
config.geo = fullfile(config.in, 'MASTER.GEO');
config.rec = fullfile(config.in, 'REC.LOC');
config.src = fullfile(config.in, 'SRC.LOC');


%% misc read input files

% read input md9 file
md9 = catt.read_md9(config.md9);

% % write to file
% catt.write_md9(config.md9, md9);

% read material
materials = catt.read_material(config.geo);

% read materials from .geo file (need currated geo file)
materials = catt.read_material(config.md9);

% read receiver file
receivers = catt.read_receiver(config.rec);

% read source file
sources = catt.read_source(config.src);

% read geo file
geo = catt.read_geo(config.geo);

% write geo file
filePath = fullfile(config.in, 'MASTER_MATLAB.GEO');
catt.write_geo(filePath, geo);

% plot scene (all arguments are optional)
catt.plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9);


%% misc read output files

% read ims
filePath = fullfile(config.out, 'Cube_1_ISM_export.txt');
images = catt.read_imagesource(filePath);

% read estimated parameters
filePath = fullfile(config.out, 'Cube_CATT_Interactive_RT60.TXT');
parameters = catt.read_acoustic_parameter(filePath);

% read .rir mat file
filePath = fullfile(config.out, 'Cube_1_A3_03_BF.MAT');
[ir, fs] = catt.read_ir_mat(filePath);






