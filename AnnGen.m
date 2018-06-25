function varargout = AnnGen(varargin)
% AnnGen MATLAB code for AnnGen.fig
%      AnnGen, by itself, creates a new AnnGen or raises the existing
%      singleton*.
%
%      H = AnnGen returns the handle to a new AnnGen or the handle to
%      the existing singleton*.
%
%      AnnGen('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AnnGen.M with the given input arguments.
%
%      AnnGen('Property','Value',...) creates a new AnnGen or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the AnnGen before AnnGen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnnGen_OpeningFcn via varargin.
%
%      *See AnnGen Options on GUIDE's Tools menu.  Choose "AnnGen allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnnGen

% Last Modified by GUIDE v2.5 19-Jun-2018 11:13:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnnGen_OpeningFcn, ...
                   'gui_OutputFcn',  @AnnGen_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AnnGen is made visible.
function AnnGen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnnGen (see VARARGIN)

% Choose default command line output for AnnGen
handles.output = hObject;

setappdata(0,'hMainGUI', gcf);
setappdata(gcf,'mainHandles', handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnnGen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnnGen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function handles = pdbCifFolderPathText_Callback(hObject, eventdata, handles)
% hObject    handle to pdbCifFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pdbCifFolderPathText as text
%        str2double(get(hObject,'String')) returns contents of pdbCifFolderPathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localPdbCifFolder = get(hObject,'String');
try
    localPdbCifFiles = dir(strcat(localPdbCifFolder, '\*.cif'));
    auxStruct = struct2cell(localPdbCifFiles);
    set(handles.pdbCifListbox, 'string', auxStruct(1,:));
    handles = pdbCifListbox_Callback(handles.pdbCifListbox, eventdata, handles);
    handles.pdbCifFiles = auxStruct(1,:);
catch
    h = msgbox('Folder not found or it has no .cif files','Error');
end
handles.pdbCifFolder = localPdbCifFolder;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pdbCifFolderPathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdbCifFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pdbCifBrowsePushButton.
function pdbCifBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to pdbCifBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
localPdbCifPath = uigetdir('Select folder with .cif files');
set(handles.pdbCifFolderPathText, 'String', localPdbCifPath);
handles = pdbCifFolderPathText_Callback(handles.pdbCifFolderPathText, eventdata, handles);
handles.pdbCifFolder = localPdbCifPath;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pdbCifBrowsePushButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdbCifBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function pdbCifSearchText_Callback(hObject, eventdata, handles)
% hObject    handle to pdbCifSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles = guidata(handles.output);
handles.pdbCifFilterString = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pdbCifSearchText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdbCifSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pdbCifSearchPushButton.
function pdbCifSearchPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to pdbCifSearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
handles.pdbCifFilterString = get(handles.pdbCifSearchText, 'String');
handles.filteredPdbCifFiles = {};
for i=1:length(handles.pdbCifFiles)
    if(~isempty(regexpi(handles.pdbCifFiles{i}, handles.pdbCifFilterString)) || isempty(handles.pdbCifFilterString))
        handles.filteredPdbCifFiles(end+1) = handles.pdbCifFiles(i);
    end
end
set(handles.pdbCifListbox, 'string',  handles.filteredPdbCifFiles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pdbCifSearchPushButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdbCifSearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in pdbCifListbox.
function handles = pdbCifListbox_Callback(hObject, eventdata, handles)
% hObject    handle to pdbCifListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pdbCifListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pdbCifListbox
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.selectedPfbCifName = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pdbCifListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pdbCifListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = fastaFolderPathText_Callback(hObject, eventdata, handles)
% hObject    handle to fastaFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fastaFolderPathText as text
%        str2double(get(hObject,'String')) returns contents of fastaFolderPathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localFastaFolder = get(hObject,'String');
try
    localFastaFiles = dir(strcat(localFastaFolder, '\*.fasta'));
    auxStruct = struct2cell(localFastaFiles);
    set(handles.fastaListbox, 'string', auxStruct(1,:));
    handles = fastaListbox_Callback(handles.fastaListbox, eventdata, handles);
    handles.fastaFiles = auxStruct(1,:);
    handles.filteredFastaFiles = auxStruct(1,:);
catch
    h = msgbox('Folder not found or it has no .fasta files','Error');
end
handles.fastaFolder = localFastaFolder;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fastaFolderPathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastaFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in fastaBrowsePushButton.
function fastaBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to fastaBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
localFastaPath = uigetdir('Select the folder containing .fasta files');
set(handles.fastaFolderPathText, 'String', localFastaPath);
handles = fastaFolderPathText_Callback(handles.fastaFolderPathText, eventdata, handles);
handles.fastaFolder = localFastaPath;
guidata(hObject,handles);


function fastaSearchText_Callback(hObject, eventdata, handles)
% hObject    handle to fastaSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fastaSearchText as text
%        str2double(get(hObject,'String')) returns contents of fastaSearchText as a double
handles = guidata(handles.output);
handles.fastaFilterString = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function fastaSearchText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastaSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fastaSearchPushButton.
function fastaSearchPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to fastaSearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
handles.fastaFilterString = get(handles.fastaSearchText, 'String');
handles.filteredFastaFiles = {};
for i=1:length(handles.fastaFiles)
    if(~isempty(regexpi(handles.fastaFiles{i}, handles.fastaFilterString)) || isempty(handles.fastaFilterString))
        handles.filteredFastaFiles(end+1) = handles.fastaFiles(i);
    end
end
set(handles.fastaListbox, 'string',  handles.filteredFastaFiles);
guidata(hObject,handles);


% --- Executes on selection change in fastaListbox.
function handles = fastaListbox_Callback(hObject, eventdata, handles)
% hObject    handle to fastaListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fastaListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fastaListbox
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.selectedFastaName = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fastaListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastaListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function networkName_Callback(hObject, eventdata, handles)
% hObject    handle to networkName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of networkName as text
%        str2double(get(hObject,'String')) returns contents of networkName as a double
handles = guidata(handles.output);
handles.networkNameString = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in proteinCodification.
function proteinCodification_Callback(hObject, eventdata, handles)
% hObject    handle to proteinCodification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns proteinCodification contents as cell array
%        contents{get(hObject,'Value')} returns selected item from proteinCodification
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.proteinCodificationValue = contents{get(hObject,'Value')};
switch handles.proteinCodificationValue
    case 'A (Numerical)'
        multiplierValue = 1;
    case 'A-6 (Properties codification)'
        multiplierValue = 6;
    case 'A-9 (Properties codification)'
        multiplierValue = 9;
    case 'B (Raw Properties)'
        multiplierValue = 6;
end
set(handles.multiplierText, 'String', strcat(num2str(multiplierValue),' x'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function proteinCodification_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proteinCodification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.proteinCodificationValue = 'A (Numerical)';
guidata(hObject,handles);


% --- Executes on selection change in annListbox.
function handles = annListbox_Callback(hObject, eventdata, handles)
% hObject    handle to annListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns annListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from annListbox
if ~isfield(handles, 'ANNFile')
    handles = guidata(handles.output);
end
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

contents = cellstr(get(hObject,'String'));
handles.SelectedANNIndex = str2num(contents{get(hObject,'Value')});
loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
selectedANNTR = selectedANN.TR;
if ~isfield(selectedANNTR, 'perf')
    perf = 'NaN';
else
    perf = num2str(min(selectedANN.TR.perf));
end
tableData = {'ANN Name' selectedANN.NetworkName;
             'ANN Type' selectedANN.NetworkType;
             'Input Size' num2str(selectedANN.ANN.inputs{1}.size)
             'Crossover' num2str(selectedANN.Crossover);
             'Performance' perf;
             'Codification' selectedANN.Codification;
             'Training Function' selectedANN.TrainingFunction};
set(handles.annPropertiesTable, 'data', tableData);

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function annListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createNewANNPushButton.
function createNewANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to createNewANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;
try
    if ~isfield(handles,'networkNameString')
        networkNameStringParam = datestr(now);
    else
        if(isempty(handles.networkNameString))
            networkNameStringParam = datestr(now);
        else
            networkNameStringParam = handles.networkNameString;
        end
    end
    ANNStorage = generateNeuralNetwork(networkNameStringParam, handles.networkTypeValue, handles.proteinCodificationValue, handles.pdbCifFolder, handles.pdbCifFiles, handles.noOfInputsValue, handles.noOfHiddenNeuronsValue, handles.networkTrainingFunctionValue, [handles.firstDataDivisionLimitValue handles.secondDataDivisionLimitValue], [handles.useParallelCheckboxValue handles.useGpuCheckboxValue], handles.crossoverLengthValue, 6, [11 12 13]);
    if(exist(handles.ANNFile, 'file') == 2)
        loadedANN = load(handles.ANNFile);
        ANNStorage = [loadedANN.ANNStorage; ANNStorage];
    end
    handles.ANNStorageIndexes = 1:length(ANNStorage);
    save(handles.ANNFile, 'ANNStorage');
    set(handles.annListbox, 'string', handles.ANNStorageIndexes);
    set(handles.annListbox, 'Value', length(ANNStorage));
    handles = annListbox_Callback(handles.annListbox, eventdata, handles);
catch
    h = msgbox('Error','Error');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

% --- Executes on button press in createManyANNPushButton.
function createManyANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to createManyANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;
for i=0:30:150
    ANNStorage = generateFeedforwardNetwork(networkNameStringParam, handles.networkTypeValue, handles.proteinCodificationValue, handles.pdbCifFolder, handles.pdbCifFiles, handles.noOfInputsValue, handles.noOfHiddenNeuronsValue, handles.networkTrainingFunctionValue, [handles.firstDataDivisionLimitValue handles.secondDataDivisionLimitValue], [handles.useParallelCheckboxValue handles.useGpuCheckboxValue], [handles.useClassesCheckBoxValue handles.firstI50ClassLimitValue handles.secondI50ClassLimitValue], i, 6, [11 12 13]);
    if(exist(handles.ANNFile, 'file') == 2)
        loadedANN = load(handles.ANNFile);
        ANNStorage = [loadedANN.ANNStorage; ANNStorage];
    end
    handles.ANNStorageIndexes = 1:length(ANNStorage);
    save(handles.ANNFile, 'ANNStorage');
end
set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

function noOfInputs_Callback(hObject, eventdata, handles)
% hObject    handle to noOfInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfInputs as text
%        str2double(get(hObject,'String')) returns contents of noOfInputs as a double
handles = guidata(handles.output);
try
    handles.noOfInputsValue = get(hObject,'String');
    if ~all(ismember(handles.noOfInputsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.noOfInputsValue = str2double(handles.noOfInputsValue);
catch
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function noOfInputs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function noOfHiddenNeurons_Callback(hObject, eventdata, handles)
% hObject    handle to noOfHiddenNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfHiddenNeurons as text
%        str2double(get(hObject,'String')) returns contents of noOfHiddenNeurons as a double
handles = guidata(handles.output);
try
    handles.noOfHiddenNeuronsValue = get(hObject,'String');
    if ~all(ismember(handles.noOfHiddenNeuronsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.noOfHiddenNeuronsValue = str2double(handles.noOfHiddenNeuronsValue);
catch
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function noOfHiddenNeurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfHiddenNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function crossoverLength_Callback(hObject, eventdata, handles)
% hObject    handle to crossoverLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crossoverLength as text
%        str2double(get(hObject,'String')) returns contents of crossoverLength as a double
handles = guidata(handles.output);
try
    handles.crossoverLengthValue = get(hObject,'String');
    if ~all(ismember(handles.crossoverLengthValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.crossoverLengthValue = str2double(handles.crossoverLengthValue);
catch
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function crossoverLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crossoverLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in useANNSinglePushButton.
function useANNSinglePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to useANNSinglePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

try
    rawInput = fastareadCustom(strcat(handles.fastaFolder, '\', handles.selectedFastaName));
    loadedANN = load(handles.ANNFile);
    selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
    outputPath = strcat(handles.outputFolder, '\', strrep(lower(handles.selectedFastaName), '.fasta', '.cif'));
    useANN(selectedANN.ANN, rawInput, outputPath, selectedANN.ANN.inputs{1}.size, selectedANN.Crossover, 6);
    
%     if(strcmp(selectedANN.NetworkType, 'Self Organizing Map') && strcmp(selectedANN.Codification, 'B (Raw Properties)'))
%         codifiedInput = vertcat(codifiedInput{1}, codifiedInput{2}, codifiedInput{3}, codifiedInput{4}, codifiedInput{5}, codifiedInput{6});
%     end
%     rawOutput = selectedANN.ANN(codifiedInput);
%     if(iscell(rawOutput))
%         rawOutput = rawOutput{1};
%     end
%     if(strcmp(selectedANN.NetworkType, 'Self Organizing Map'))
%         rawOutput = find(rawOutput);
%         renormalizedOutput = 'NaN';
%     else
%         if(selectedANN.ClassArgs(1))
%             renormalizedOutput = convertToClasses(rawOutput, 0.25, 0.75);
%         else    
%             renormalizedOutput = renormalize(rawOutput, selectedANN.AntibodySetLimits(1), selectedANN.AntibodySetLimits(2));
%         end
%     end
%     set(handles.ANNOutputText, 'String', num2str(rawOutput));
%     set(handles.renormalizedANNOutputText, 'String', num2str(renormalizedOutput));
% catch
%     if(iscell(codifiedInput))
%         codifiedInput = codifiedInput{1};
%     end
%     if(length(codifiedInput) ~= selectedANN.ANN.inputs{1}.size)
%         h = msgbox(strcat('Fasta alignement length is:', num2str(length(codifiedInput)), ',it should be:', num2str(selectedANN.ANN.inputs{1}.size)), 'Error');
%     else
%         h = msgbox('Error', 'Error');
%     end
% end
catch
    h = msgbox('Error', 'Error');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes on button press in useANNMultiplePushButton.
function useANNMultiplePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to useANNMultiplePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

try
    rawInput = fastareadCustom(strcat(handles.fastaFolder, '\', handles.selectedFastaName));
    loadedANN = load(handles.ANNFile);
    selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);    
    for i=1:length(handles.filteredFastaFiles)
        outputPath = strcat(handles.outputFolder, '\', strrep(lower(handles.filteredFastaFiles{i}), '.fasta', '.cif'));
        useANN(selectedANN.ANN, rawInput, outputPath, selectedANN.ANN.inputs{1}.size, 0, 6);
    end
catch
    h = msgbox('Error', 'Error');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes on button press in viewANNPushButton.
function viewANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
view(selectedANN.ANN);

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


function handles = annFilePathText_Callback(hObject, eventdata, handles)
% hObject    handle to annFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of annFilePathText as text
%        str2double(get(hObject,'String')) returns contents of annFilePathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localANNFile = get(hObject,'String');
if(exist(localANNFile, 'file') == 2)
    loadedANN = load(localANNFile);
    localANNStorageIndexes = 1:length(loadedANN.ANNStorage);
    set(handles.annListbox, 'string', localANNStorageIndexes);
    handles.ANNFile = localANNFile;
    handles = annListbox_Callback(handles.annListbox, eventdata, handles);
    handles.ANNStorageIndexes = localANNStorageIndexes;
end
handles.ANNFile = localANNFile;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function annFilePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in annBrowsePushButton.
function annBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to annBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
[FileName,PathName] = uigetfile('*.mat','Select the Artificial Neural Network file');
localANNFile = strcat(PathName, FileName);
set(handles.annFilePathText, 'String', localANNFile);
handles = annFilePathText_Callback(handles.annFilePathText, eventdata, handles);
handles.ANNFile = localANNFile;
guidata(hObject,handles);


% --- Executes on selection change in networkType.
function networkType_Callback(hObject, eventdata, handles)
% hObject    handle to networkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns networkType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from networkType
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.networkTypeValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.networkTypeValue = 'Feedforward Neural Network';
guidata(hObject,handles);


% --- Executes on button press in useClassesCheckBox.
function useClassesCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to useClassesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useClassesCheckBox
handles = guidata(handles.output);
handles.useClassesCheckBoxValue = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function useClassesCheckBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useClassesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useClassesCheckBoxValue = 0;
guidata(hObject,handles);


function firstI50ClassLimit_Callback(hObject, eventdata, handles)
% hObject    handle to firstI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstI50ClassLimit as text
%        str2double(get(hObject,'String')) returns contents of firstI50ClassLimit as a double
handles = guidata(handles.output);
try
    handles.firstI50ClassLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.firstI50ClassLimitValue)
        h = msgbox('Value must be numeric');
        error();
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function firstI50ClassLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.firstI50ClassLimitValue = 0;
guidata(hObject,handles);


function secondI50ClassLimit_Callback(hObject, eventdata, handles)
% hObject    handle to secondI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondI50ClassLimit as text
%        str2double(get(hObject,'String')) returns contents of secondI50ClassLimit as a double
handles = guidata(handles.output);
try   
    handles.secondI50ClassLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.secondI50ClassLimitValue)
        h = msgbox('Value must be numeric');
        error();
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function secondI50ClassLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.secondI50ClassLimitValue = 0;
guidata(hObject,handles);


% --- Executes on button press in viewI50PushButton.
function viewI50PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewI50PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
setappdata(0,'mainHandles', handles);
I50GUI;
guidata(hObject, handles);


% --- Executes on button press in coveragePlotPushButton.
function coveragePlotPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to coveragePlotPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
try
    colors = colormap(jet);
    colorSpacing = floor(length(colors)/length(handles.antibodyNames));
    miuMLArray = logspace(-3,2,100);
    excelSize = size(handles.excelData);
    legendLabels = cell(length(handles.antibodyNames),1);
    figure('Name', 'Coverage Plot');
    for i=1:length(handles.antibodyNames)
        sortedData = sort(cell2mat(handles.excelData(2:excelSize(1), i+1)));
        coverageArray = linspace(0,0,length(miuMLArray));
        for j=1:length(miuMLArray)
            coverageArray(j) = length(sortedData(sortedData < miuMLArray(j)))/length(sortedData);
        end
        legendLabels{i} = handles.antibodyNames{i};
        semilogx(miuMLArray, coverageArray, 'Color', colors(i*colorSpacing,:)), hold on;
    end
    grid on;
    xlabel('Antibody concentration (ug/mL)');
    ylabel('% Coverage');
    legend(legendLabels);
catch
end

% --- Executes on button press in viewFastaPushButton.
function viewFastaPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewFastaPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
setappdata(0,'mainHandles', handles);
FastaGUI;
guidata(hObject, handles);


% --- Executes on button press in reggressionPlotPushButton.
function reggressionPlotPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to reggressionPlotPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
if(strcmp(selectedANN.NetworkType, 'Feedforward Neural Network'))
    figure('Name', 'Regression Plot');
    plotregression(selectedANN.PlotData.RegressionPlot{1,1}, selectedANN.PlotData.RegressionPlot{1,2}, 'Train', selectedANN.PlotData.RegressionPlot{2,1}, selectedANN.PlotData.RegressionPlot{2,2}, 'Validation', selectedANN.PlotData.RegressionPlot{3,1}, selectedANN.PlotData.RegressionPlot{3,2}, 'Testing');
else
    h = msgbox('Regression Plot is available only for Feedforward Neural Networks', 'Warning');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in sensitivityAnalysisPushButton.
function sensitivityAnalysisPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivityAnalysisPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)111
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

try
    setappdata(0,'mainHandles', handles);
    sensitivityAnalysisGUI;
catch
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in plotSomHitsPushButton.
function plotSomHitsPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotSomHitsPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
setappdata(0,'mainHandles', selectedANN);
plotSOMHitsGUI;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in viewClustersPushButton.
function viewClustersPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewClustersPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
setappdata(0,'mainHandles', selectedANN);
somOutputGUI;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on selection change in mapTopology.
function mapTopology_Callback(hObject, eventdata, handles)
% hObject    handle to mapTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapTopology contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapTopology
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.mapTopologyValue = contents{get(hObject,'Value')};
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function mapTopology_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.mapTopologyValue = 'Hexagonal';
guidata(hObject,handles);


% --- Executes on selection change in distanceFunction.
function distanceFunction_Callback(hObject, eventdata, handles)
% hObject    handle to distanceFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distanceFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distanceFunction
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.distanceFunctionValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function distanceFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.distanceFunctionValue = 'linkdist';
guidata(hObject,handles);


function mapWidth_Callback(hObject, eventdata, handles)
% hObject    handle to mapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapWidth as text
%        str2double(get(hObject,'String')) returns contents of mapWidth as a double
handles = guidata(handles.output);
try
    handles.mapWidthValue = get(hObject,'String');
    if ~all(ismember(handles.mapWidthValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.mapWidthValue = str2double(handles.mapWidthValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mapWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mapHeight_Callback(hObject, eventdata, handles)
% hObject    handle to mapHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapHeight as text
%        str2double(get(hObject,'String')) returns contents of mapHeight as a double
handles = guidata(handles.output);
try
    handles.mapHeightValue = get(hObject,'String');
    if ~all(ismember(handles.mapHeightValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.mapHeightValue = str2double(handles.mapHeightValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mapHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function trainingSteps_Callback(hObject, eventdata, handles)
% hObject    handle to trainingSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainingSteps as text
%        str2double(get(hObject,'String')) returns contents of trainingSteps as a double
handles = guidata(handles.output);
try
    handles.trainingStepsValue = get(hObject,'String');
    if ~all(ismember(handles.trainingStepsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.trainingStepsValue = str2double(handles.trainingStepsValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function trainingSteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainingSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function neighborhoodSize_Callback(hObject, eventdata, handles)
% hObject    handle to neighborhoodSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighborhoodSize as text
%        str2double(get(hObject,'String')) returns contents of neighborhoodSize as a double
handles = guidata(handles.output);
try
    handles.neighborhoodSizeValue = get(hObject,'String');
    if ~all(ismember(handles.neighborhoodSizeValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.neighborhoodSizeValue = str2double(handles.neighborhoodSizeValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function neighborhoodSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighborhoodSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function firstDataDivisionLimit_Callback(hObject, eventdata, handles)
% hObject    handle to firstDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstDataDivisionLimit as text
%        str2double(get(hObject,'String')) returns contents of firstDataDivisionLimit as a double
handles = guidata(handles.output);
try
    handles.firstDataDivisionLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.firstDataDivisionLimitValue)
        h = msgbox('Value must be an integer');
        error();
    end
    if(handles.firstDataDivisionLimitValue < 0 || handles.firstDataDivisionLimitValue > 100)
        h = msgbox('Value must be from 0 to 100');
        error();
    end
    if isfield(handles,'secondDataDivisionLimitValue')
        if(handles.firstDataDivisionLimitValue > handles.secondDataDivisionLimitValue)
            error();
            h = msgbox('The first value must be less than the second');
        end
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function firstDataDivisionLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function secondDataDivisionLimit_Callback(hObject, eventdata, handles)
% hObject    handle to secondDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondDataDivisionLimit as text
%        str2double(get(hObject,'String')) returns contents of secondDataDivisionLimit as a double
handles = guidata(handles.output);
try
    handles.secondDataDivisionLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.secondDataDivisionLimitValue)
        h = msgbox('Value must be an integer');
        error();
    end
    if(handles.secondDataDivisionLimitValue < 0 || handles.secondDataDivisionLimitValue > 100)
        h = msgbox('Value must be from 0 to 100');
        error();
    end
    if isfield(handles,'firstDataDivisionLimitValue')
        if(handles.firstDataDivisionLimitValue > handles.secondDataDivisionLimitValue)
            error();
            h = msgbox('The first value must be less than the second');
        end
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function secondDataDivisionLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in networkTrainingFunction.
function networkTrainingFunction_Callback(hObject, eventdata, handles)
% hObject    handle to networkTrainingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns networkTrainingFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from networkTrainingFunction
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.networkTrainingFunctionValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkTrainingFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkTrainingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.networkTrainingFunctionValue = 'Levenberg-Marquardt';
guidata(hObject,handles);


% --- Executes on button press in useParallelCheckbox.
function useParallelCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to useParallelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useParallelCheckbox
handles = guidata(handles.output);
handles.useParallelCheckboxValue = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function useParallelCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useParallelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useParallelCheckboxValue = 0;
guidata(hObject,handles);


% --- Executes on button press in useGpuCheckbox.
function useGpuCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to useGpuCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useGpuCheckbox
handles = guidata(handles.output);
handles.useGpuCheckboxValue = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function useGpuCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useGpuCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useGpuCheckboxValue = 0;
guidata(hObject,handles);



% --- Executes on button press in DebugButton.
function DebugButton_Callback(hObject, eventdata, handles)
% hObject    handle to DebugButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard


% --- Executes during object creation, after setting all properties.
function annPropertiesTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annPropertiesTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function handles = outputFolderPathText_Callback(hObject, eventdata, handles)
% hObject    handle to outputFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputFolderPathText as text
%        str2double(get(hObject,'String')) returns contents of outputFolderPathText as a double
handles = guidata(handles.output);
handles.outputFolder = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function outputFolderPathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputFolderPathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputBrowsePushButton.
function outputBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to outputBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
localOutputPath = uigetdir('Select the folder to save the resulting fasta files');
set(handles.outputFolderPathText, 'String', localOutputPath);
handles = outputFolderPathText_Callback(handles.outputFolderPathText, eventdata, handles);
handles.outputFolder = localOutputPath;
guidata(hObject,handles);
