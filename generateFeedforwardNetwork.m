function bestAnnStruct = generateFeedforwardNetwork(networkName, networkType, codification, pdbCifFolder, pdbCifFiles, numInputs, noOfHiddenNeurons, trainingFunction, dataLimitsArgs, aditionalResourcesArgs, classArgs, crossover, residueIndexes, coordinateIndexes)
    %returns a struct containing the resulting neural network, training
    %data, the input parameters and the output data necessary to draw plots
    keys = {'Levenberg-Marquardt','BFGS Quasi-Newton','Resilient Backpropagation','Scaled Conjugate Gradient','Conjugate Gradient with Powell/Beale Restarts','Fletcher-Powell Conjugate Gradient','Polak-Ribiére Conjugate Gradient','One Step Secant','Variable Learning Rate Gradient Descent','Gradient Descent with Momentum','Gradient Descent','Bayesian Regularization'};
    values = {'trainlm','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd','trainbr'};
    trainingFunctionsMap = containers.Map(keys, values);  
    
%     [commonFastaData, commonAntibodyData] = getCommonElements(fastaData, pdbCifFiles, antibody);
%     commonCodifiedFastaData = codifyFasta(commonFastaData, codification);
%     if(classArgs(1))
%         antibodySetLimits = [0 0];
%         commonAntibodyData = convertToClasses(commonAntibodyData, classArgs(2), classArgs(3));            
%     else
%         antibodySetLimits = [min(commonAntibodyData) max(commonAntibodyData)];
%         commonAntibodyData = (commonAntibodyData - min(commonAntibodyData)) / (max(commonAntibodyData) - min(commonAntibodyData));
%     end
%     if(strcmp(codification, 'A (Numerical)'))
%         ann = fitnet(noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
%     else
%         if(strcmp(codification, 'A-9 (Properties codification)'))
%             ann = createMultiInputAnn(9, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
%         else
%             ann = createMultiInputAnn(6, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
%         end
%     end
    
    ann = createMultiOutputAnn(3, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
    ann.divideParam.trainRatio = dataLimitsArgs(1)/100;
    ann.divideParam.valRatio = dataLimitsArgs(2)/100 - dataLimitsArgs(1)/100;
    ann.divideParam.testRatio = 1 - dataLimitsArgs(2)/100;
    annStorage = struct('ANN', {}, 'TR', {}, 'Codification', [], 'NetworkName', [], 'NetworkType', [], 'Crossover', [], 'TrainingFunction', [], 'PlotData', []);
    bestPerf = Inf;
    bestPerfIndex = 1;
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
    %train the neural network multiple times and select the one with
    %the best performance (the minimum)
%     coordinateData = cell(length(coordinateIndexes), 1);
%     residueData = [];
    totalResidueData = [];
    totalCoordinateData = cell(length(coordinateIndexes), 1);
    for i=1:length(pdbCifFiles)   
        [atomData, hetatomData] = readData(strcat(pdbCifFolder, '\', pdbCifFiles{i}));             
        chainNames = unique(atomData(:,7));
        startOfChain = 1;
        for j=1:length(chainNames)            
            endOfChain = startOfChain + length(atomData(find(strcmp(atomData(:,7), chainNames(j))),:)) - 1;
            [residueData, coordinateData] = formatPdbData(atomData(startOfChain:endOfChain,:), numInputs, residueIndexes, coordinateIndexes, crossover);
%             residueData = [residueData chainResidueData];
%             for l=1:length(coordinateIndexes)
%                 coordinateData{l} = [coordinateData{l} chainCoordinateData{l}];
%             end
            totalResidueData = [totalResidueData residueData];
            for k=1:length(coordinateIndexes)
                totalCoordinateData{k} = [totalCoordinateData{k} coordinateData{k}];
            end
            startOfChain = endOfChain + 1;           
        end
    end
    [ann tr] = train(ann, totalResidueData, totalCoordinateData, 'useParallel', useParallel, 'useGPU', useGpu);
    tempAnnStorage = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'NetworkName', networkName, 'NetworkType', networkType, 'Crossover', crossover, 'TrainingFunction', trainingFunction, 'PlotData', []);
    annStorage = [annStorage; tempAnnStorage];
%     if(min(tr.perf) < bestPerf)
%         bestPerf = min(tr.perf);
%         bestPerfIndex = i;
%     end
    if(aditionalResourcesArgs(1))
        delete(poolObj);
    end
    bestAnnStruct = annStorage(bestPerfIndex);
    annOutput = bestAnnStruct.ANN(totalResidueData);
    if(strcmp(codification, 'A-6 (Properties codification)') || strcmp(codification, 'A-9 (Properties codification)') || strcmp(codification, 'B (Raw Properties)'))
        annOutput = annOutput{1};      
    end
    %create and save the struct containing the data for the reggression plot
    trOut = annOutput(:,bestAnnStruct.TR.trainInd);
    vOut = annOutput(:,bestAnnStruct.TR.valInd);
    tsOut = annOutput(:,bestAnnStruct.TR.testInd);
    trTarg = cell(length(coordinateIndexes), 1);
    vTarg = cell(length(coordinateIndexes), 1);
    tsTarg = cell(length(coordinateIndexes), 1);
    for k=1:length(coordinateIndexes)
        trTarg{k} = totalCoordinateData{k}(:,bestAnnStruct.TR.trainInd);
        vTarg{k} = totalCoordinateData{k}(:,bestAnnStruct.TR.valInd);
        tsTarg{k} = totalCoordinateData{k}(:,bestAnnStruct.TR.testInd);
    end
    plotData = struct('RegressionPlot', {{trTarg trOut; vTarg vOut; tsTarg tsOut}});
    bestAnnStruct.PlotData = plotData;

    figure(1);
    plotregression(trTarg, trOut, 'Train', vTarg, vOut, 'Validation', tsTarg, tsOut, 'Testing');
%    figure(2);
%    plotPLSRegress(totalResidueData, totalCoordinateData);
end
