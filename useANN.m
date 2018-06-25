function useANN(ann, fastaData, outputFilepath, blockSize, crossover, residueIndex, codification)
%Converteste secvente fasta in vector de celule PDB si trimite acest vector
%in blocuri de dimensiunea ferestrei catre reteaua neurala si scrie
%rezultatul intr-un fisier .cif
    if ~exist('crossover', 'var')
        crossover = 0;
    end
    pdbIndexesOfColumns = [1, 8, 14, 16, 22, 24, 28, 30, 32, 36, 38, 46, 54, 62, 67, 73, 75, 80, 84, 86, 92];
    startOfChain = 1;
    indexInterval = blockSize - crossover;
    formatedData = formatFastaData(fastaData);
    chainNames = unique(formatedData(:,7));
    fileID = fopen(outputFilepath, 'w');
    % i este indicele lantului
    for i=1:length(chainNames)
        chainLength = length(formatedData(find(strcmp(formatedData(:,7), chainNames(i))),:));
        endOfChain = startOfChain + chainLength - 1;
        residues = NaN(blockSize, 1);
        % j este indicele blocului din lantul i: startOfChain -> endOfChain
        for j=1:floor(chainLength/(indexInterval))
            % k este indicele fiecarui atom din blocul j
            for k=1:min(blockSize, chainLength - (j-1)*blockSize)
                residues(k) = aa2intCustom(aminolookup(formatedData{(j-1)*indexInterval+k, residueIndex}));
            end
            coordinates = ann(residues);
            for k=1:min(blockSize, chainLength - (j-1)*blockSize)
                textLine = char(ones(1,92) * ' ');
                curentLineInFile = startOfChain + (j-1)*blockSize + k - 1;
                formatedData{curentLineInFile, 11} = num2str(round(coordinates(3*(k-1) + 1), 3));
                formatedData{curentLineInFile, 12} = num2str(round(coordinates(3*(k-1) + 2), 3));
                formatedData{curentLineInFile, 13} = num2str(round(coordinates(3*(k-1) + 3), 3));
                for m=1:length(pdbIndexesOfColumns)
                    textLine(pdbIndexesOfColumns(m):pdbIndexesOfColumns(m) + length(formatedData{curentLineInFile, m}) - 1) = formatedData{curentLineInFile, m};                    
                end
                fprintf(fileID, '%s\n', textLine);
            end
        end
        startOfChain = endOfChain + 1;
    end
    fclose(fileID);
end

