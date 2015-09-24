
myroot = '/home/deanh/Documents/MATLAB/Breakfast_dataset';
path_bundle = fullfile(myroot, 'demo_bundle');

feature_str = 'hist_dt_l2pn_c64';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Path and variables ....
% demo_bundle:
% addpath(genpath('E:\Work\breakfast_homepage\HTK\trunk'));
addpath(genpath(path_bundle));
% htk wrapper:
% addpath(genpath('E:\tmp\matlab_htk'));
addpath(genpath(fullfile(path_bundle, 'matlab_htk')));


%% Directories
% root folder with this script
path_root = fullfile(path_bundle, 'demo_breakfast');
% folder with the input data
% path_input = fullfile(myroot, 'hist_h3d_c30');
path_input = fullfile(myroot, feature_str);
cd(path_root);

% folder to write temprorary files and output:
% path_output = 'C:\tmp\htk_output\';
path_output = fullfile(path_bundle, 'htk_output');

if isempty(dir(path_output))
    mkdir(path_output);
end

% folder for hmms and temproary files:
path_gen = fullfile(path_output, 'generated', feature_str);
if isempty(dir(path_gen))
    mkdir(path_gen);
end

% folder for textual output and results:
path_out = fullfile(path_output, 'output', feature_str);
if isempty(dir(path_out))
    mkdir(path_out);
end

%% Now we need to change the directory
cd(path_gen);

%% Config file:

% get the default configuration:
config = get_breakfast_demo_config(path_root, path_input, path_gen, path_out);

% things you might want to overwrite:

% folder with segmentation files (xml-style)
% config.features_segmentation = 'C:\tmp\segmentation';
config.features_segmentation = fullfile(myroot, 'segmentation');

%% files provided by user (HTK-style)
% dictionary file
config.dict_file = ['', path_root, '/breakfast.dict'];
% config.dict_file = 'breakfast_short.dict'

% grammar file
config.grammar_file = ['', path_root, '/breakfast.grammar'];
% config.grammar_file = 'breakfast_short.grammar_full'

% traing and testing:
run_htk(config);

% evaluation of sequences
[accuracy_seq, confmat_seq, test_label_seq, predicted_label_seq]  = get_results_seq(config);

% evaluation of units
vis_on = 0;
[accuracy_seq, acc_unit_parsing, acc_unit_rec, acc_units_perFrames, res_all] = get_results_units(config, vis_on);

% clean up
system(['del /Q "',pwd,'\label\*.*"']);
system(['del /Q "',pwd,'\tmp\*.lab"']);

delete('./tmp/*.lab');
delete('./label/*.*');

