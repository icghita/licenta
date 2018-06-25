function net = createMultiOutputAnn(numOutputs, numHiddenNeurons, trainingFunction, reccurent)
    %creates a feedforward neural network with numInputs layers (each layer
    %coresponds to an input) and each layer has numHiddenNeurons neurons
    if(reccurent == 0)
        net = network;
        net.numInputs = 1;
        net.inputs{1}.size = 1;       
        net.inputs{1}.processFcns = {'mapminmax'};
        net.numLayers = numOutputs + 1;
        net.layers{1}.size = numHiddenNeurons;
        net.layers{1}.transferFcn = 'tansig';
        net.inputConnect(1, 1) = 1;
        net.biasConnect(1) = 1;
        net.initFcn = 'initlay';
        net.performFcn = 'mse';        
        net.divideFcn = 'divideblock';
        net.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotregression','plotfit'};
    else
        net = layrecnet(1,numHiddenNeurons);
        net.numLayers = numOutputs + 1;
    end   
    net.trainFcn = trainingFunction;
    for i=2:numOutputs+1
        net.biasConnect(i) = 1;        
        net.layerConnect(i, 1) = 1;
        net.outputConnect(i) = 1;
        net.layers{i}.size = 1;
        net.layers{i}.transferFcn = 'purelin';
        net.layers{i}.initFcn = 'initnw';
        net.layerWeights{i,i}.learnFcn = 'learngdm';
        net.outputs{i}.processFcns = {'mapminmax'};
    end
end

