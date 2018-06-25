function annStorage = generateNeuralNetwork(networkName, networkType, codification, pdbCifFolder, pdbCifFiles, numInputs, noOfHiddenNeurons, trainingFunction, dataLimitsArgs, aditionalResourcesArgs, crossover, residueIndexes, coordinateIndexes)
    %returneaza o structura care contine reteaua neurala si alte date
    keys = {'Levenberg-Marquardt','BFGS Quasi-Newton','Resilient Backpropagation','Scaled Conjugate Gradient','Conjugate Gradient with Powell/Beale Restarts','Fletcher-Powell Conjugate Gradient','Polak-Ribiére Conjugate Gradient','One Step Secant','Variable Learning Rate Gradient Descent','Gradient Descent with Momentum','Gradient Descent','Bayesian Regularization'};
    values = {'trainlm','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd','trainbr'};
    trainingFunctionsMap = containers.Map(keys, values);  
    residueAdmisibleNames = {'ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL','ASX','GLX','XAA','END','GAP'};
    if(strcmp(networkType, 'Feedforward Neural Network'))
        reccurent = 0;
    end
    if(strcmp(networkType, 'Reccurent Neural Network'))
        reccurent = 1;
    end
    ann = createMultiOutputAnn(3, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction), reccurent);
    ann.divideParam.trainRatio = dataLimitsArgs(1)/100;
    ann.divideParam.valRatio = dataLimitsArgs(2)/100 - dataLimitsArgs(1)/100;
    ann.divideParam.testRatio = 1 - dataLimitsArgs(2)/100;
    annStorage = struct('ANN', {}, 'TR', {}, 'Codification', [], 'NetworkName', [], 'NetworkType', [], 'Crossover', [], 'TrainingFunction', [], 'PlotData', []);
    if(aditionalResourcesArgs(1))
        useParallel = 'yes';
        poolObj = parpool;
    else
        useParallel = 'no';
    end
    if(aditionalResourcesArgs(2))
        useGpu = 'yes';
        ann.inputs{1}.processFcns = {'mapminmax'};
    else
        useGpu = 'no';
    end
    totalResidueData = [];
    totalCoordinateData = cell(length(coordinateIndexes), 1);
    for i=1:length(pdbCifFiles)   
        [atomData, hetatomData] = readData(strcat(pdbCifFolder, '\', pdbCifFiles{i}));
        dataSize = size(atomData);
        %verificare ca atomData contine aminoacizi si nu altceva
        membershipArray = ismember(upper(atomData(:,residueIndexes)), residueAdmisibleNames);
        if(any(membershipArray == 0) || dataSize(1) > 4000)
            continue;
        end
        chainNames = unique(atomData(:,7));
        startOfChain = 1;
        %impartire in lanturi
        for j=1:length(chainNames)    
            endOfChain = min(startOfChain + length(atomData(find(strcmp(atomData(:,7), chainNames(j))),:)) - 1, dataSize(1));
            [residueData, coordinateData] = formatPdbData(atomData(startOfChain:endOfChain,:), numInputs, residueIndexes, coordinateIndexes, crossover);
            totalResidueData = [totalResidueData residueData];
            for k=1:length(coordinateIndexes)
                totalCoordinateData{k} = [totalCoordinateData{k} coordinateData{k}];
            end
            startOfChain = endOfChain + 1;           
        end
        totalDataSize = size(totalResidueData);
        if(reccurent == 0 && totalDataSize(2) >= 10)
            [ann tr] = train(ann, totalResidueData, totalCoordinateData, 'useParallel', useParallel, 'useGPU', useGpu);
            totalResidueData = [];
            totalCoordinateData = cell(length(coordinateIndexes), 1);
        end
        if(reccurent == 1)           
            seqTotalResidueData = con2seq(totalResidueData);
            seqtotalCoordinateData = con2seq(totalCoordinateData);
            totalResidueData = [];
            totalCoordinateData = cell(length(coordinateIndexes), 1);
            for j=1:length(seqTotalResidueData)
                [ann tr] = train(ann, seqTotalResidueData(j), seqtotalCoordinateData(:,j), 'useParallel', useParallel, 'useGPU', useGpu);
                ann.inputConnect(1, 1) = 1;
            end
        end
    end
    tempAnnStorage = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'NetworkName', networkName, 'NetworkType', networkType, 'Crossover', crossover, 'TrainingFunction', trainingFunction, 'PlotData', []);
    annStorage = [annStorage; tempAnnStorage];
    if(aditionalResourcesArgs(1))
        delete(poolObj);
    end
end
