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

% modify which receveirs and sources are active in md9
md9.receivers_used = 0*md9.receivers_used; % reset
md9 = catt.md9_enable_receivers(md9, [0 1 3 4]);
md9.sources_used = 0*md9.sources_used; % reset
% md9 = catt.md9_enable_sources(md9, [0 11 22 33]);
md9 = catt.md9_enable_sources(md9, {'A0', 'A5', 'A2', 'B1', 'C2'});

% write to file
filePath = fullfile(config.folder, 'tmp.md9');
catt.write_md9(filePath, md9);

% read geo file (need currated geo file)
geo = catt.read_geo(config.geo);

% write geo file
filePath = fullfile(config.folder, 'tmp.geo');
catt.write_geo(filePath, geo);

% read receiver file
receivers = catt.read_receiver(config.rec);

% write receiver file
filePath = fullfile(config.folder, 'tmp_rec.loc');
catt.write_receiver(filePath, receivers);

% read source file
sources = catt.read_source(config.src);

% write source file
filePath = fullfile(config.folder, 'tmp_src.loc');
catt.write_source(filePath, sources);

% plot scene (all arguments are optional)
catt.plot_scene('geo', geo, 'sources', sources, 'receivers', receivers, 'md9', md9);

% compute areas/faces statistiques
[smat, tot] = catt.calc_surface(geo);

% convert estimates to explicit scattering coefficients
geo = catt.convert_estimate_scattering(geo);


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
outputFolderPath = fullfile(config.folder, 'wav_export_tmp');
catt.process_wav_folder(inputFolderPath, 'outputfolder', outputFolderPath, 'norm', true, 'resample', 48000, 'toambix', true);


%% log results to console

% materials
fprintf('\n# Materials \n\n');
for iMat = 1:length(geo.materials)
    
    m = geo.materials(iMat);

    fprintf('%s \n', m.name);

    fprintf('  absorption: ');
    fprintf('%.1f ', m.absorption);
    fprintf('\n');

    fprintf('  scattering: ');
    fprintf('%.1f ', m.scattering);
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

