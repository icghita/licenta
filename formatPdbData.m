function [residues, formatedCoordinates] = formatPdbData(data, blockSize, residueIndex, coordinatesIndexes, crossover)
%extract from the PDB data in cell array form the residues in an array and the
%coordinates in a cell array with its cells corresponding to the different
%types of coordinates stored (x,y,z, opt - temperature)
%blockSize is the number of inputs the neural network will use
%indexInterval is the interval in the data at which a sample of inputs is
%taken; for example if indexInterval is 3, blockSize is 5 and data length
%is 10 then we will have 4 blocks of data of length 5 at indexes 1,4,7,10
%where there are not enough values left in the data array, the inputs are
%filled with NaN
    indexInterval = blockSize - crossover;
    residues = NaN(blockSize, floor(length(data)/indexInterval));
    formatedCoordinates = cell(length(coordinatesIndexes), 1);
    for j=1:length(coordinatesIndexes)
        formatedCoordinates{j} = NaN(blockSize, floor(length(data)/indexInterval));
    end
    for i=1:floor(length(data)/indexInterval)
        for j=1:length(coordinatesIndexes)
            dataBlock = data((i-1)*indexInterval+1 : min((i-1)*indexInterval+blockSize, length(data)), coordinatesIndexes(j));
            formatedCoordinates{j}(1:length(dataBlock),i) = cellfun(@(c) str2double(c), dataBlock);
        end
        %aminolookup doesn't work on arrays so it is applied on each
        %row at column i of the residues matrix
        for k=1:min(blockSize, length(data)-(i-1)*indexInterval)
            residues(k,i) = aa2intCustom(aminolookup(data{(i-1)*indexInterval+k, residueIndex}));
        end
    end
end

