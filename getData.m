function [input, target] = getData(dateIn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    fid = fopen(dateIn);
    data = textscan(fid,'%s%d%s%s%s%d%f%f%f%f%f%s');
    fclose(fid);
    auxarray = data{4};
    input = ones(1,length(auxarray));
    for i=1:length(auxarray)    
            aux = aminolookup('Abbreviation', auxarray{i});
            input(i) = aa2int(aux(1));
    end
    target = [data{7} data{8} data{9} data{11}]';
end

