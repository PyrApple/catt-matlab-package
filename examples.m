%% init

% define project config
config = struct();
config.folder = fullfile(pwd, 'tests', 'assets');
config.md9 = fullfile(config.folder, 'cube.md9');
config.geo = fullfile(config.folder, 'cube.geo');
config.rec = fullfile(config.folder, 'cube_rec.loc');
config.src = fullfile(config.folder, 'cube_src.loc');


%% misc read files used as input for catt

% read input md9 file
md9 = catt.read_md9(config.md9);

% write to file
filePath = fullfile(config.folder, 'cube_matlab.md9');
catt.write_md9(filePath, md9);

% read geo file (need currated geo file)
geo = catt.read_geo(config.geo);

% read only materials from .geo file
materials = catt.read_material(config.geo);

% read receiver file
receivers = catt.read_receiver(config.rec);

% read source file
sources = catt.read_source(config.src);

% write geo file
filePath = fullfile(config.folder, 'cube_matlab.geo');
catt.write_geo(filePath, geo);

% plot scene (all arguments are optional)
catt.plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9);


%% misc read files exported from catt (after simulation)

% read ims
filePath = fullfile(config.folder, 'cube_ism.txt');
images = catt.read_imagesource(filePath);

% read estimated parameters (interactive estimation)
filePath = fullfile(config.folder, 'cube_rt60.txt');
params1 = catt.read_interactive_rt60(filePath);

% read estimated parameters (full estimation post-simulation)
filePath = fullfile(config.folder, 'cube_meas.txt');
params2 = catt.read_parameters(filePath);

% read .rir mat file
filePath = fullfile(config.folder, 'cube_ambi2nd.mat');
[ir, fs] = catt.read_ir_mat(filePath);

% convert fuma to ambix wav
filePath = fullfile(config.folder, 'cube_ambi2nd.wav');
[ir, fs] = audioread(filePath);
ir2 = catt.convert_fuma_ambix(ir);

% batch process (norm, convert, etc.) wav files 
inputFolderPath = fullfile(config.folder, 'wav_export');
outputFolderPath = fullfile(config.folder, 'wav_export_out');
catt.process_wav_folder(inputFolderPath, 'outputfolder', outputFolderPath, 'norm', true, 'resample', 48000, 'toambix', true);


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


