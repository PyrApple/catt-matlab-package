%% init

% define paths to catt and tuct
paths = struct('catt', 'C:\Apps\CATT\CATT9.exe', 'tuct', 'C:\Apps\CATT\TUCT2.exe');

% define project config
config = struct();
config.folder = fullfile(fileparts(pwd), 'CattProject_Cube');
config.in = fullfile(config.folder, 'IN');
config.out = fullfile(config.folder, 'OUT');
config.md9 = fullfile(config.in, 'CATT.MD9');

% read input md9 file
md9 = catt.read_md9(config.md9);

% define project config
config.name = md9.project_name;
config.cagbase = fullfile(config.out, [config.name '_']);
config.count = [config.cagbase 'count.DAT'];


%% prepare run (remove old files)

% reset catt counter (delete count.dat file)
if( exist(config.count, 'file') ); delete(config.count); end

% delete files generated in previous runs
fileList = dir(fullfile(config.out, [config.name '*']));
selVect = ~cellfun('isempty', regexp({fileList.name}, [config.name '_\d+']) );
fileList = fileList(selVect);
filePaths = fullfile(config.out, {fileList.name});
if( ~isempty(filePaths) ); delete(filePaths{:}); end


%% (optional) modify md9 file, e.g. to change which sources / receivers to use

% change data (can only modify sources_used and receivers_used fields for now)
md9.sources_used = md9.sources_used * 0;
md9.sources_used(1, 4) = 1; % first is letter, second is id
%
md9.receivers_used = 0 * md9.receivers_used;
md9.receivers_used(4) = 1;

% write md9 file
catt.write_md9(config.md9, md9);


%% run catt

% run CATT-A to create a new CAG
ret = dos( [ '"' paths.catt '" "' config.md9 '"' ' /AUTO' ] );

% handle error
if ret ~= 0; error('script failed for CATT9'); end


%% run TUCT (with the new CAG)

% get the appended CAG-file counter (a single 32-bit integer)
fid = fopen(config.count,'r');
if( fid == -1 ); warning('close CATT acoustic before running this script'); end
count = fread(fid, 1, 'int32');
fclose(fid);

% define tuct run cmd line arguments
cagFile = [ '"' config.cagbase num2str(count) '.CAG' '"' ];
% saveStr = 'MEAS,BIN,BF';
saveStr = 'BF';

% run tuct
ret = dos( [ paths.tuct ' ' cagFile ' /AUTO /SAVE:' saveStr] );

% print error log
if ret ~= 0
    eval(['type ' config.cagbase num2str(count) '_autorun_error.TXT' ]);
    error('script failed for TUCT:'); 
end

