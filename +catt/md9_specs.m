function [specs] = md9_specs() 

% md9_specs return a definition of the segments of interest in an md9 binary
% file, along with the read format to use for each segment.
%
% specs = md9_specs()
%
% specs is a structure which fields are structure. each substructure defines
% a chunk of data in the md9 file: data type, read start and read length.


% init
specs = struct();

specs.project_name = struct('start', 8, 'length', 70, 'format', 'uint8=>char');
specs.input_folder_path = struct('start', 269, 'length', 261, 'format', 'uint8=>char');
specs.output_folder_path = struct('start', 530, 'length', 261, 'format', 'uint8=>char');

specs.master_file_name = struct('start', 791, 'length', 256, 'format', 'uint8=>char');
specs.receiver_file_name = struct('start', 1047, 'length', 256, 'format', 'uint8=>char');
specs.source_file_name = struct('start', 1303, 'length', 256, 'format', 'uint8=>char');

nCol = 10; nRow = 26;
specs.sources_used = struct('start', 1575, 'length', [nCol, nRow], 'format', 'ubit1');
specs.receivers_used = struct('start', 1559, 'length', 100, 'format', 'ubit1');

end


%% notes

% todo
% - check real length of all char fields (but for project_name, already checked)


% for future updates, added code from python toolbox below (for read
% position of various fields in MD9 file)

% self._prop_diffReflMode = BinEncProp_num(self, 0x00000B34, 0x00000B36, format = '?')	
% self._prop_diffReflUseDefault = BinEncProp_scalar(self, 0x00000B36, format = '?')	
% self._prop_diffReflDefaultValues = BinEncProp_freqValues(self, 0x00000B37, format = 'f')
% 
% self._prop_headDirectionMode = BinEncProp_scalar(self, 0x00000B57, format = 'b')
% self._prop_headDirection = BinEncProp_3Dvec(self, 0x00000B58, format = 'f')
% 
% self._prop_airTemperature = BinEncProp_scalar(self, 0x0000B85, format = 'f', min = -20.0, max = 50)
% self._prop_airHumidity = BinEncProp_scalar(self, 0x0000B89, format = 'f', min = 0.0, max = 100.0)
% self._prop_airDensity = BinEncProp_scalar(self, 0x0000B8D, format = 'f', min = 1.0, max = 2.0)
% 
% self._prop_airAbsorptionMode = BinEncProp_scalar(self, 0x00000B64, format = 'b')
% self._prop_airAbsorptionUserValues = BinEncProp_freqValues(self, 0x00000B65, format = 'f')
% 
% self._prop_backgroundNoiseLevelTotal = BinEncProp_freqValues(self, 0x00000B91, format = 'f')
% self._prop_backgroundNoiseLevelResidual = BinEncProp_freqValues(self, 0x00000BB1, format = 'f')
% 
% self._prop_sourcesUsed = BinEncProp_bitsMatrix(self, 0x00000627, ncols = 10)
% self._prop_receiversUsed = BinEncProp_bitsArray(self, 0x00000617, 100)
% 
% self._prop_planeSelectionMode = BinEncProp_scalar(self, 0x00000B33, format = 'b')
% self._prop_planeSelection = BinEncProp_planeSelection(self, 0x00001108, 0x00000064B, 0x0000008BF)
