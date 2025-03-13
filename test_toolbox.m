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


%% misc read files used as input for catt

% read input md9 file
md9 = catt.read_md9(config.md9);

% % write to file
% catt.write_md9(config.md9, md9);

% read geo file (need currated geo file)
geo = catt.read_geo(config.geo);

% read only materials from .geo file
materials = catt.read_material(config.geo);

% read receiver file
receivers = catt.read_receiver(config.rec);

% read source file
sources = catt.read_source(config.src);

% write geo file
filePath = fullfile(config.in, 'MASTER_MATLAB.GEO');
catt.write_geo(filePath, geo);

% plot scene (all arguments are optional)
catt.plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9);


%% misc read files exported from catt (after simulation)

% read ims
filePath = fullfile(config.out, 'Cube_1_ISM_export.txt');
images = catt.read_imagesource(filePath);

% read estimated parameters (interactive estimation)
filePath = fullfile(config.out, 'Cube_CATT_Interactive_RT60.TXT');
params1 = catt.read_interactive_rt60(filePath);

% read estimated parameters (full estimation post-simulation)
filePath = fullfile(config.out, 'Cube_1_A3_03_meas.TXT');
params2 = catt.read_parameters(filePath);

% read .rir mat file
filePath = fullfile(config.out, 'Cube_1_A3_03_BF.MAT');
[ir, fs] = catt.read_ir_mat(filePath);


%% log results to console

% materials
fprintf('\n# Materials \n\n');
for iMat = 1:length(materials)
    
    m = materials(iMat);

    fprintf('%s \n', m.name);

    fprintf('  absorption: ');
    fprintf('%.1f ', m.abs);
    fprintf('\n');

    fprintf('  scattering: ');
    fprintf('%.1f ', m.scat);
    fprintf('\n');

    fprintf('  color: ');
    fprintf('%.1f ', m.color);
    fprintf('\n\n');

end
fprintf('\n')


%% plot parameters estimation

% init locals
% params = params1; names = {'rt60_eyring', 'rt60_sabine'};
params = params2; names = {'t15', 't20', 't30', 'rt60', 'rt60_eyring', 'rt60_sabine'};

% plot parameters
plot(0, 0, 'handlevisibility', 'off'); hold on
for iName = 1:length(names)
    plot(params.freqs, params.(names{iName}), 'o-', 'markerfacecolor', 'w', 'markersize', 8);
end

% format plot
hold off,
set(gca, 'xscale', 'log');
legend(strrep(names, '_', ' '), 'location', 'northeast');
xticks(params.freqs);
xlabel('freq (Hz)'); 
ylabel('time (s)');


