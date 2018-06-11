function ann = createMultiOutputAnn(numOutputs, numHiddenNeurons, trainingFunction)
    %creates a feedforward neural network with numInputs layers (each layer
    %coresponds to an input) and each layer has numHiddenNeurons neurons
    ann = network;
    ann.numInputs = 1;
    ann.inputs{1}.size = 1;
    ann.inputs{1}.processFcns = {'mapminmax'};
    ann.numLayers = numOutputs + 1;
    ann.layers{1}.size = numHiddenNeurons;
    ann.layers{1}.transferFcn = 'tansig';
    ann.inputConnect(1, 1) = 1;
    ann.biasConnect(1) = 1;
    for i=2:numOutputs+1
        ann.biasConnect(i) = 1;        
        ann.layerConnect(i, 1) = 1;
        ann.outputConnect(i) = 1;
        ann.layers{i}.size = 1;
        ann.layers{i}.transferFcn = 'tansig';
        ann.layers{i}.initFcn = 'initnw';
        ann.layerWeights{i,i}.learnFcn = 'learngdm';
        ann.outputs{i}.processFcns = {'mapminmax'};
    end
    ann.initFcn = 'initlay';
    ann.performFcn = 'mse';
    ann.trainFcn = trainingFunction;
    ann.divideFcn = 'divideblock';
    ann.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotregression','plotfit'};
end

