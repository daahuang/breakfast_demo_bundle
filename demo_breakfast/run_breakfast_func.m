function [ res_all ] = run_breakfast_func( params )
%RUN_BREAKFAST_FUNC Summary of this function goes here
%   Detailed explanation goes here

use_split = params.split;
use_grammar = params.grammar;
myroot = params.root;
feature_str = params.fea_str;

%%
path_bundle = fullfile(myroot, 'demo_bundle');


% feature_str = 'hist_h3d_c30';

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
config = get_breakfast_demo_config(path_root, path_input, path_gen, path_out, use_split);

% things you might want to overwrite:

% folder with segmentation files (xml-style)
% config.features_segmentation = 'C:\tmp\segmentation';
config.features_segmentation = fullfile(myroot, 'segmentation');

%% files provided by user (HTK-style)
% dictionary file
config.dict_file = ['', path_root, '/breakfast.dict'];
% config.dict_file = 'breakfast_short.dict'

% grammar file
switch use_grammar
    case -1
        config.grammar_file = ['', path_root, '/breakfast.grammar.unif'];
    case 0
        config.grammar_file = ['', path_root, '/breakfast.grammar.length'];
    case 1
        config.grammar_file = ['', path_root, '/breakfast.grammar'];
    otherwise
        disp('other value')
end

% for the first split (in folder ... \s1)
% if you want to run overall splits please don't forget to adapt the
% train/test pattern
% compute pattern automatically
Vid_test{1} = 3:15;
Vid_test{2} = 16:28;
Vid_test{3} = 29:41;
Vid_test{4} = 42:54;
Vid_all = [];
for k = 1:length(Vid_test)
    Vid_all = union(Vid_all, Vid_test{k});
end
Vid_all = Vid_all';
v_test = Vid_test{use_split};
v_train = setdiff(Vid_all, v_test);
config.pattern_test = array2regexp(v_test);
config.pattern_train = array2regexp(v_train);  

%%
% traing and testing:
run_htk(config);

% evaluation of sequences
[accuracy_seq, confmat_seq, test_label_seq, predicted_label_seq]  = get_results_seq(config);

% evaluation of units
vis_on = 0;
[accuracy_seq, acc_unit_parsing, acc_unit_rec, acc_units_perFrames, res_all] = get_results_units(config, vis_on);

% clean up
% system(['del /Q "',pwd,'\label\*.*"']);
% system(['del /Q "',pwd,'\tmp\*.lab"']);

delete('./tmp/*.lab');
delete('./label/*.*');

end

