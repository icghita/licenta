function plotRegressions(pdbCifFolder, annFilepath, selectedANNIndex)

    numInputs = 100;
    crossover = 30;
    residueIndexes = 6;
    coordinateIndexes = [11 12 13];
    keys = {'Levenberg-Marquardt','BFGS Quasi-Newton','Resilient Backpropagation','Scaled Conjugate Gradient','Conjugate Gradient with Powell/Beale Restarts','Fletcher-Powell Conjugate Gradient','Polak-Ribiére Conjugate Gradient','One Step Secant','Variable Learning Rate Gradient Descent','Gradient Descent with Momentum','Gradient Descent','Bayesian Regularization'};
    values = {'trainlm','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd','trainbr'};
    trainingFunctionsMap = containers.Map(keys, values);  
    residueAdmisibleNames = {'ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL','ASX','GLX','XAA','END','GAP'};
    
    localPdbCifFiles = dir(strcat(pdbCifFolder, '\*.cif'));
    auxStruct = struct2cell(localPdbCifFiles);   
    pdbCifFiles = auxStruct(1,:);

    totalResidueData = [];
    totalCoordinateData = cell(length(coordinateIndexes), 1);
    for i=1:length(pdbCifFiles)   
        [atomData, hetatomData] = readData(strcat(pdbCifFolder, '\', pdbCifFiles{i}));
        dataSize = size(atomData);
        %verificare ca atomData contine aminoacizi si nu altceva
        membershipArray = ismember(upper(atomData(:, residueIndexes)), residueAdmisibleNames);
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
    end
    
    loadedANNStorage = load(annFilepath);
    annStruct = loadedANNStorage.ANNStorage(selectedANNIndex);
    annOutput = annStruct.ANN(totalResidueData);
    sizeOutput = size(annOutput);
    Xoutput = annOutput(1:3:300, :);
    Youtput = annOutput(2:3:300, :);
    Zoutput = annOutput(3:3:300, :);
    
    XtrOut = Xoutput(:, 1:sizeOutput(2)/100*70);
    XvOut = Xoutput(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    XtsOut = Xoutput(:, sizeOutput(2)/100*85+1:sizeOutput(2));
        
    XtrTarg = totalCoordinateData{1}(:, 1:sizeOutput(2)/100*70);
    XvTarg = totalCoordinateData{1}(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    XtsTarg = totalCoordinateData{1}(:, sizeOutput(2)/100*85+1:sizeOutput(2)); 
    
    YtrOut = Youtput(:, 1:sizeOutput(2)/100*70);
    YvOut = Youtput(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    YtsOut = Youtput(:, sizeOutput(2)/100*85+1:sizeOutput(2));
        
    YtrTarg = totalCoordinateData{2}(:, 1:sizeOutput(2)/100*70);
    YvTarg = totalCoordinateData{2}(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    YtsTarg = totalCoordinateData{2}(:, sizeOutput(2)/100*85+1:sizeOutput(2));   
       
    ZtrOut = Zoutput(:, 1:sizeOutput(2)/100*70);
    ZvOut = Zoutput(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    ZtsOut = Zoutput(:, sizeOutput(2)/100*85+1:sizeOutput(2));
        
    ZtrTarg = totalCoordinateData{3}(:, 1:sizeOutput(2)/100*70);
    ZvTarg = totalCoordinateData{3}(:, sizeOutput(2)/100*70+1:sizeOutput(2)/100*85);
    ZtsTarg = totalCoordinateData{3}(:, sizeOutput(2)/100*85+1:sizeOutput(2));  
    
    figure(1);
    plotregression(XtrTarg, XtrOut, 'Train', XvTarg, XvOut, 'Validation', XtsTarg, XtsOut, 'Testing');
    figure(2);
    plotregression(XtrTarg, YtrOut, 'Train', YvTarg, YvOut, 'Validation', YtsTarg, XtsOut, 'Testing');
    figure(3);
    plotregression(XtrTarg, ZtrOut, 'Train', ZvTarg, ZvOut, 'Validation', ZtsTarg, ZtsOut, 'Testing');
end