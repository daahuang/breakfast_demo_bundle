function [ S ] = array2regexp( V )
%ARRAY2REGEXP Summary of this function goes here
%   Detailed explanation goes here

%     '(P03_|P04_|P05_|P06_|P07_|P08_|P09_|P10_|P11_|P12_|P13_|P14_|P15_)'
    S = '(';
    for v = V
        S = strcat(S, sprintf('P%s_|', num2str(v, '%02i')));
    end
    S(end) = [];
    S = strcat(S, ')');

end

