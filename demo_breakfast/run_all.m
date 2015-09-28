clear;
split_all = 1:4;
% grammar = -1;
grammar_all = [1 -1];
root = '/home/deanh/Documents/MATLAB/Breakfast_dataset';
fea_str_all = {'hist_dt_l2pn_c64'};

result_all = cell(length(split_all), length(grammar_all));

params.root = root;
params.fea_str = fea_str_all{1};
for i = 1:length(split_all)
    params.split = split_all(i);
    for j = 1:length(grammar_all)
        params.grammar = grammar_all(j);
        [ result ] = run_breakfast_func( params );
        result_all{i}{j} = result;
    end
end

save result_all result_all split_all grammar_all fea_str_all

