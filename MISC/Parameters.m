function varargout = Parameters(varargin)
% PARAMETERS MATLAB code for Parameters.fig
%      PARAMETERS, by itself, creates a new PARAMETERS or raises the existing
%      singleton*.
%
%      H = PARAMETERS returns the handle to a new PARAMETERS or the handle to
%      the existing singleton*.
%
%      PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERS.M with the given input arguments.
%
%      PARAMETERS('Property','Value',...) creates a new PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stohandles.P.  All inputs are passed to Parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parameters

% Last Modified by GUIDE v2.5 29-Mar-2014 15:43:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @Parameters_OutputFcn, ...
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


% --- Executes just before Parameters is made visible.
function Parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Parameters (see VARARGIN)

% Choose default command line output for Parameters
handles.output = hObject;
handles.output = hObject;
if ~isempty(varargin)
    handles.Ps=varargin{1};
end
set(handles.figure1,'name','Setup Analysis');

set(handles.Table,'data',[]);
% set(handles.Ps.s1,'value',1);
% set(handles.Ps.s2,'value',0);
% set(handles.Ps.s3,'value',0);
% set(handles.Ps.s4,'value',0);
% set(handles.Ps.none,'value',0);

set(handles.tabNodes,'value',1);
set(handles.tabLinks,'value',0);
set(handles.tabPipesTanks,'value',0);
set(handles.tabPatterns,'value',0);

set(handles.VarianceP,'Visible','off');
set(handles.text14,'Visible','off');
set(handles.text16,'Visible','off');
set(handles.FlowPrcPatterns,'Visible','off');
set(handles.FlowSamplesPatterns,'Visible','off');

set(handles.Uncertainty,'Visible','off');
set(handles.Uncertainty2,'Visible','off');
set(handles.equations,'Visible','off');

set(handles.FlowPrcPatterns, 'String',0);
set(handles.FlowSamplesPatterns, 'String',1);

set(handles.parameterV1, 'String',0);
set(handles.parameterV2, 'String',0);
set(handles.parameterV3, 'String',0);
set(handles.parameterS1, 'String',0);
set(handles.parameterS2, 'String',0); 
set(handles.parameterS3, 'String',0);

handles.NodeTable={};
handles.LinkTable={};
handles.PipeTankTable={};
handles.ReservoirTable={};
handles.TankTable={};
handles.loadFile=0;

handles.c1=0;
handles.c2=0;
handles.c3=0;
handles.c4=0;
handles.c5=0;
handles.c6=0;

handles.NodeTableCount=0;
handles.LinkTableCount=0;
handles.PipeTankTableCount=0;
handles.ReservoirTableCount=0;
handles.TankTableCount=0;
handles.PatternTCount=0;

handles.Init=handles.Ps.B.getMSXParametersPipesValue{1};

handles.P=DefaultParameters(handles);
SetGui(hObject, eventdata, handles);

function [P]=DefaultParameters(handles)    
    %TIMES

    P.EndTime=48; %e.g.48 in Hours
%     P.StartTime=0; %e.g.48 in Hours

    %AFFECTING FLOWS
    P.Diameters=handles.Ps.B.LinkDiameter;
    P.Lengths=handles.Ps.B.LinkLength;
    P.Roughness=handles.Ps.B.LinkRoughnessCoeff;
    P.Elevation=handles.Ps.B.NodeElevations;
    P.BaseDemand=handles.Ps.B.NodeBaseDemands;
    P.Patterns=handles.Ps.B.getPattern;
    for i=1:handles.Ps.B.LinkCount
        for u=1:handles.Ps.B.MSXSpeciesCount
            P.QualityLink(u,i)=handles.Ps.B.MSXLinkInitqualValue{i}(u);
        end
    end
    for i=1:handles.Ps.B.NodeCount
        k=2;
        for u=1:handles.Ps.B.MSXSpeciesCount-1
            P.QualityNode(u,i)=handles.Ps.B.MSXNodeInitqualValue{i}(k);
            k=k+1;
        end
    end
    P.QualityNodeRes=P.QualityNode(:,handles.Ps.B.NodeReservoirIndex)';
    P.QualityNodeTank=P.QualityNode(:,handles.Ps.B.NodeTankIndex)';

    v=handles.Ps.B.getMSXParametersPipesValue;
    for i=1:handles.Ps.B.LinkPipeCount
        for u=1:handles.Ps.B.MSXParametersCount
            P.Coeff(u,i)=v{i}(u);
        end
    end
    v2=handles.Ps.B.getMSXParametersTanksValue;
    for k=handles.Ps.B.NodeTankIndex
        i=i+1;
        for u=1:handles.Ps.B.MSXParametersCount
            P.Coeff(u,i)=v2{k}(u);
        end
    end
    
    P.FlowParameters={'Diameters', 'Lengths','Roughness',...
        'Elevation','BaseDemand','Patterns'};
    P.FlowValues={P.Diameters, P.Lengths, P.Roughness,...
        P.Elevation, P.BaseDemand, P.Patterns};
    
    P.FlowPrc={0,0,0,0,0,0};
    P.FlowSamples={1,1,1,1,1,1};
    
    t=7;
    for i=1:handles.Ps.B.MSXParametersCount
        P.FlowParameters{t}=handles.Ps.B.MSXParametersNameID{i};
        P.FlowValues{t}=P.Coeff(i,:);
        P.FlowPrc{t}=0;
        P.FlowSamples{t}=1;
        t=t+1;
    end
    


function SetGui(hObject, eventdata, handles)
    % Time Parameters
%     set(handles.Start_time,'String',num2str(handles.P.StartTime));
    set(handles.End_time,'String',num2str(handles.P.EndTime));
       
    tabNodes_Callback(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Parameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Start_time_Callback(hObject, eventdata, handles)
% hObject    handle to Start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Start_time as text
%        str2double(get(hObject,'String')) returns contents of Start_time as a double


% --- Executes during object creation, after setting all properties.
function Start_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Start_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function End_time_Callback(hObject, eventdata, handles)
% hObject    handle to End_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of End_time as text
%        str2double(get(hObject,'String')) returns contents of End_time as a double


% --- Executes during object creation, after setting all properties.
function End_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to End_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveFile.
function SaveFile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   errorCode = CheckForError(handles);
    if errorCode, return; end
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabLinks,'value',0);
        return;
    end
    
    set(handles.tabLinks,'value',1);
    handles=tabLinks_Callback(hObject, eventdata, handles);
    set(handles.tabPipesTanks,'value',1);
    handles=tabPipesTanks_Callback(hObject, eventdata, handles);
    set(handles.tabPatterns,'value',1);
    handles=tabPatterns_Callback(hObject, eventdata, handles);   
    set(handles.tabReservoirs,'value',1);
    handles=tabReservoirs_Callback(hObject, eventdata, handles);
    set(handles.tabTanks,'value',1);
    handles=tabTanks_Callback(hObject, eventdata, handles);
    set(handles.tabNodes,'value',1);
    handles=tabNodes_Callback(hObject, eventdata, handles);   
    
    % Methods
    P=gridmethod(handles);
    B=handles.Ps.B;
    [file0,pathname] = uiputfile([pwd,'\RESULTS\','*.0']);
    if isnumeric(file0)
        file0=[];
    end
    if ~isempty((file0)) 
        save([pathname,file0],'P','B','-mat');
        save([pwd,'\RESULTS\','File0.File'],'file0','-mat');
        if exist([file0(1:end-2),'.w'],'file')==2
            delete([pathname,file0(1:end-2),'.w']);
        end
        % History
        y=['>>Save in file "',file0,'".'];
        handles.Ps.msg=[handles.Ps.msg;{y}];
        set(handles.Ps.LoadText,'Value',length(handles.Ps.msg)); 
        set(handles.Ps.LoadText,'String',handles.Ps.msg);
        guidata(hObject, handles);
    end

function errorCode = CheckForError(handles)
    errorCode=0;

%     Start_time=str2num(get(handles.Start_time, 'String'));
%     if ~length(Start_time) || Start_time<0
%         msgbox('     Give Start Time', 'Error', 'modal')
%         errorCode=1;
%         return
%     end
    End_time=str2num(get(handles.End_time, 'String'));
    if ~length(End_time) || End_time<0
        msgbox('     Give Simulation Time', 'Error', 'modal')
        errorCode=1;
        return
    end


%     
% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [file0,~] = uigetfile([pwd,'\RESULTS\','*.0'],'Select the MATLAB *.0 file');
    if isnumeric(file0)
        file0=[];
    end
    if ~isempty((file0)) 
        load([pwd,'\RESULTS\',file0],'-mat');
        handles.P=P;
        
        if length(P.Elevation)~=handles.Ps.B.NodeCount
            warndlg('           Wrong file.','Load File');
            return;
        end
%         set(handles.Start_time,'String',num2str(handles.P.StartTime));
        set(handles.End_time,'String',num2str(handles.P.EndTime));
    
        handles.NodeTable=zeros(handles.Ps.B.NodeCount,2);
        handles.NodeTable(1:end,1)=P.Elevation;
        handles.NodeTable(1:end,2)=P.BaseDemand;
        handles.P.FlowPrc{4}= P.FlowPrc{4}; 
        handles.P.FlowSamples{4}= P.FlowSamples{4}; 
        handles.P.FlowPrc{5}= P.FlowPrc{5}; 
        handles.P.FlowSamples{5}= P.FlowSamples{5}; 
        
        handles.LinkTable=zeros(handles.Ps.B.LinkCount,3);
        handles.LinkTable(1:end,1)=P.Diameters;
        handles.LinkTable(1:end,2)=P.Lengths;
        handles.LinkTable(1:end,3)=P.Roughness;
        handles.P.FlowPrc{1}= P.FlowPrc{1}; 
        handles.P.FlowSamples{1}= P.FlowSamples{1}; 
        handles.P.FlowPrc{2}= P.FlowPrc{2}; 
        handles.P.FlowSamples{2}= P.FlowSamples{2}; 
        handles.P.FlowPrc{3}= P.FlowPrc{3}; 
        handles.P.FlowSamples{3}= P.FlowSamples{3}; 
        
        handles.PipeTankTable=zeros(handles.Ps.B.MSXParametersCount,3);

        t=7;
        for i=1:handles.Ps.B.MSXParametersCount
            handles.PipeTankTable(i,1)= P.FlowPrc{t}; 
            handles.PipeTankTable(i,2)= P.FlowSamples{t};
            handles.PipeTankTable(i,3)= P.PipeTankTable(i,3);%Temperature
            t=t+1;
        end
        
        set(handles.FlowPrcPatterns,'String',P.FlowPrc{6});
        set(handles.FlowSamplesPatterns,'String',P.FlowSamples{6});
        
        handles.ReservoirTable=zeros(handles.Ps.B.NodeReservoirCount,handles.Ps.B.MSXSpeciesCount-1);
        for i=1:handles.Ps.B.NodeReservoirCount
            handles.ReservoirTable(i,1)=P.QualityNodeRes(i,1);
            handles.ReservoirTable(i,2)=P.QualityNodeRes(i,2);
            handles.ReservoirTable(i,3)=P.QualityNodeRes(i,3);
        end
        
        handles.TankTable=zeros(handles.Ps.B.NodeTankCount,1);
        for i=1:handles.Ps.B.NodeTankCount
            handles.TankTable(i,1)=P.QualityNodeTank(i,1);
        end
        
        % History
        y=['>>Load file "',file0,'".'];
        handles.Ps.msg=[handles.Ps.msg;{y}];
        set(handles.Ps.LoadText,'Value',length(handles.Ps.msg)); 
        set(handles.Ps.LoadText,'String',handles.Ps.msg);
 
        % Update handles structure
        guidata(hObject, handles);
        
        handles.NodeTableCount=1;
        handles.LinkTableCount=1;
        handles.PipeTankTableCount=1;
        handles.ReservoirTableCount=1;
        handles.TankTableCount=1;
        handles.PatternTCount=1;
        
        handles.c1=0;
        handles.c2=0;
        handles.c3=0;
        handles.c4=0;
        handles.c5=0;
        handles.c6=0;

        handles.loadFile=1;
        set(handles.tabNodes,'value',1);
        tabNodes_Callback(hObject, eventdata, handles);
    end

% --- Executes on button press in LoadDefaults.
function LoadDefaults_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDefaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    button = questdlg('Do you want to continue?',...
    'Default','Yes','No','No');

    button = strcmp(button,'Yes');

    if button==1
        handles.NodeTableCount=0;
        handles.LinkTableCount=0;
        handles.PipeTankTableCount=0;
        handles.ReservoirTableCount=0;
        handles.TankTableCount=0;
        handles.PatternTCount=0;
        handles.loadFile=0;

        P=DefaultParameters(handles);
        handles.P=P;
        
        
        % History
        y=['>>Load Defaults Selected.'];
        handles.Ps.msg=[handles.Ps.msg;{y}];
        set(handles.Ps.LoadText,'Value',length(handles.Ps.msg)); 
        set(handles.Ps.LoadText,'String',handles.Ps.msg);
        
        % Update handles structure
        guidata(hObject, handles);

        SetGui(hObject, eventdata, handles);
    end

function FlowPrcPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to FlowPrcPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FlowPrcPatterns as text
%        str2double(get(hObject,'String')) returns contents of FlowPrcPatterns as a double


% --- Executes during object creation, after setting all properties.
function FlowPrcPatterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlowPrcPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FlowSamplesPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to FlowSamplesPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FlowSamplesPatterns as text
%        str2double(get(hObject,'String')) returns contents of FlowSamplesPatterns as a double


% --- Executes during object creation, after setting all properties.
function FlowSamplesPatterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlowSamplesPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function P=gridmethod(handles)

    P=GetGuiParameters(handles);
    
    FlowScenarioSets={};

    %compute scenarios affecting flows
    for i=1:length(P.FlowParameters)
%         if i>6
%             P.FlowValues{i}=P.FlowValues{i}.*rand(handles.Ps.B.LinkPipeCount+handles.Ps.B.NodeTankCount,1);
%         end
%         try
        P.FlowParamScenarios{i}=linspaceNDim((P.FlowValues{i}-(P.FlowPrc{i}/100).*P.FlowValues{i})'', (P.FlowValues{i}+(P.FlowPrc{i}/100).*P.FlowValues{i})'', P.FlowSamples{i});
%         catch err
%         end
        if find(strcmp(P.FlowParameters{i},'Patterns'))
            if (size(P.Patterns,1)==1)
                FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},2);
            else
                FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},3);
            end
        else
%             try
            FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},2);
%             catch err
%             end
        end
    end
    P.ScenariosFlowIndex=cartesianProduct(FlowScenarioSets);

    
function P=GetGuiParameters(handles)
    B=handles.Ps.B;
    format long g;
    % Time Parameters
%     P.StartTime = 0;%str2num(get(handles.Start_time,'String'));
    P.EndTime = str2num(get(handles.End_time,'String'));
    
    % Hydraulic Parameters

    % Links
    % Diameters
    LinkTable=handles.LinkTable;
    P.FlowPrc={};
    P.FlowSamples={};

    P.FlowPrc{1}=handles.P.FlowPrc{1};
    P.FlowSamples{1}=handles.P.FlowSamples{1};
    P.Diameters=LinkTable(1:end,1);
    % Lengths
    P.FlowPrc{2}=handles.P.FlowPrc{2};
    P.FlowSamples{2}=handles.P.FlowSamples{2};
    P.Lengths=LinkTable(1:end,2);
    % Roughness
    P.FlowPrc{3}=handles.P.FlowPrc{3};
    P.FlowSamples{3}=handles.P.FlowSamples{3};
    P.Roughness=LinkTable(1:end,3);
    
    % Nodes
    % Elevations
    NodeTable= handles.NodeTable;
    P.FlowPrc{4}=handles.P.FlowPrc{4};
    P.FlowSamples{4}=handles.P.FlowSamples{4};
    P.Elevation=NodeTable(1:end,1);
    % Basedemands
    P.FlowPrc{5}=handles.P.FlowPrc{5};
    P.FlowSamples{5}=handles.P.FlowSamples{5};
    P.BaseDemand=NodeTable(1:end,2);
    
    % Patterns
    P.Patterns=B.getPattern;
    P.FlowPrc{6}=handles.P.FlowPrc{6};
    P.FlowSamples{6}=handles.P.FlowSamples{6};

    P.QualityNodeRes=handles.ReservoirTable;
    P.QualityNodeTank=handles.TankTable;
        
    % Pipe & Tanks    
    P.PipeTankTable=handles.PipeTankTable;
    P.Coeff=ones(handles.Ps.B.LinkPipeCount+handles.Ps.B.NodeTankCount,handles.Ps.B.MSXParametersCount);
    
    t=7;
    for i=1:handles.Ps.B.MSXParametersCount
        P.FlowPrc{t}=P.PipeTankTable(i,1);
        P.FlowSamples{t}=P.PipeTankTable(i,2);
        P.Coeff(:,i)=P.Coeff(:,i)*P.PipeTankTable(i,3);
        t=t+1;
    end
    
    P.FlowParameters={'Diameters', 'Lengths','Roughness',...
        'Elevation','BaseDemand','Patterns'};
    P.FlowValues={P.Diameters, P.Lengths, P.Roughness,...
        P.Elevation, P.BaseDemand, P.Patterns};
    
    t=7;
    for i=1:handles.Ps.B.MSXParametersCount
        P.FlowParameters{t}=handles.Ps.B.MSXParametersNameID{i};
        P.FlowValues{t}=P.Coeff(:,i);
        t=t+1;
    end

% --- Executes when entered data in editable cell(s) in Table.
function Table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

if  get(handles.tabNodes,'value')
    handles.NodeTable = get(handles.Table,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    if d==1 && edit>-1  
        handles.NodeTable(row,col)= new;
        set(handles.Table,'data',handles.NodeTable);
    else
        handles.NodeTable(row,col)=previous;
        set(handles.Table,'data',handles.NodeTable);
    end

    
elseif get(handles.tabLinks,'value');
    handles.LinkTable = get(handles.Table,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    if d==1 && edit>-1  
        handles.LinkTable(row,col)= new;
        set(handles.Table,'data',handles.LinkTable);
    else
        handles.LinkTable(row,col)=previous;
        set(handles.Table,'data',handles.LinkTable);
    end

    
elseif get(handles.tabPipesTanks,'value');
    handles.PipeTankTable = get(handles.Table,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    % Column1 %
    if d==1 && col==1 && edit>-1  
        handles.PipeTankTable(row,col)= new;
        set(handles.Table,'data',handles.PipeTankTable);
    elseif col==1
        handles.PipeTankTable(row,col)=previous;
        set(handles.Table,'data',handles.PipeTankTable);
    end

    % Column2 Samples
    if d==1 && col==2 && edit>0  
        handles.PipeTankTable(row,col)= new;
        set(handles.Table,'data',handles.PipeTankTable);
    elseif col==2
        handles.PipeTankTable(row,col)=previous;
        set(handles.Table,'data',handles.PipeTankTable);
    end

    % Column3...ColumnN Links
    if d==1 && col>2 && edit>-1  
        handles.PipeTankTable(row,col)= new;
        set(handles.Table,'data',handles.PipeTankTable);
    elseif col>2
        handles.PipeTankTable(row,col)=previous;
        set(handles.Table,'data',handles.PipeTankTable);
    end
    
elseif get(handles.tabReservoirs,'value');
    handles.ReservoirTable = get(handles.Table,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    if d==1 && edit>-1  
        handles.ReservoirTable(row,col)= new;
        set(handles.Table,'data',handles.ReservoirTable);
    else
        handles.ReservoirTable(row,col)=previous;
        set(handles.Table,'data',handles.ReservoirTable);
    end

elseif get(handles.tabTanks,'value');
    handles.TankTable = get(handles.Table,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    if d==1 && edit>-1  
        handles.TankTable(row,col)= new;
        set(handles.Table,'data',handles.TankTable);
    else
        handles.TankTable(row,col)=previous;
        set(handles.Table,'data',handles.TankTable);
    end
end


    
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   handles.loadFile=1;
   errorCode = CheckForError(handles);
    if errorCode, return; end
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabLinks,'value',0);
        return;
    end
    
    set(handles.tabLinks,'value',1);
    handles=tabLinks_Callback(hObject, eventdata, handles);
    set(handles.tabPipesTanks,'value',1);
    handles=tabPipesTanks_Callback(hObject, eventdata, handles);
    set(handles.tabPatterns,'value',1);
    handles=tabPatterns_Callback(hObject, eventdata, handles);   
    set(handles.tabReservoirs,'value',1);
    handles=tabReservoirs_Callback(hObject, eventdata, handles);
    set(handles.tabTanks,'value',1);
    handles=tabTanks_Callback(hObject, eventdata, handles);
    set(handles.tabNodes,'value',1);
    handles=tabNodes_Callback(hObject, eventdata, handles);   

    P=gridmethod(handles);
    B=handles.Ps.B;
    save([pwd,'\RESULTS\','Run.0'],'P','B','-mat');
    % History
    y=['>>Scenario Parameters saved in file "','Run.0','".'];
    handles.Ps.msg=[handles.Ps.msg;{y}];
    set(handles.Ps.LoadText,'Value',length(handles.Ps.msg)); 
    set(handles.Ps.LoadText,'String',handles.Ps.msg);
    guidata(hObject, handles);
    set(handles.figure1,'Visible','off');

set(handles.Ps.Run,'enable','on');
set(handles.Ps.s1,'enable','on');
set(handles.Ps.s2,'enable','on');
set(handles.Ps.s3,'enable','on');
set(handles.Ps.s4,'enable','on');
set(handles.Ps.none,'enable','off');
set(handles.Ps.text20,'enable','on');
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
set(handles.figure1,'Visible','off');
set(handles.Ps.Run,'enable','off');

if strcmp(get(handles.Ps.Results,'enable'),'off');
    set(handles.Ps.s1,'enable','off');
    set(handles.Ps.s2,'enable','off');
    set(handles.Ps.s3,'enable','off');
    set(handles.Ps.s4,'enable','off');
    set(handles.Ps.none,'enable','off');
    set(handles.Ps.text20,'enable','off');
end
% set(handles.Ps.Results,'enable','off');


% --- Executes on button press in tabNodes.
function handles=tabNodes_Callback(hObject, eventdata, handles)
% hObject    handle to tabNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabNodes
if handles.loadFile==0 || handles.c1==1
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabNodes,'value',0);
        return;
    end
end

set(handles.Table,'ColumnWidth',{130})
set(handles.Table,'position',[1.8 0.769230769230769 69 16.5384615384615]);

set(handles.Uncertainty2,'Visible','off');
set(handles.VarianceP,'Visible','off');
set(handles.text14,'Visible','off');
set(handles.text16,'Visible','off');
set(handles.FlowPrcPatterns,'Visible','off');
set(handles.FlowSamplesPatterns,'Visible','off');

set(handles.Uncertainty,'Visible','on');
set(handles.V,'Visible','on');
set(handles.S,'Visible','on');
set(handles.text_1,'Visible','on');
set(handles.parameterV1,'Visible','on');
set(handles.parameterS1,'Visible','on');
set(handles.textp1,'Visible','on');
set(handles.text_2,'Visible','on');
set(handles.parameterV2,'Visible','on');
set(handles.parameterS2,'Visible','on');
set(handles.textp2,'Visible','on');
set(handles.text_3,'Visible','off');
set(handles.parameterV3,'Visible','off');
set(handles.parameterS3,'Visible','off');
set(handles.textp3,'Visible','off');
    set(handles.equations,'Visible','off');

    set(handles.Table,'Visible','on');

    set(handles.Table,'data',[]);
    set(handles.tabNodes,'value',1);

    % NODES
    NodeTableColumnName(1,1:handles.Ps.B.NodeCount)=handles.Ps.B.NodeNameID;
    set(handles.Table, 'RowName', NodeTableColumnName);
    Elevations=['Elevations(',handles.Ps.B.NodeElevationUnits,')'];
    Basedemands=['Basedemands(',handles.Ps.B.LinkFlowUnits,')'];
    set(handles.Table,'ColumnName',{Elevations,Basedemands}); 
   
    % Nodes
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:handles.Ps.B.NodeCount
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.Table,'ColumnEditable',str2num(ColumnEditable));
    set(handles.textp2,'String',[Basedemands,' :']);
    set(handles.textp1,'String',[Elevations,' :']);

    % Elevations
    if handles.NodeTableCount
        set(handles.Table,'data',handles.NodeTable);    
        set(handles.parameterV1,'String',handles.P.FlowPrc(4)); %ELEVATION
        set(handles.parameterS1,'String',handles.P.FlowSamples(4));
        set(handles.parameterV2,'String',handles.P.FlowPrc(5)); %BASEDEMAND
        set(handles.parameterS2,'String',handles.P.FlowSamples(5));        
    else
        handles.NodeTable=zeros(handles.Ps.B.NodeCount,2);
        handles.NodeTable(1:end,1)=handles.P.Elevation;
        % Basedemands
        handles.NodeTable(1:end,2)=handles.P.BaseDemand{1};  
        set(handles.Table,'data',handles.NodeTable);
        set(handles.parameterV1,'String',0); %ELEVATION
        set(handles.parameterS1,'String',1);
        set(handles.parameterV2,'String',0); %BASEDEMAND
        set(handles.parameterS2,'String',1);
        handles.NodeTableCount=1;
    end
    set(handles.tabLinks,'value',0);
    set(handles.tabPipesTanks,'value',0);
    set(handles.tabPatterns,'value',0);
    set(handles.tabReservoirs,'value',0);
    set(handles.tabTanks,'value',0);

handles.c1=1;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in tabLinks.
function handles=tabLinks_Callback(hObject, eventdata, handles)
% hObject    handle to tabLinks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabLinks
if handles.loadFile==0 || handles.c2==1
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabLinks,'value',0);
        return;
    end
end
set(handles.Table,'ColumnWidth',{91})
set(handles.Table,'position',[1.8 0.769230769230769 69 16.5384615384615]);

set(handles.Uncertainty2,'Visible','off');
set(handles.VarianceP,'Visible','off');
set(handles.text14,'Visible','off');
set(handles.text16,'Visible','off');
set(handles.FlowPrcPatterns,'Visible','off');
set(handles.FlowSamplesPatterns,'Visible','off');
set(handles.Table,'Visible','on');
    
set(handles.Uncertainty,'Visible','on');
set(handles.V,'Visible','on');
set(handles.S,'Visible','on');
set(handles.text_1,'Visible','on');
set(handles.parameterV1,'Visible','on');
set(handles.parameterS1,'Visible','on');
set(handles.textp1,'Visible','on');
set(handles.text_2,'Visible','on');
set(handles.parameterV2,'Visible','on');
set(handles.parameterS2,'Visible','on');
set(handles.textp2,'Visible','on');
set(handles.text_3,'Visible','on');
set(handles.parameterV3,'Visible','on');
set(handles.parameterS3,'Visible','on');
set(handles.textp3,'Visible','on');

    set(handles.equations,'Visible','off');

    set(handles.Table,'data',[]);
    set(handles.tabLinks,'value',1);

   % Hydraulic Parameters
    LinkTableColumnName(1,1:handles.Ps.B.LinkCount)=handles.Ps.B.LinkNameID;
    set(handles.Table, 'RowName', LinkTableColumnName);
    
    % LINKS
    Diameters=['Diameters(',handles.Ps.B.LinkPipeDiameterUnits,')'];
    Lengths=['Lengths(',handles.Ps.B.LinkLengthUnits,')'];
    set(handles.Table,'ColumnName',{Diameters,Lengths,'Roughness'});
    
     % Links
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:handles.Ps.B.LinkCount
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.Table,'ColumnEditable',str2num(ColumnEditable));
    
    set(handles.textp1,'String',[Diameters,' :']);
    set(handles.textp2,'String',[Lengths,' :']);
    set(handles.textp3,'String','Roughness :');

    if handles.LinkTableCount
        set(handles.Table,'data',handles.LinkTable);
        %Diameters
        set(handles.parameterV1,'String',handles.P.FlowPrc(1)); 
        set(handles.parameterS1,'String',handles.P.FlowSamples(1));
        %Lengths
        set(handles.parameterV2,'String',handles.P.FlowPrc(2)); 
        set(handles.parameterS2,'String',handles.P.FlowSamples(2));
        %Roughness
        set(handles.parameterV3,'String',handles.P.FlowPrc(3)); 
        set(handles.parameterS3,'String',handles.P.FlowSamples(3));        
    else
        handles.LinkTable=zeros(handles.Ps.B.LinkCount,3);
        handles.LinkTable(1:end,1)=handles.P.Diameters;
        handles.LinkTable(1:end,2)=handles.P.Lengths;
        handles.LinkTable(1:end,3)=handles.P.Roughness;
        set(handles.Table,'data',handles.LinkTable);
        
        %Diameters
        set(handles.parameterV1,'String',0); 
        set(handles.parameterS1,'String',1);
        %Lengths
        set(handles.parameterV2,'String',0); 
        set(handles.parameterS2,'String',1);
        %Roughness
        set(handles.parameterV3,'String',0); 
        set(handles.parameterS3,'String',1);
    
        handles.LinkTableCount=1;
    end
    
    set(handles.tabNodes,'value',0);
    set(handles.tabPipesTanks,'value',0);
    set(handles.tabPatterns,'value',0);
    set(handles.tabReservoirs,'value',0);
    set(handles.tabTanks,'value',0);    
    
     handles.c2=1;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in tabPipesTanks.
function handles=tabPipesTanks_Callback(hObject, eventdata, handles)
% hObject    handle to tabPipesTanks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabPipesTanks
if handles.loadFile==0 || handles.c3==1
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabPipesTanks,'value',0);
        return;
    end
end
    set(handles.Table,'ColumnWidth',{100})
    set(handles.Table,'position',[1.8 0.769230769230769 84.65 16.5384615384615]);

    set(handles.Uncertainty,'Visible','off');
    set(handles.Uncertainty2,'Visible','off');
    
    set(handles.equations,'Visible','on');
%     rr=get(handles.equations,'position');
    set(handles.equations,'position',[87.4 .595 64 16.6923]);
%     set(handles.equations,'Value',1);
    set(handles.equations,'FontSize',7.3);
    set(handles.equations,'String',[{'*Supplies the rate and equilibrium expressions that govern species dynamics in pipes*'},...
        'dChlorine/dt=-Kb*Chlorine - (4/D)*Kw*Kf/(Kw+Kf)*Chlorine','dTOC/dt=0','dTHMs/dt=Y*Kb*Chlorine',{''},{'*Supplies the rate and equilibrium expressions that govern species dynamics in storage tanks*'}...
       'dChlorine/dt=-Kb*Chlorine','dTOC/dt=0','dTHMs/dt=Y*Kb*Chlorine',{''},'where,','Kw = Wall Reaction,   Kb = Bulk Reaction,   Y = TTHM yield coefficient',...
       'Temperature in Celcius',{''},'Kb=1.8e6*exp(-6050/(Temperature+273)))*TOC(mg/l)']);
    	
    set(handles.VarianceP,'Visible','off');
    set(handles.text14,'Visible','off');
    set(handles.text16,'Visible','off');
    set(handles.FlowPrcPatterns,'Visible','off');
    set(handles.FlowSamplesPatterns,'Visible','off');
    set(handles.Table,'Visible','on');

    set(handles.Table,'data',[]);
    set(handles.tabPipesTanks,'value',1);

    % PipeTankTable
    if handles.PipeTankTableCount
        set(handles.Table,'data',handles.PipeTankTable);
    else
        handles.PipeTankTable=zeros(handles.Ps.B.MSXParametersCount,3);
        t=7;
        for i=1:handles.Ps.B.MSXParametersCount
            handles.PipeTankTable(i,1)= handles.P.FlowPrc{t}; 
            handles.PipeTankTable(i,2)= handles.P.FlowSamples{t};
            handles.PipeTankTable(i,3)=handles.Init(i);
            t=t+1;
        end

        set(handles.Table,'data',handles.PipeTankTable);
        handles.PipeTankTableCount=1;
    end
    
    PipeTankTableColumnName = cell(1,3);
    PipeTankTableColumnName(1,1)={'%'};
    PipeTankTableColumnName(1,2)={'Samples'};
    PipeTankTableColumnName(1,3)={'Global'};
    set(handles.Table, 'ColumnName', PipeTankTableColumnName);
    
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:3
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.Table,'ColumnEditable',str2num(ColumnEditable));
    
    set(handles.Table,'RowName',[handles.Ps.B.MSXParametersNameID]);
    
    set(handles.tabNodes,'value',0);
    set(handles.tabPatterns,'value',0);
    set(handles.tabLinks,'value',0);
    set(handles.tabReservoirs,'value',0);
    set(handles.tabTanks,'value',0);
    handles.c3=1;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in tabPatterns.
function handles=tabPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to tabPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabPatterns
if handles.loadFile==0 || handles.c4==1
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabPatterns,'value',0);
        return;
    end
end
    set(handles.Uncertainty2,'Visible','on');
    set(handles.equations,'Visible','off');

    set(handles.Table,'Visible','off');
    set(handles.tabPatterns,'value',1);

    set(handles.VarianceP,'Visible','on');
    set(handles.text14,'Visible','on');
    set(handles.text16,'Visible','on');
    set(handles.FlowPrcPatterns,'Visible','on');
    set(handles.FlowSamplesPatterns,'Visible','on');
    set(handles.Uncertainty,'Visible','off');

    if handles.PatternTCount
        % Patterns
        set(handles.FlowPrcPatterns,'String',handles.P.FlowPrc(6));
        set(handles.FlowSamplesPatterns,'String',handles.P.FlowSamples(6));
    else
        % Patterns
        set(handles.FlowPrcPatterns,'String',0);
        set(handles.FlowSamplesPatterns,'String',1);
        handles.PatternTCount=1;
    end
    set(handles.tabNodes,'value',0);
    set(handles.tabLinks,'value',0);    
    set(handles.tabPipesTanks,'value',0);
    set(handles.tabReservoirs,'value',0);
    set(handles.tabTanks,'value',0);
    handles.c4=1;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in tabReservoirs.
function handles=tabReservoirs_Callback(hObject, eventdata, handles)
% hObject    handle to tabReservoirs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabReservoirs
if handles.loadFile==0 || handles.c5==1
    [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabReservoirs,'value',0);
        return;
    end
end
    set(handles.equations,'Visible','off');

    set(handles.Table,'ColumnWidth',{100})
    set(handles.Table,'position',[1.8 0.769230769230769 150 16.5384615384615]);

    set(handles.Uncertainty2,'Visible','off');
    set(handles.VarianceP,'Visible','off');
    set(handles.text14,'Visible','off');
    set(handles.text16,'Visible','off');
    set(handles.FlowPrcPatterns,'Visible','off');
    set(handles.FlowSamplesPatterns,'Visible','off');

    set(handles.tabNodes,'value',0);
    set(handles.tabPatterns,'value',0);
    set(handles.tabLinks,'value',0);
    set(handles.tabReservoirs,'value',1);
    set(handles.tabTanks,'value',0);
    set(handles.tabPipesTanks,'value',0);
    set(handles.Uncertainty,'Visible','off');

    set(handles.Table,'Visible','on');
    set(handles.Table,'data',[]);
  
    % Reservoirs
    if handles.ReservoirTableCount
        set(handles.Table,'data',handles.ReservoirTable);
    else
        handles.ReservoirTable=zeros(handles.Ps.B.NodeReservoirCount,handles.Ps.B.MSXSpeciesCount-1);
        for i=1:handles.Ps.B.NodeReservoirCount
            handles.ReservoirTable(i,1)=handles.P.QualityNodeRes(i,1);
            handles.ReservoirTable(i,2)=handles.P.QualityNodeRes(i,2);
            handles.ReservoirTable(i,3)=handles.P.QualityNodeRes(i,3);
        end
        set(handles.Table,'data',handles.ReservoirTable);
        handles.ReservoirTableCount=1;
    end
    ReservoirTableColumnName(1,1:handles.Ps.B.NodeReservoirCount)=handles.Ps.B.NodeNameID(handles.Ps.B.NodeReservoirIndex);
    set(handles.Table, 'RowName', ReservoirTableColumnName);
    
    for u=1:handles.Ps.B.MSXSpeciesCount
        if u==1%water age
            spUnits{u}=[handles.Ps.B.MSXSpeciesNameID{u},'(Hrs)'];
        else
            spUnits{u}=[handles.Ps.B.MSXSpeciesNameID{u},'(',handles.Ps.B.MSXSpeciesUnits{u},'/L)'];
        end
    end
   
    set(handles.Table,'ColumnName',char(spUnits(2:end)));
  
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:handles.Ps.B.MSXSpeciesCount
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.Table,'ColumnEditable',str2num(ColumnEditable));
 
    if handles.Ps.B.NodeReservoirCount==0 
        ReservoirTable=[];
        set(handles.Table,'data',ReservoirTable);
        set(handles.Table,'ColumnName',{'Reservoirs'});
        ReservoirTable{1,1}=char('There are not reservoirs.'); 
        set(handles.Table,'ColumnWidth',{140});
        set(handles.Table,'ColumnEditable',false);
        set(handles.Table,'data',ReservoirTable);
    end
    handles.c5=1;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in tabTanks.
function handles=tabTanks_Callback(hObject, eventdata, handles)
% hObject    handle to tabTanks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tabTanks
if handles.loadFile==0 || handles.c6==1
   errorCode = CheckForErrorInTabs(hObject, eventdata, handles);
    if errorCode
        set(handles.tabTanks,'value',0);
        return;
    end
end
    set(handles.Uncertainty2,'Visible','off');
    set(handles.VarianceP,'Visible','off');
    set(handles.text14,'Visible','off');
    set(handles.text16,'Visible','off');
    set(handles.FlowPrcPatterns,'Visible','off');
    set(handles.FlowSamplesPatterns,'Visible','off');
    set(handles.equations,'Visible','off');
    set(handles.Table,'ColumnWidth',{100})
    set(handles.Table,'position',[1.8 0.769230769230769 150 16.5384615384615]);
    
    set(handles.tabNodes,'value',0);
    set(handles.tabPatterns,'value',0);
    set(handles.tabLinks,'value',0);
    set(handles.tabReservoirs,'value',0);
    set(handles.tabTanks,'value',1);
    set(handles.tabPipesTanks,'value',0);
    set(handles.Uncertainty,'Visible','off');

    set(handles.Table,'Visible','on');
    set(handles.Table,'data',[]);
    
    TankTableColumnName(1,1:handles.Ps.B.NodeTankCount)=handles.Ps.B.NodeNameID(handles.Ps.B.NodeTankIndex);
    set(handles.Table, 'RowName', TankTableColumnName);
    set(handles.Table,'ColumnName',{'Chlorine(MG/L)'});
  
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:handles.Ps.B.NodeTankCount 
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.Table,'ColumnEditable',str2num(ColumnEditable));


    if handles.TankTableCount
        set(handles.Table,'data',handles.TankTable);
    else
        handles.TankTable=zeros(handles.Ps.B.NodeTankCount,1);
        for i=1:handles.Ps.B.NodeTankCount
            handles.TankTable(i,1)=handles.P.QualityNodeTank(i,1);
        end
        set(handles.Table,'data',handles.TankTable);
        handles.TankTableCount=1;
    end

    if handles.Ps.B.NodeTankCount==0, 
        TankTable=[];
        set(handles.Table,'data',TankTable);
        set(handles.Table,'ColumnName',{'Tanks'});
        TankTable{1,1}=char('There are not tanks.'); 
        set(handles.Table,'ColumnWidth',{100});
        set(handles.Table,'ColumnEditable',false);
        set(handles.Table,'data',TankTable);
    end
    handles.c6=1;

% Update handles structure
guidata(hObject, handles);


function parameterV1_Callback(hObject, eventdata, handles)
% hObject    handle to parameterV1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterV1 as text
%        str2double(get(hObject,'String')) returns contents of parameterV1 as a double


% --- Executes during object creation, after setting all properties.
function parameterV1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterV1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameterS1_Callback(hObject, eventdata, handles)
% hObject    handle to parameterS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterS1 as text
%        str2double(get(hObject,'String')) returns contents of parameterS1 as a double


% --- Executes during object creation, after setting all properties.
function parameterS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameterV2_Callback(hObject, eventdata, handles)
% hObject    handle to parameterV2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterV2 as text
%        str2double(get(hObject,'String')) returns contents of parameterV2 as a double


% --- Executes during object creation, after setting all properties.
function parameterV2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterV2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameterS2_Callback(hObject, eventdata, handles)
% hObject    handle to parameterS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterS2 as text
%        str2double(get(hObject,'String')) returns contents of parameterS2 as a double


% --- Executes during object creation, after setting all properties.
function parameterS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameterV3_Callback(hObject, eventdata, handles)
% hObject    handle to parameterV3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterV3 as text
%        str2double(get(hObject,'String')) returns contents of parameterV3 as a double


% --- Executes during object creation, after setting all properties.
function parameterV3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterV3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameterS3_Callback(hObject, eventdata, handles)
% hObject    handle to parameterS3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameterS3 as text
%        str2double(get(hObject,'String')) returns contents of parameterS3 as a double


% --- Executes during object creation, after setting all properties.
function parameterS3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterS3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [errorCode,handles] = CheckForErrorInTabs(hObject, eventdata, handles)
    errorCode=0;

    parameterV1=str2num(char(get(handles.parameterV1, 'String')));
    T1=(char(get(handles.textp1, 'String')));
    if ~length(parameterV1) || parameterV1<0
        str=['     Give percent of ',T1(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end
    
    parameterV2=str2num(char(get(handles.parameterV2, 'String')));
    T2=(char(get(handles.textp2, 'String')));
    if ~length(parameterV2) || parameterV2<0
        str=['     Give percent of ',T2(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end

    parameterS1=str2num(char(get(handles.parameterS1, 'String')));
    S1=(char(get(handles.textp1, 'String')));
    if ~length(parameterS1) || parameterS1<0
        str=['     Give Samples of ',S1(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end

    parameterS2=str2num(char(get(handles.parameterS2, 'String')));
    S2=(char(get(handles.textp2, 'String')));
    if ~length(parameterS2) || parameterS2<0
        str=['     Give Samples of ',S2(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end
    
    
    parameterV3=str2num(char(get(handles.parameterV3, 'String')));
    T3=(char(get(handles.textp3, 'String')));
    if ~length(parameterV3) || parameterV3<0
        str=['     Give percent of ',T3(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end

    parameterS3=str2num(char(get(handles.parameterS3, 'String')));
    S3=(char(get(handles.textp3, 'String')));
    if ~length(parameterS3) || parameterS3<0
        str=['     Give Samples of ',S3(1:end-1),'.'];
        msgbox(str, 'Error', 'modal')
        errorCode=1;
        return
    end
    
    FlowPrcPatterns=(str2double(get(handles.FlowPrcPatterns, 'String')));
    if isnan(FlowPrcPatterns) || FlowPrcPatterns<0
        msgbox('    Give percent of Patterns', 'Error', 'modal')
        errorCode=1;
        return
    end

    FlowSamplesPatterns=str2num(char(get(handles.FlowSamplesPatterns, 'String')));
    if ~length(FlowSamplesPatterns) || FlowSamplesPatterns<0
        msgbox('     Give Samples of Pattern', 'Error', 'modal')
        errorCode=1;
        return
    end
    
    handles.P.FlowPrc{6}=FlowPrcPatterns;
    handles.P.FlowSamples{6}=FlowSamplesPatterns;
    
    if strcmp('ELEV',upper(T1(1:4)))
        handles.P.FlowPrc{4}=parameterV1;
        handles.P.FlowSamples{4}=parameterS1;
    end
    if strcmp('BASE',upper(T2(1:4)))
        handles.P.FlowPrc{5}=parameterV2;
        handles.P.FlowSamples{5}=parameterS2;
    end
    if strcmp('DIAM',upper(T1(1:4)))
        handles.P.FlowPrc{1}=parameterV1;
        handles.P.FlowSamples{1}=parameterS1;
    end
    if strcmp('LENG',upper(T2(1:4)))
        handles.P.FlowSamples{2}=parameterS2;
        handles.P.FlowPrc{2}=parameterV2;
    end
    if strcmp('ROUG',upper(T3(1:4)))
        handles.P.FlowPrc{3}=parameterV3;
        handles.P.FlowSamples{3}=parameterS3;
    end
    
% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in equations.
function equations_Callback(hObject, eventdata, handles)
% hObject    handle to equations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns equations contents as cell array
%        contents{get(hObject,'Value')} returns selected item from equations


% --- Executes during object creation, after setting all properties.
function equations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
