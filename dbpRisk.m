function varargout = dbpRisk(varargin)
% DBPRISK MATLAB code for dbpRisk.fig
%      DBPRISK, by itself, creates a new DBPRISK or raises the existing
%      singleton*.
%
%      H = DBPRISK returns the handle to a new DBPRISK or the handle to
%      the existing singleton*.
%
%      DBPRISK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DBPRISK.M with the given input arguments.
%
%      DBPRISK('Property','Value',...) creates a new DBPRISK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dbpRisk_OpeningFcn gets callehandles.B.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dbpRisk_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dbpRisk

% Last Modified by GUIDE v2.5 13-Mar-2018 19:09:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dbpRisk_OpeningFcn, ...
                   'gui_OutputFcn',  @dbpRisk_OutputFcn, ...
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


% --- Executes just before dbpRisk is made visible.
function dbpRisk_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dbpRisk (see VARARGIN)

% Choose default command line output for dbpRisk
handles.output = hObject;

% handles.panelposition=get(handles.text22,'position');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dbpRisk wait for user response (see UIRESUME)
% uiwait(handles.figure1);

opening(hObject, eventdata, handles)

function opening(hObject, eventdata, handles)
    try
    close(findobj('type','figure','name','Results'));
    close(findobj('type','figure','name','Setup Analysis'));
    catch err
    end
    sfilesexist = dir('s*'); 
    if (~isempty(sfilesexist)), delete s*, end
    set(handles.Run,'str','Run');
    set(handles.Run,'enable','on');
    
    handles.MapOn=0;
    handles.Count=0;
    handles.countRun=0;
    set(handles.LoadInpFile,'enable','on');

    set(handles.figure1,'name','dbpRisk');
    try
        delete(handles.dataplots);
    catch err
    end
    try
        delete(handles.previousg);
    catch err
    end
    try
        delete(handles.logo); 
    catch err
    end
    handles.dataplots=[];
    handles.file=[];
    path(path,genpath(pwd)); % Set current folder and subfolders in PATH
    g=axes('Parent',handles.axes1);
    handles.logo=imshow([pwd,'\MISC/dbpRisk.png'],'Parent',g);


    set(handles.SaveNetwork,'visible','off');
    set(handles.Zoom,'visible','off');
    set(handles.pan,'visible','off');
    set(handles.NodesID,'visible','off');
    set(handles.LinksID,'visible','off');
    set(handles.FontsizeENplotText,'visible','off');
    set(handles.FontsizeENplot,'visible','off');
    set(handles.hide,'visible','on');
    set(handles.flowUnits,'visible','off');
    
    set(handles.Map,'visible','off');
    set(handles.SetupAnalysis,'enable','off');
    set(handles.Run,'enable','off');
    set(handles.LoadData,'enable','off');
    set(handles.Results,'enable','off');
    set(handles.s1,'enable','off');
    set(handles.s2,'enable','off');
    set(handles.s3,'enable','off');
    set(handles.s4,'enable','off');
    set(handles.none,'enable','off');
    set(handles.text20,'enable','off');
    
    set(handles.s1,'String','WaterAge');
    set(handles.s2,'String','Chlorine');
    set(handles.s3,'String','THMs');
    set(handles.s4,'String','TOC');   
    set(handles.s1,'Value',1);
    set(handles.s2,'Value',0);
    set(handles.s3,'Value',0);
    set(handles.s4,'Value',0);
    set(handles.none,'Value',0);

    set(handles.Tbar,'visible','off');

    set(handles.LoadText,'Value',1); 
    set(handles.LoadText,'String','Please Load Input File.');
    % Update handles structure
guidata(hObject, handles);
    % --- Outputs from this function are returned to the command line.
function varargout = dbpRisk_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadInpFile.
function LoadInpFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadInpFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
   warning off;
   [InputFile,PathFile] = uigetfile('NETWORKS\*.inp');
    if InputFile~=0
        if libisloaded('epanet2')
           unloadlibrary('epanet2');
        end
        handles.file=[];
%         try
%         close(findobj('type','figure','name','Results'));
%         close(findobj('type','figure','name','Setup Analysis'));
%         catch err
%         end
        set(handles.LoadInpFile,'enable','inactive');
%         set(handles.Run,'enable','inactive');
%         set(handles.Results,'enable','inactive');
        set(handles.s1,'enable','inactive');
        set(handles.s2,'enable','inactive');
        set(handles.s3,'enable','inactive');
        set(handles.s4,'enable','inactive');
        set(handles.none,'enable','inactive');
        set(handles.Map,'enable','inactive');
    
        col = get(handles.LoadInpFile,'backg');  % Get the background color of the figure.
        set(handles.LoadInpFile,'str','LOADING...');
        pause(.1);
        % Load Input File
        B=epanet(InputFile); %clc;
        handles.B = B;
        if B.Errcode~=0 
            s = sprintf('Could not open network ''%s'', please insert the correct filename(*.inp).\n',InputFile); 
            set(handles.LoadText,'String',s);
            set(handles.LoadInpFile,'str','Load Input File','backg',col);
            return
        end

        if exist([pwd,'\RESULTS\','temp2.msx'])==2
            delete([pwd,'\RESULTS\','temp2.msx']);
        end
        if exist([pwd,'\RESULTS\','temp2.inp'])==2
            delete([pwd,'\RESULTS\','temp2.inp']);
        end       
        if exist([pwd,'\RESULTS\','Run.0'])==2
            delete([pwd,'\RESULTS\','Run.0']);
        end   
        if ~isempty(findobj('Tag','Colorbar')),delete(findobj('Tag','Colorbar'));end
        if ~isempty(findobj('Tag','legend')),delete(findobj('Tag','legend'));end
        handles.msg=['>>Load Input File "',InputFile,'" Successful.'];
        Gethandles.msg=['>>Current version of EPANET:',num2str(B.Version)];
        handles.msg=[handles.msg;{Gethandles.msg}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
        if handles.Count==1
            cla(handles.previousg)
            handles.previousg=axes('Parent',handles.axes1);
            ENplotB(handles,'axes',handles.previousg);  
        else
            handles.previousg=axes('Parent',handles.axes1);
            ENplotB(handles,'axes',handles.previousg);
        end
        set(handles.axes1,'HighlightColor','k')
        save([pwd,'\RESULTS\','map.1'],'handles','-mat');    
    
        if handles.B.NodeCoordinates{2}(1)<85 && handles.B.NodeCoordinates{2}(1)>-85 ...
        && handles.B.NodeCoordinates{1}(1)<180 && handles.B.NodeCoordinates{1}(1)>-180
            set(handles.Map,'Visible','on');    
            set(handles.Map,'String','Map');    
        else
            set(handles.Map,'Visible','off');    
        end

        % graphs
%         handles=movegraphs(handles,0);
%         set(handles.axes1,'position', [50.2000 3.0000 120.2000 43.1538]);
        set(handles.NodesID,'value',0);
        set(handles.LinksID,'value',0);
        set(handles.FontsizeENplot,'String',12);
        set(handles.SaveNetwork,'visible','on');
        set(handles.Zoom,'visible','on');
        set(handles.pan,'visible','on');
        set(handles.NodesID,'visible','on');
        set(handles.LinksID,'visible','on');  
        set(handles.FontsizeENplot,'visible','on');
        set(handles.FontsizeENplotText,'visible','on');   
        set(handles.flowUnits,'visible','on');
        set(handles.flowUnits,'string',['Flow Units: ',char(handles.B.LinkFlowUnits)]);

        handles.B.loadMSXFile(['Simulator.msx']); clc;
        set(handles.s1,'String',handles.B.MSXSpeciesNameID(1));
        set(handles.s2,'String',handles.B.MSXSpeciesNameID(2));
        set(handles.s3,'String',handles.B.MSXSpeciesNameID(3));
        set(handles.s4,'String',handles.B.MSXSpeciesNameID(4));
        set(handles.hide,'visible','off');

        handles.Count=1;
        handles.countRun=0;
        handles.EndTime=48;
        handles.B.setTimeSimulationDuration(handles.EndTime*3600);
        set(handles.LoadInpFile,'str','Load Input File','backg',col)  % Now reset the button features.
        
        set(handles.Map,'enable','on');
        set(handles.Run,'enable','off');
        set(handles.LoadData,'enable','off');
        set(handles.Results,'enable','off');
        set(handles.s1,'enable','off');
        set(handles.s2,'enable','off');
        set(handles.s3,'enable','off');
        set(handles.s4,'enable','off');
        set(handles.none,'enable','off');
        set(handles.text20,'enable','off');
        set(handles.LoadData,'enable','off');
        try
            delete(handles.logo);
        catch err
        end
        guidata(hObject, handles);
        set(handles.Tbar,'visible','off');
        set(handles.SetupAnalysis,'enable','inactive');
        set(handles.SetupAnalysis,'enable','on');
 %         if ~findobj('type','figure','name','SetupAnalysis')
%             close(findobj('type','figure','name','SetupAnalysis'))
%         end
    end
    set(handles.LoadInpFile,'enable','on');

% --- Executes on button press in Zoom.
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str = get(handles.Zoom,'String');
    set(handles.pan,'String','Pan');
    
%     if strcmp('Map',get(handles.Map,'String')) 
%         handles.MapOn=0;
%     else strcmp('Reset',get(handles.Map,'String')) 
%         handles.MapOn=1;
%     end
    if strcmp('Zoom',str) 
        try
        zoom on;
        catch err;
        end
        set(handles.Zoom,'String','Reset');
        % History
        y=['>>','Zoom',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
    end
    if strcmp('Reset',str)
        for i=1:2
        try
        zoom off;
        zoom out;
        zoom reset;
        catch err;
        end
        end
        font(hObject, eventdata, handles,1);  
        % History
        y=['>>','Reset',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
        set(handles.Zoom,'String','Zoom');
%         set(handles.Tbar,'visible','off');
    end
    % Update handles structure
    guidata(hObject, handles);
%             save([pwd,'\RESULTS\','map.1'],'handles','-mat');  
    % --- Executes on button press in LinksIhandles.B.
function LinksID_Callback(hObject, eventdata, handles)
% hObject    handle to LinksID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LinksID
    delete(findall(handles.axes1,'Type','text'))    
    value=get(handles.LinksID,'Value');
    FontSize = str2num(get(handles.FontsizeENplot,'String'));
    if ~length(FontSize) || FontSize<0 || FontSize>30 || FontSize==0
        handles.msg=[handles.msg;{'>>Font Size(max 30).'}];
        set(handles.LoadText,'String',handles.msg);
        set(handles.LoadText,'Value',length(handles.msg));
        set(handles.FontsizeENplot,'String','12');
        FontSize=12;
    end
    
    if value==1
        set(handles.NodesID,'Value',0);
        for i=1:handles.B.LinkCount
            x1=handles.B.NodeCoordinates{1}(handles.B.NodesConnectingLinksIndex(i,1));
            y1=handles.B.NodeCoordinates{2}(handles.B.NodesConnectingLinksIndex(i,1));
            x2=handles.B.NodeCoordinates{1}(handles.B.NodesConnectingLinksIndex(i,2));
            y2=handles.B.NodeCoordinates{2}(handles.B.NodesConnectingLinksIndex(i,2));
            hLinksID(i)=text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'FontSize',FontSize);
        end
    end
    
    guidata(hObject, handles);

% --- Executes on button press in NodesIhandles.B.
function NodesID_Callback(hObject, eventdata, handles)
% hObject    handle to NodesID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NodesID
    delete(findall(handles.axes1,'Type','text'))
    value=get(handles.NodesID,'Value');
    FontSize = str2num(get(handles.FontsizeENplot,'String'));
    if  ~length(FontSize) || FontSize<0 || FontSize>30 || FontSize==0
        handles.msg=[handles.msg;{'>>Font Size(max 30).'}];
        set(handles.LoadText,'String',handles.msg);
        set(handles.LoadText,'Value',length(handles.msg));
        set(handles.FontsizeENplot,'String','12');
        FontSize=12;
    end
    
    if value==1 
        set(handles.LinksID,'Value',0);
        for i=1:handles.B.NodeCount
            hNodesID(i)=text(handles.B.NodeCoordinates{1}(i),handles.B.NodeCoordinates{2}(i),char(handles.B.NodeNameID(i)),'FontSize',FontSize,'Tag','Task String');
        end
    end
    
    guidata(hObject, handles);


function FontsizeENplot_Callback(hObject, eventdata, handles)
% hObject    handle to FontsizeENplotText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FontsizeENplotText as text
%        str2double(get(hObject,'String')) returns contents of FontsizeENplotText as a double
    if get(handles.NodesID,'Value')
        NodesID_Callback(hObject, eventdata, handles);
    elseif get(handles.LinksID,'Value')
        LinksID_Callback(hObject, eventdata, handles);
    end

% --- Executes during object creation, after setting all properties.
function FontsizeENplotText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FontsizeENplotText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveNetwork.
function SaveNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to SaveNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     set(handles.SaveNetwork,'visible','off');
%     set(handles.Zoom,'visible','off');
%     set(handles.NodesID,'visible','off');
%     set(handles.LinksID,'visible','off');
%     set(handles.FontsizeENplotText,'visible','off');
%     set(handles.FontsizeENplot,'visible','off');
%     set(handles.pan,'visible','off');

    prompt={'Enter the file name:'};
    answer=inputdlg(prompt);
    
    if ~isempty(answer)
        answer=char(answer);
        f=getframe(handles.figure1);
        imwrite(f.cdata,[answer,'.png'],'png');
        figure(1);
        imshow([answer,'.png']);
        % save to pdf and bmp
        %print(gcf,'-dpdf',answer,sprintf('-r%d',150));
        try
            winopen([answer,'.png'])
        catch e
        end
        close(1);   
    end
% --- Executes on button press in pan.
function pan_Callback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str = get(handles.pan,'String');
    set(handles.Zoom,'String','Zoom');
    
    if strcmp('Pan',str) 
        try
        pan on;
        catch err
        end
        handles.PanIO=0;
        set(handles.pan,'String','Reset');
        % History
        y=['>>','Pan',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
    end
    if strcmp('Reset',str)
        try
        zoom out;
        zoom reset;
        pan off;
        catch err
        end
        font(hObject, eventdata, handles,1);
%         ENplotB('axes',handles.previousg);  
        % History
        y=['>>','Reset',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
        set(handles.pan,'String','Pan');
        handles.PanIO=1;
%         set(handles.Tbar,'visible','off');
    end

    % Update handles structure
    guidata(hObject, handles);


% --- Executes on selection change in LoadText.
function LoadText_Callback(hObject, eventdata, handles)
% hObject    handle to LoadText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LoadText contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LoadText


% --- Executes during object creation, after setting all properties.
function LoadText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Map.
function Map_Callback(hObject, eventdata, handles)
% hObject    handle to Map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if exist([pwd,'\RESULTS\','Run.0'])==2
%     set(handles.Run,'enable','inactive');
%     set(handles.LoadData,'enable','inactive');
%     set(handles.SetupAnalysis,'enable','inactive');
%     set(handles.Results,'enable','inactive');
%     set(handles.LoadInpFile,'enable','inactive');
%     set(handles.s1,'enable','inactive');
%     set(handles.s2,'enable','inactive');
%     set(handles.s3,'enable','inactive');
%     set(handles.s4,'enable','inactive');
%     set(handles.none,'enable','inactive');
% end
    str = get(handles.Map,'String');

    if strcmp('Map',str) 
        col = get(handles.Map,'backg');
        set(handles.Map,'str','Loading..')          

        if handles.B.NodeCoordinates{2}(1)<85 && handles.B.NodeCoordinates{2}(1)>-85 ...
                && handles.B.NodeCoordinates{1}(1)<180 && handles.B.NodeCoordinates{1}(1)>-180
            handles.MapOn=0;               
            save([pwd,'\RESULTS\','map.1'],'handles','-mat');  
            hold on;
            [unused,flag] = urlread('http://ucy.ac.cy');
            if flag==1
                handles.MapOFF=plot_google_map(handles);

                % Update handles structure
                guidata(hObject, handles);
            else
                warndlg('Check internet connection status.','Map')
                set(handles.Map,'str','Map','backg',col);
                return
            end
        else
            warndlg('Coordinates is not wgs84.','Map');
        end
        box on;
        set(handles.Map,'str','Map','backg',col);
        set(handles.Map,'String','Reset');
    end
    if strcmp('Reset',str)
        col = get(handles.Map,'backg');
        set(handles.Map,'str','Loading..')        
        handles.MapOn=1;               
        save([pwd,'\RESULTS\','map.1'],'handles','-mat');  
        hold on;
        [unused,flag] = urlread('http://ucy.ac.cy');
        if flag==1
            handles.MapOFF=plot_google_map(handles);

            % Update handles structure
            guidata(hObject, handles);
        else
            warndlg('Check internet connection status.','Map')
            set(handles.Map,'str','Map','backg',col);
        return
        end
        delete(handles.MapOFF);  
        box on;
        set(handles.Map,'str','Reset','backg',col);
        set(handles.Map,'String','Map');
    end
    

    % Update handles structure
    guidata(hObject, handles);
% if exist([pwd,'\RESULTS\','Run.0'])==2
%     set(handles.Run,'enable','on');
%     set(handles.LoadData,'enable','on');
%     set(handles.SetupAnalysis,'enable','on');
%     set(handles.Results,'enable','on');
%     set(handles.LoadInpFile,'enable','on');
%     set(handles.s1,'enable','on');
%     set(handles.s2,'enable','on');
%     set(handles.s3,'enable','on');
%     set(handles.s4,'enable','on');
%     set(handles.none,'enable','on');
% end
% --- Executes during object creation, after setting all properties.
function FontsizeENplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FontsizeENplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SpeciesResults(handles)


% --- Executes on button press in SelectSub.
function SelectSub_Callback(hObject, eventdata, handles)
% hObject    handle to SelectSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SelectSub


% --- Executes on button press in s1.
function s1_Callback(hObject, eventdata, handles)
% hObject    handle to s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s1
    set(handles.s1,'Value',1);
    set(handles.s2,'Value',0);
    set(handles.s3,'Value',0);
    set(handles.s4,'Value',0);
    set(handles.none,'Value',0);

    if handles.countRun==1
        handles.speciesInd=1;
        handles=colorM(hObject, eventdata, handles,1);
        guidata(hObject, handles);
    end
% --- Executes on button press in s2.
function s2_Callback(hObject, eventdata, handles)
% hObject    handle to s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s2

    set(handles.s1,'Value',0);
    set(handles.s2,'Value',1);
    set(handles.s3,'Value',0);
    set(handles.s4,'Value',0);
    set(handles.none,'Value',0);
    
    if handles.countRun==1
        handles.speciesInd=2;
        handles=colorM(hObject, eventdata, handles,1);
        guidata(hObject, handles);
    end
      
        % --- Executes on button press in s3.
function s3_Callback(hObject, eventdata, handles)
% hObject    handle to s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s3
    set(handles.s1,'Value',0);
    set(handles.s2,'Value',0);
    set(handles.s3,'Value',1);
    set(handles.s4,'Value',0);
    set(handles.none,'Value',0);
    
    if handles.countRun==1
        handles.speciesInd=3;
        handles=colorM(hObject, eventdata, handles,1);
        guidata(hObject, handles);
    end
      
% --- Executes on button press in s4.
function s4_Callback(hObject, eventdata, handles)
% hObject    handle to s4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s4
    set(handles.s1,'Value',0);
    set(handles.s2,'Value',0);
    set(handles.s3,'Value',0);
    set(handles.s4,'Value',1);
    set(handles.none,'Value',0);
    if handles.countRun==1
        handles.speciesInd=4;
        handles=colorM(hObject, eventdata, handles,1);
        guidata(hObject, handles);
    end
      % --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(handles.Map,'String'), 'Reset')
        warndlg('Please reset map.','Run')
        return
    end
    close(findobj('type','figure','name','Results'));

    handles.col = get(handles.Run,'backg');  % Get the background color of the figure.
    set(handles.Run,'str','Running...');pause(.1);
    set(handles.Run,'enable','inactive');
%     set(handles.LoadData,'enable','inactive');
    set(handles.SetupAnalysis,'enable','inactive');
    set(handles.Results,'enable','inactive');
    set(handles.LoadInpFile,'enable','inactive');
    set(handles.s1,'enable','inactive');
    set(handles.s2,'enable','inactive');
    set(handles.s3,'enable','inactive');
    set(handles.s4,'enable','inactive');
    set(handles.none,'enable','inactive');
    
    handles.msg=get(handles.LoadText,'String');
    
    species=[get(handles.s1,'Value') get(handles.s2,'Value') get(handles.s3,'Value') get(handles.s4,'Value')];
    handles.speciesInd=find(species==1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([pwd,'\RESULTS\','Run.0'],'P','B','-mat');
    B.setTimeHydraulicStep(3600);   
    B.setTimeQualityStep(3600);
    
    B.setTimeSimulationDuration(P.EndTime*3600);
    for i=1:size(P.ScenariosFlowIndex,1)
%         i=1;
        B.setLinkDiameter(P.FlowParamScenarios{1}(:, 1)');
        B.setLinkLength(P.FlowParamScenarios{2}(:, 1)');
        B.setLinkRoughnessCoeff(P.FlowParamScenarios{3}(:,1)');
        B.setNodeElevations(P.FlowParamScenarios{4}(:, 1)');
        B.setNodeBaseDemands(P.FlowParamScenarios{5}(:, 1)');
        if ~isempty(P.FlowValues{6})
            if size(P.Patterns,1)==1
                B.setPatternMatrix(P.FlowParamScenarios{6}(:,1)');
            else
                B.setPatternMatrix(P.FlowParamScenarios{6}(:,1)');
            end
        end
        
        values1=B.getMsxNodeInitqualValue;
        % Reservoirs
        u=1;
        for k=B.NodeReservoirIndex
%             if u==2 % chlorine mg/L
%                 values1{k}(2:end)=P.QualityNodeRes(u,:)*0.001;
%             elseif u==3 % thms ?g/L
%                 values1{k}(2:end)=P.QualityNodeRes(u,:)*0.000001;
%             else
                values1{k}(2:end)=P.QualityNodeRes(u,:);
%             end
            u=u+1;
        end

        
        % Tanks
        u=1;
        for k=B.NodeTankIndex
%             if u==2 % chlorine mg/L
%                 values1{k}(2)=P.QualityNodeTank(u,:)*0.001;
%             elseif u==3
%                 values1{k}(2)=P.QualityNodeTank(u,:)*0.000001;
%             else
                values1{k}(2)=P.QualityNodeTank(u,:);
%             end
            u=u+1;
        end
        B.setMsxNodeInitqualValue(values1);

        values2=B.getMsxParametersPipesValue;
        for p=1:B.LinkCount
        t=7;
            if p<B.LinkPipeCount || p==B.LinkPipeCount
                for u=1:B.MsxParametersCount
                    values2{p}(u)=P.FlowParamScenarios{t}(u)';
                    B.setMsxParametersPipesValue(p,values2{p});
                    t=t+1;
                end
            end
        end

        for p=B.LinkPipeCount+1:B.NodeTankCount+handles.B.LinkPipeCount
            t=7;
            for u=1:B.MsxParametersCount
                values2{p}(u)=P.FlowParamScenarios{7}(u)';
                B.setMsxParametersTanksValue(i,values2{p});
                t=t+1;
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if get(handles.none,'Value')
        ENplotB(handles,'axes',handles.previousg);  
        % History
        y=['>>','None',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
        set(handles.s1,'enable','on');
        set(handles.s2,'enable','on');
        set(handles.s3,'enable','on');
        set(handles.s4,'enable','on');
        set(handles.none,'enable','on');
        set(handles.Run,'enable','on');
        % Update handles structure
        guidata(hObject, handles);
        set(handles.Run,'str','Run','backg',handles.col)  % Now reset the button features.
        return;
    end
        handles.P=P;
        handles.B=B;
    % MSX
    B.saveInputFile('temp2.inp');
    copyfile('temp2.inp',[pwd,'\RESULTS\temp.inp']);
    movefile('temp2.inp',[pwd,'\RESULTS\temp2.inp']);
    B.LoadInpFile([pwd,'\RESULTS\temp.inp'],[pwd,'\RESULTS\temp.txt'], [pwd,'\RESULTS\temp.out']);
    %profile on
    CompQualityNodesAge=0;
    CompQualityNodesTHMs=0;
    CompQualityNodesChlorine=0;
    CompQualityNodesTOC=0;
    CompQualityLinksAge=0;
    CompQualityLinksChlorine=0;
    CompQualityLinksTHMs=0;
    CompQualityLinksTOC=0;

    format long g;%tic

    B.MsxSolveCompleteHydraulics();
    handles.Progress_Percentage=0.0;
    h=waitbar(0,['Initializing waitbar ',num2str(0),'%'],'Name','Running...');
    if B.NodeCount>B.LinkCount || B.NodeCount==B.LinkCount
        k=2;tleft=1;
        handles.B.NodeCount=double(B.NodeCount);
        % Obtain a MSX step-wise quality solution
        B.MsxInitializeQualityAnalysis(0);
        while(tleft>0 && B.Errcode==0)
            [t, tleft]=B.MsxStepQualityAnalysisTimeLeft();
            for i=1:(B.NodeCount)
                if k==2
                    CompQualityNodesAge(1,i)=B.MsxNodeInitqualValue{i}(1);%age
                    CompQualityNodesChlorine(1,i)=B.MsxNodeInitqualValue{i}(2);%chlorine
                    CompQualityNodesTHMs(1,i)=B.MsxNodeInitqualValue{i}(3);%thms
                    CompQualityNodesTOC(1,i)=B.MsxNodeInitqualValue{i}(4);%TOC
                    if i<B.LinkCount+1
                        CompQualityLinksAge(1,i)=B.MsxLinkInitqualValue{i}(1);%age
                        CompQualityLinksChlorine(1,i)=B.MsxLinkInitqualValue{i}(2);%chlorine            
                        CompQualityLinksTHMs(1,i)=B.MsxLinkInitqualValue{i}(3);%thms   
                        CompQualityLinksTOC(1,i)=B.MsxLinkInitqualValue{i}(4);%TOC
                    end
                end

                handles.Time(k)=t; %end
                CompQualityNodesAge(k,i)=B.getMsxSpeciesConcentration(0,i,1);  
                CompQualityNodesChlorine(k,i)=B.getMsxSpeciesConcentration(0,i,2);  
                CompQualityNodesTHMs(k,i)=B.getMsxSpeciesConcentration(0,i,3);  
                CompQualityNodesTOC(k,i)=B.getMsxSpeciesConcentration(0,i,4);  
                if i<B.LinkCount+1
                    CompQualityLinksAge(k,i)=B.getMsxSpeciesConcentration(1,i,1);  
                    CompQualityLinksChlorine(k,i)=B.getMsxSpeciesConcentration(1,i,2);  
                    CompQualityLinksTHMs(k,i)=B.getMsxSpeciesConcentration(1,i,3);  
                    CompQualityLinksTOC(k,i)=B.getMsxSpeciesConcentration(1,i,4);  
                end
            end
            handles.Progress_Percentage=(k*handles.B.NodeCount)/((P.EndTime*3600/3600)*handles.B.NodeCount);
            if tleft==0 || handles.Progress_Percentage>1, handles.Progress_Percentage=1; end
            waitbar(handles.Progress_Percentage,h,sprintf('Overall Progress %d%%',floor(handles.Progress_Percentage*100)));
            k=k+1;
        end
    elseif B.NodeCount<B.LinkCount 
        k=2;tleft=1;
        % Obtain a MSX step-wise quality solution
        B.MsxInitializeQualityAnalysis(0);
        handles.B.LinkCount=double(B.LinkCount);
        while(tleft>0 && B.Errcode==0)
            [t, tleft]=B.MsxStepQualityAnalysisTimeLeft();
            if tleft~=0, handles.Time(k)=t; end   
            for i=1:B.LinkCount
                if k==2
                    CompQualityLinksAge(1,i)=B.MsxLinkInitqualValue{i}(1);%age
                    CompQualityLinksChlorine(1,i)=B.MsxLinkInitqualValue{i}(2);%chlorine            
                    CompQualityLinksTHMs(1,i)=B.MsxLinkInitqualValue{i}(3);%thms   
                    CompQualityLinksTOC(1,i)=B.MsxLinkInitqualValue{i}(4);%TOC
                    if i<B.NodeCount+1
                        CompQualityNodesAge(1,i)=B.MsxNodeInitqualValue{i}(1);%age
                        CompQualityNodesChlorine(1,i)=B.MsxNodeInitqualValue{i}(2);%chlorine
                        CompQualityNodesTHMs(1,i)=B.MsxNodeInitqualValue{i}(3);%thms
                        CompQualityNodesTOC(1,i)=B.MsxNodeInitqualValue{i}(4);%TOC
                    end
                end
                CompQualityLinksAge(k,i)=B.getMsxSpeciesConcentration(1,i,1);  
                CompQualityLinksChlorine(k,i)=B.getMsxSpeciesConcentration(1,i,2);  
                CompQualityLinksTHMs(k,i)=B.getMsxSpeciesConcentration(1,i,3);  
                CompQualityLinksTOC(k,i)=B.getMsxSpeciesConcentration(1,i,4);  
                if i<B.NodeCount+1  
                    CompQualityNodesAge(k,i)=B.getMsxSpeciesConcentration(0,i,1);  
                    CompQualityNodesChlorine(k,i)=B.getMsxSpeciesConcentration(0,i,2);  
                    CompQualityNodesTHMs(k,i)=B.getMsxSpeciesConcentration(0,i,3);  
                    CompQualityNodesTOC(k,i)=B.getMsxSpeciesConcentration(0,i,4); 
                end
            end
            handles.Progress_Percentage=(k*handles.B.LinkCount)/((P.EndTime*3600/3600)*handles.B.LinkCount);
            if tleft==0 || handles.Progress_Percentage>1, handles.Progress_Percentage=1; end
            waitbar(handles.Progress_Percentage,h,sprintf('Overall Progress %d%%',floor(handles.Progress_Percentage*100)));
            k=k+1;
        end
    end
handles.waitbar=h;
% Age
handles.CompQualityNodesAge=CompQualityNodesAge;  
handles.CompQualityNodesAgeAverage=mean(CompQualityNodesAge);  
handles.CompQualityNodesAgeMax=mean(CompQualityNodesAge);  
handles.CompQualityNodesAgeMin=mean(CompQualityNodesAge);  
handles.CompQualityLinksAge=CompQualityLinksAge;  
handles.CompQualityLinksAgeAverage=mean(CompQualityLinksAge);  
handles.CompQualityLinksAgeMax=max(CompQualityLinksAge);  
handles.CompQualityLinksAgeMin=min(CompQualityLinksAge);  

%Chlorine
handles.CompQualityNodesChlorine=CompQualityNodesChlorine;
handles.CompQualityNodesChlorineAverage=mean(CompQualityNodesChlorine);
handles.CompQualityNodesChlorineMax=max(CompQualityNodesChlorine);
handles.CompQualityNodesChlorineMin=min(CompQualityNodesChlorine);
handles.CompQualityLinksChlorine=CompQualityLinksChlorine;  
handles.CompQualityLinksChlorineAverage=mean(CompQualityLinksChlorine);  
handles.CompQualityLinksChlorineMax=max(CompQualityLinksChlorine);  
handles.CompQualityLinksChlorineMin=min(CompQualityLinksChlorine);  

%THMs
handles.CompQualityNodesTHMs=CompQualityNodesTHMs;
handles.CompQualityNodesTHMsAverage=mean(CompQualityNodesTHMs);
handles.CompQualityNodesTHMsMax=max(CompQualityNodesTHMs);
handles.CompQualityNodesTHMsMin=min(CompQualityNodesTHMs);
handles.CompQualityLinksTHMs=CompQualityLinksTHMs;  
handles.CompQualityLinksTHMsAverage=mean(CompQualityLinksTHMs);  
handles.CompQualityLinksTHMsMax=max(CompQualityLinksTHMs);  
handles.CompQualityLinksTHMsMin=min(CompQualityLinksTHMs); 

%TOC
handles.CompQualityNodesTOC=CompQualityNodesTOC;
handles.CompQualityNodesTOCAverage=mean(CompQualityNodesTOC);
handles.CompQualityNodesTOCMax=max(CompQualityNodesTOC);
handles.CompQualityNodesTOCMin=min(CompQualityNodesTOC);
handles.CompQualityLinksTOC=CompQualityLinksTOC;  
handles.CompQualityLinksTOCAverage=mean(CompQualityLinksTOC);  
handles.CompQualityLinksTOCMax=max(CompQualityLinksTOC);  
handles.CompQualityLinksTOCMin=min(CompQualityLinksTOC); 
%   profile viewer                      
    %% Plots 
  % Colormaps
% toc  
handles.countRun=1;
handles=colorM(hObject, eventdata, handles,0);
guidata(hObject, handles);
        


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in none.
function none_Callback(hObject, eventdata, handles)
% hObject    handle to none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of none
    set(handles.s1,'Value',0);
    set(handles.s2,'Value',0);
    set(handles.s3,'Value',0);
    set(handles.s4,'Value',0);
    set(handles.none,'Value',1);

    if get(handles.none,'Value')
        if ~isempty(findobj('Tag','Colorbar')),delete(findobj('Tag','Colorbar'));end
        font(hObject, eventdata, handles, 0)
        set(handles.Tbar,'visible','off');
        str=get(handles.Map,'String');
        cla(handles.previousg);
        if strcmp('Reset',str)
            if handles.B.NodeCoordinates{2}(1)<85 && handles.B.NodeCoordinates{2}(1)>-85 ...
                    && handles.B.NodeCoordinates{1}(1)<180 && handles.B.NodeCoordinates{1}(1)>-180
                hold on;
                handles.MapOFF=plot_google_map(handles);
            end
            box on;
%         else    
        end
        ENplotB(handles,'axes',handles.previousg);  
        % History
        y=['>>','None',' Selected'];
        handles.msg=[handles.msg;{y}];
        set(handles.LoadText,'Value',length(handles.msg)); 
        set(handles.LoadText,'String',handles.msg);
        set(handles.NodesID,'Value',0);
        set(handles.LinksID,'Value',0);
        % Update handles structure
        guidata(hObject, handles);
        return;
    end
    
% --- Executes on button press in SetupAnalysis.
function SetupAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to SetupAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Parameters(handles);

% --- Executes on button press in Results.
function Results_Callback(hObject, eventdata, handles)
% hObject    handle to Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SpeciesResults(handles);
% guidata(hObject, handles);

% --- Executes on button press in flowUnits.
function Colorbarh_Callback(hObject, eventdata, handles)
% hObject    handle to flowUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when axes1 is resizehandles.B.
function axes1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  

function handles=colorM(hObject, eventdata, handles,el)
    if strcmp(get(handles.Map,'String'), 'Reset')
        warndlg('Please reset map.','Run')
        return
    end
    set(handles.Tbar,'visible','off');
    set(handles.s1,'enable','inactive');
    set(handles.s2,'enable','inactive');
    set(handles.s3,'enable','inactive');
    set(handles.s4,'enable','inactive');
    set(handles.none,'enable','inactive');
    set(handles.Run,'enable','inactive');
%     set(handles.LoadData,'enable','inactive');
    set(handles.SetupAnalysis,'enable','inactive');
    set(handles.Results,'enable','inactive');
    set(handles.LoadInpFile,'enable','inactive');

    if ~isempty(findobj('Tag','Colorbar')),delete(findobj('Tag','Colorbar'));end    
    if ~isempty(findobj('Tag','legend')),delete(findobj('Tag','legend'));end    

    if el==1
        h=waitbar(0.5,['Initializing waitbar ',num2str(50),'%'],'Name','Running...');
        handles.waitbar=h;
    end
    if get(handles.s1,'Value')%Age
        handles.MsxResultsMaxNode=handles.CompQualityNodesAgeMax;
        handles.MsxResultsAverageNode=handles.CompQualityNodesAgeAverage;
        handles.MsxResultsAverageLink=handles.CompQualityLinksAgeAverage;    
        xtick = [10 25 40 60 85];
    elseif get(handles.s2,'Value')%Chlorine
        handles.MsxResultsMaxNode=handles.CompQualityNodesChlorineMax;
        handles.MsxResultsAverageNode=handles.CompQualityNodesChlorineAverage;
        handles.MsxResultsAverageLink=handles.CompQualityLinksChlorineAverage;
        xtick = [0.25 0.5 0.75 1 1.2];
    elseif get(handles.s3,'Value')%THMs
        handles.MsxResultsMaxNode=handles.CompQualityNodesTHMsMax;
        handles.MsxResultsAverageNode=handles.CompQualityNodesTHMsAverage;
        handles.MsxResultsAverageLink=handles.CompQualityLinksTHMsAverage;
        xtick = [0 30 60 80 100];
    elseif get(handles.s4,'Value')%TOC
        handles.MsxResultsMaxNode=handles.CompQualityNodesTOCMax;
        handles.MsxResultsAverageNode=handles.CompQualityNodesTOCAverage;
        handles.MsxResultsAverageLink=handles.CompQualityLinksTOCAverage;    
        xtick = [0.5 1 2 2.5 3];
    end

%     xtick = round([1: floor(max(handles.MsxResultsAverageNode)/4) : max(handles.MsxResultsAverageNode)]);
%     %     xtick = [1 30 45 60 80 100];
%     if length(xtick)==4
%         xtick=[xtick xtick(length(xtick))+(xtick(length(xtick)-1)-xtick(length(xtick)-2))];
%     end 
%     if isempty(xtick) || length(xtick)<4
%         xtick=[0 0.2 0.4 0.6 0.8];
%     end
%     Demands=handles.B.getNodeBaseDemands;
            
    handles.indW=1;handles.IDW={''};handles.ColorW={[]};
    handles.indb=1;handles.IDb={''};handles.Colorb={[]};
    handles.indc=1;handles.IDc={''};handles.Colorc={[]};
    handles.indg=1;handles.IDg={''};handles.Colorg={[]};
    handles.indcc=1;handles.IDcc={''};handles.Colorcc={[]};
    handles.indaa=1;handles.IDaa={''};handles.Coloraa={[]};

    handles.indbl=1;handles.IDbl={''};handles.Colorbl={[]};
    handles.indcl=1;handles.IDcl={''};handles.Colorcl={[]};
    handles.indgl=1;handles.IDgl={''};handles.Colorgl={[]};
    handles.indccl=1;handles.IDccl={''};handles.Colorccl={[]};
    handles.indaal=1;handles.IDaal={''};handles.Coloraal={[]}; 
    
    if handles.B.NodeCount>handles.B.LinkCount || handles.B.NodeCount==handles.B.LinkCount
        for i=1:handles.B.NodeCount
            if handles.MsxResultsAverageNode(i)<xtick(2) 
                handles.Colorb{i}='b';
                handles.IDb(i)=handles.B.NodeNameID(i);
                handles.indb=handles.indb+1;
            elseif xtick(2)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(3) 
                handles.Colorc{i}='c';
                handles.IDc(i)=handles.B.NodeNameID(i);
                handles.indc=handles.indc+1;
            elseif xtick(3)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(4) 
                handles.Colorg{i}='g';
                handles.IDg(i)=handles.B.NodeNameID(i);
                handles.indg=handles.indg+1;
            elseif xtick(4)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(5) 
                handles.Colorcc{i}=[1 .5 0];
                handles.IDcc(i)=handles.B.NodeNameID(i);
                handles.indcc=handles.indcc+1;
            elseif xtick(5)<handles.MsxResultsAverageNode(i) 
                handles.Coloraa{i}='r'; 
                handles.IDaa(i)=handles.B.NodeNameID(i);
                handles.indaa=handles.indaa+1;
            else%if Demands(i)~=0
                handles.Colorb{i}='b';
                handles.IDb(i)=handles.B.NodeNameID(i);
                handles.indb=handles.indb+1;
%             else
%                 handles.ColorW{i}='b';
%                 handles.IDW(i)=handles.B.NodeNameID(i);
%                 handles.indW=handles.indW+1;
            end

            if i<handles.B.LinkCount || i==handles.B.LinkCount
                if handles.MsxResultsAverageLink(i)<xtick(2) 
                    handles.Colorbl{i}='b';
                    handles.IDbl(i)=handles.B.LinkNameID(i);
                    handles.indbl=handles.indbl+1;
                elseif xtick(2)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(3) 
                    handles.Colorcl{i}='c';
                    handles.IDcl(i)=handles.B.LinkNameID(i);
                    handles.indcl=handles.indcl+1;
                elseif xtick(3)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(4) 
                    handles.Colorgl{i}='g';
                    handles.IDgl(i)=handles.B.LinkNameID(i);
                    handles.indgl=handles.indgl+1;
                elseif xtick(4)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(5) 
                    handles.Colorccl{i}=[1 .5 0];
                    handles.IDccl(i)=handles.B.LinkNameID(i);
                    handles.indccl=handles.indccl+1;
                elseif xtick(5)<handles.MsxResultsAverageLink(i) 
                    handles.Coloraal{i}='r'; 
                    handles.IDaal(i)=handles.B.LinkNameID(i);
                    handles.indaal=handles.indaal+1;
                else 
                    handles.Colorbl{i}='b';
                    handles.IDbl(i)=handles.B.LinkNameID(i);
                    handles.indbl=handles.indbl+1;
                end
            end
            if el==1
                handles.Progress_Percentage=(i/handles.B.NodeCount);
                if handles.Progress_Percentage==1 || handles.Progress_Percentage>1, handles.Progress_Percentage=0.98; end
                waitbar(handles.Progress_Percentage,handles.waitbar,sprintf('Overall Progress %d%%',floor(handles.Progress_Percentage*100)));
            end
        end
    elseif handles.B.NodeCount<handles.B.LinkCount 
        for i=1:handles.B.LinkCount
            if handles.MsxResultsAverageLink(i)<xtick(2) 
                handles.Colorbl{i}='b';
                handles.IDbl(i)=handles.B.LinkNameID(i);
                handles.indbl=handles.indbl+1;
            elseif xtick(2)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(3) 
                handles.Colorcl{i}='c';
                handles.IDcl(i)=handles.B.LinkNameID(i);
                handles.indcl=handles.indcl+1;
            elseif xtick(3)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(4) 
                handles.Colorgl{i}='g';
                handles.IDgl(i)=handles.B.LinkNameID(i);
                handles.indgl=handles.indgl+1;
            elseif xtick(4)<handles.MsxResultsAverageLink(i) && handles.MsxResultsAverageLink(i)<xtick(5) 
                handles.Colorccl{i}=[1 .5 0];
                handles.IDccl(i)=handles.B.LinkNameID(i);
                handles.indccl=handles.indccl+1;
            elseif xtick(5)<handles.MsxResultsAverageLink(i) 
                handles.Coloraal{i}='r'; 
                handles.IDaal(i)=handles.B.LinkNameID(i);
                handles.indaal=handles.indaal+1;
            else
                handles.Colorbl{i}='b';
                handles.IDbl(i)=handles.B.LinkNameID(i);
                handles.indbl=handles.indbl+1;
            end
            
            if i<handles.B.NodeCount || i==handles.B.NodeCount
                if handles.MsxResultsAverageNode(i)<xtick(2) 
                    handles.Colorb{i}='b';
                    handles.IDb(i)=handles.B.NodeNameID(i);
                    handles.indb=handles.indb+1;
                elseif xtick(2)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(3) 
                    handles.Colorc{i}='c';
                    handles.IDc(i)=handles.B.NodeNameID(i);
                    handles.indc=handles.indc+1;
                elseif xtick(3)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(4) 
                    handles.Colorg{i}='g';
                    handles.IDg(i)=handles.B.NodeNameID(i);
                    handles.indg=handles.indg+1;
                elseif xtick(4)<handles.MsxResultsAverageNode(i) && handles.MsxResultsAverageNode(i)<xtick(5) 
                    handles.Colorcc{i}=[1 .5 0];
                    handles.IDcc(i)=handles.B.NodeNameID(i);
                    handles.indcc=handles.indcc+1;
                elseif xtick(5)<handles.MsxResultsAverageNode(i) 
                    handles.Coloraa{i}='r'; 
                    handles.IDaa(i)=handles.B.NodeNameID(i);
                    handles.indaa=handles.indaa+1;
                else%if Demands(i)~=0
                    handles.Colorb{i}='b';
                    handles.IDb(i)=handles.B.NodeNameID(i);
                    handles.indb=handles.indb+1;
%                 else
%                     handles.ColorW{i}='b';
%                     handles.IDW(i)=handles.B.NodeNameID(i);
%                     handles.indW=handles.indW+1;                    
                end
            end
            if el==1
                handles.Progress_Percentage=(i/handles.B.LinkCount);
                if handles.Progress_Percentage==1 || handles.Progress_Percentage>1, handles.Progress_Percentage=0.98; end
                waitbar(handles.Progress_Percentage,handles.waitbar,sprintf('Overall Progress %d%%',floor(handles.Progress_Percentage*100)));
            end         
        end
    end
    cla(handles.previousg);
    
    ENplotB(handles,'highlightnode',[handles.IDb handles.IDc handles.IDg handles.IDcc handles.IDaa],'colornode',[handles.Colorb handles.Colorc handles.Colorg handles.Colorcc handles.Coloraa],...
    'highlightlink',[handles.IDbl handles.IDcl handles.IDgl handles.IDccl handles.IDaal],'colorlink',[handles.Colorbl handles.Colorcl handles.Colorgl handles.Colorccl handles.Coloraal],...
    'axes',handles.previousg);
%     ENplotB('highlightnode',[handles.IDb handles.IDc handles.IDg handles.IDcc handles.IDaa handles.IDW],'colornode',[handles.Colorb handles.Colorc handles.Colorg handles.Colorcc handles.Coloraa handles.ColorW],...
%     'highlightlink',[handles.IDbl handles.IDcl handles.IDgl handles.IDccl handles.IDaal],'colorlink',[handles.Colorbl handles.Colorcl handles.Colorgl handles.Colorccl handles.Coloraal],...
%     'axes',handles.previousg);
    if ~isempty(findobj('Tag','legend')),delete(findobj('Tag','legend'));end    
    str=get(handles.Map,'String');
    if strcmp('Reset',str)
        if handles.B.NodeCoordinates{2}(1)<85 && handles.B.NodeCoordinates{2}(1)>-85 ...
                && handles.B.NodeCoordinates{1}(1)<180 && handles.B.NodeCoordinates{1}(1)>-180
            hold on;
            handles.MapOFF=plot_google_map(handles);
        end
        box on;
    end

    if ~isempty(handles.file)
        LoadData_Callback(hObject, eventdata, handles)
    else
        set(handles.LoadData,'enable','on');
    end
    waitbar(handles.Progress_Percentage,handles.waitbar,sprintf('Overall Progress %d%%',floor(handles.Progress_Percentage*100)));
    close(handles.waitbar);

    newmap = jet(5);
    newmap(1,:)=[0 0 1];
    newmap(2,:)=[0 1 1];
    newmap(3,:)=[0 1 0];
    newmap(4,:)=[1 .5 0];
    newmap(5,:)=[1 0 0];
    colormap(newmap);
    handles.cbar = colorbar('NorthOutside','fontweight','bold');
    if handles.speciesInd==1
        pp='(hrs)';
    else
        pp=['(',char(handles.B.MsxSpeciesUnits(handles.speciesInd)),'/L)'];
    end
    set(handles.Tbar,'visible','on');
    set(handles.Tbar,'String',pp);
    str=char(handles.B.MSXSpeciesNameID(handles.speciesInd(1)));
    y=['>>',str,' Selected'];
    set(handles.cbar,'position',[0.02 .94 0.4 0.03]);
    set(handles.cbar,'XTickLabel',regexp(num2str(xtick), '\s*','split'));
    % History
    handles.msg=[handles.msg;{y}];
    set(handles.LoadText,'Value',length(handles.msg)); 
    set(handles.LoadText,'String',handles.msg);

    set(handles.flowUnits,'visible','on');
  
    set(handles.Run,'str','Run','backg',handles.col)  % Now reset the button features.
    
    font(hObject, eventdata, handles, 0);

    % Update handles structure
    guidata(hObject, handles);
%     profile viewer
%     toc
    set(handles.s1,'enable','on');
    set(handles.s2,'enable','on');
    set(handles.s3,'enable','on');
    set(handles.s4,'enable','on');
    set(handles.none,'enable','on');
    
set(handles.Results,'enable','on');
% set(handles.LoadData,'enable','on');
set(handles.none,'enable','on');
set(handles.Run,'enable','on');
set(handles.SetupAnalysis,'enable','on');
set(handles.Results,'enable','on');
set(handles.LoadInpFile,'enable','on');
    % --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function font(hObject, eventdata, handles, arg)

    n=get(handles.NodesID,'value');
    l=get(handles.LinksID,'value');

    if n==1
        set(handles.NodesID,'value',0)
        if arg==0
            hNodesID=[];
        end
        NodesID_Callback(hObject, eventdata, handles);
    end
    if l==1
        if arg==0
            hLinksID=[];
        end
        set(handles.LinksID,'value',0)
        LinksID_Callback(hObject, eventdata, handles);
    end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Instructions_Callback(hObject, eventdata, handles)
% hObject    handle to Instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('Instructions.html');


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 about;


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    LoadInpFile_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if libisloaded('epanet2')
        unloadlibrary('epanet2');
    end    
    opening(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ExitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.figure1,'Visible','off');
    if libisloaded('epanet2')
       unloadlibrary('epanet2');
    end
    clc;
    
    try
    close(findobj('type','figure','name','Results'));
    close(findobj('type','figure','name','Setup Analysis'));
    catch err
    end


    rmpath(genpath(pwd));


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    set(handles.figure1,'Visible','off');
    if libisloaded('epanet2')
       unloadlibrary('epanet2');
    end
    clc;
    
    try
    close(findobj('type','figure','name','Results'));
    close(findobj('type','figure','name','Setup Analysis'));
    catch err
    end

    try
        delete(handles.dataplots);
        delete(handles.previousg);
        delete(handles.logo); 
    catch err
    end
    
    rmpath(genpath(pwd));

function [axesid] = ENplotB(handles,varargin)
    % Initiality
    highlightnode=0;
    highlightlink=0;
    highlightnodeindex=[];
    highlightlinkindex=[];
    Node=char('no');
    Link=char('no');
    fontsize=10;
    selectColorNode={''};
    selectColorLink={''};
    axesid=0;
    legendIndices=[];
    l=zeros(1,6);

    for i=1:(nargin/2)
        argument =lower(varargin{2*(i-1)+1});
        switch argument
            case 'nodes' % Nodes
                if ~strcmp(lower(varargin{2*i}),'yes') && ~strcmp(lower(varargin{2*i}),'no')
                    warning('Invalid argument.');
                    return
                end
                Node=varargin{2*i};
            case 'links' % Links
                if ~strcmp(lower(varargin{2*i}),'yes') && ~strcmp(lower(varargin{2*i}),'no')
                    warning('Invalid argument.');
                    return
                end
                Link=varargin{2*i};
            case 'highlightnode' % Highlight Node
                highlightnode=varargin{2*i};
            case 'highlightlink' % Highlight Link
                highlightlink=varargin{2*i};
            case 'fontsize' % font size
                fontsize=varargin{2*i};
            case 'colornode' % color
                selectColorNode=varargin{2*i};
            case 'colorlink' % color
                selectColorLink=varargin{2*i};
            case 'axes' % color
                axesid=varargin{2*i};
            otherwise
                warning('Invalid property founhandles.B.');
                return
        end
    end

    if axesid==0
       g=figure;
       axesid=axes('Parent',g);
    end

    if cellfun('isempty',selectColorNode)==1
        init={'r'};
        for i=1:length(highlightnode)
            selectColorNode=[init selectColorNode];
        end
    end
    if cellfun('isempty',selectColorLink)==1
        init={'r'};
        for i=1:length(highlightlink)
            selectColorLink=[init selectColorLink];
        end
    end
    % Get node names and x, y coordiantes
    if isa(highlightnode,'cell')
        for i=1:length(highlightnode)
            n = strcmp(handles.B.NodeNameID,highlightnode{i});
            if sum(n)==0
                warning('Undefined node with id "%s" in function call therefore the index is zero.', char(highlightnode{i}));
            else
                highlightnodeindex(i) = strfind(n,1);
            end
        end
    end
    Flow=ones(1,handles.B.LinkCount);
    if isa(highlightlink,'cell')
        for i=1:length(highlightlink)
            n = strcmp(handles.B.LinkNameID,highlightlink{i});
            if sum(n)==0
                warning('Undefined link with id "%s" in function call therefore the index is zero.', char(highlightlink{i}));
            else
                highlightlinkindex(i) = strfind(n,1);
            end
        end
        Flow=handles.B.getLinkFlows;
    end
    hold on;
    for i=1:handles.B.LinkCount
        FromNode=strfind(strcmp(handles.B.NodesConnectingLinksID(i,1),handles.B.NodeNameID),1);
        ToNode=strfind(strcmp(handles.B.NodesConnectingLinksID(i,2),handles.B.NodeNameID),1);

        if FromNode
            x1 = double(handles.B.NodeCoordinates{1}(FromNode));
            y1 = double(handles.B.NodeCoordinates{2}(FromNode));
        end
        if ToNode
            x2 = double(handles.B.NodeCoordinates{1}(ToNode));
            y2 = double(handles.B.NodeCoordinates{2}(ToNode));
        end
        hh=strfind(highlightlinkindex,i);
        if length(hh) && ~isempty(selectColorLink)
            if (abs(Flow(i))>0.001)==0
                line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',1,'Color',[.5 .5 .5],'Parent',axesid);
            end
        end
        if (abs(Flow(i))>0.001)~=0 && length(hh)
            h(:,1)=line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',1,'Parent',axesid);
            if ~l(1), legendIndices = [legendIndices 1]; l(1)=1; end
        end
        if ~length(hh)
            h(:,1)=line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',1,'Parent',axesid);
            if ~l(1), legendIndices = [legendIndices 1]; l(1)=1; end
        end
        legendString{4} = char('Pipes');
        % Plot Pumps
        if sum(strfind(handles.B.LinkPumpIndex,i))
            colornode = 'm';
            if length(hh) && isempty(selectColorLink)
                colornode = 'r';
            end
            h(:,2)=plot((x1+x2)/2,(y1+y2)/2,'mv','LineWidth',2,'MarkerEdgeColor','m',...
                'MarkerFaceColor','m',...
                'MarkerSize',5,'Parent',axesid);
            if ~l(2), legendIndices = [legendIndices 2]; l(2)=1; end
            plot((x1+x2)/2,(y1+y2)/2,'mv','LineWidth',2,'MarkerEdgeColor',colornode,...
                'MarkerFaceColor',colornode,...
                'MarkerSize',5,'Parent',axesid);

            legendString{5} = char('Pumps');
        end

        % Plot Valves
        if sum(strfind(handles.B.LinkValveIndex,i))
            colornode = 'k';
            if length(hh) && isempty(selectColorLink)
                colornode = 'r';
            end
            h(:,3)=plot((x1+x2)/2,(y1+y2)/2,'k*','LineWidth',2,'MarkerEdgeColor',colornode,...
                'MarkerFaceColor',colornode,'MarkerSize',7,'Parent',axesid);
            legendString{6} = char('Valves');
            if ~l(3), legendIndices = [legendIndices 3]; l(3)=1; end
        end

        % Show Link id
        if (strcmp(lower(Link),'yes') && ~length(hh))
            text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'Fontsize',fontsize,'Parent',axesid);
        end

        if length(hh) && isempty(selectColorLink)
            line([x1,x2],[y1,y2],'LineWidth',2,'Color','r','Parent',axesid);
            text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'Fontsize',fontsize,'Parent',axesid);
        elseif length(hh) && ~isempty(selectColorLink)
            try 
                tt=length(selectColorLink{hh});
            catch err
                tt=2;
            end
           if tt>1
                if length(selectColorLink(hh))==1
                    nm{1}=selectColorLink(hh);
                else
                    nm=selectColorLink(hh);
                end
                if iscell(nm{1}) 
                    if (abs(Flow(i))>0.001)~=0%%%%
                        line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',2,'Color',nm{1}{1},'Parent',axesid);
                    end
                else
                    line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',2,'Color',nm{1},'Parent',axesid);
                end
           else
                if (abs(Flow(i))>0.001)~=0%%%%
                    line([x1 handles.B.NodeCoordinates{3}{i} x2],[y1 handles.B.NodeCoordinates{4}{i} y2],'LineWidth',2,'Color',char(selectColorLink(hh)),'Parent',axesid);
                end
           end
    %         text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'Fontsize',fontsize);
        end
    end               
    % Coordinates for node FROM
    gof=0;
    for i=1:handles.B.NodeCount
        [x] = double(handles.B.NodeCoordinates{1}(i));
        [y] = double(handles.B.NodeCoordinates{2}(i));

        hh=strfind(highlightnodeindex,i);

        a=(handles.B.NodesConnectingLinksIndex==i);
        a=a(:,1)+a(:,2);
        r{i}=find(a==1);

        if length(hh) && ~isempty(selectColorNode)
            if handles.B.NodeBaseDemands{1}(i)==0 && (abs(sum(Flow(r{i})))>0.001)==0
                plot(x, y,'.','Color',[.5 .5 .5],'Parent',axesid);%only for dbpRisk
                gof=1;
            end
        end
        
        if handles.B.NodeBaseDemands{1}(i)~=0 && length(hh) && (abs(sum(Flow(r{i})))>0.001)==0
            h(:,4)=plot(x, y,'o','LineWidth',2,'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5,'Parent',axesid);
            if ~l(4), legendIndices = [legendIndices 4]; l(4)=1; end
            legendString{1}= char('Junctions');
        end
        if ~length(hh)
            h(:,4)=plot(x, y,'o','LineWidth',2,'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5,'Parent',axesid);
            legendString{1}= char('Junctions');
        end
        % Plot Reservoirs
        if sum(strfind(handles.B.NodeReservoirIndex,i))
            colornode = 'g';
            if length(hh) && isempty(selectColorNode)
                colornode = 'r';
            end
            h(:,5)=plot(x,y,'s','LineWidth',2,'MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',13,'Parent',axesid);
            if ~l(5), legendIndices = [legendIndices 5]; l(5)=1; end
            plot(x,y,'s','LineWidth',2,'MarkerEdgeColor', colornode,...
                'MarkerFaceColor', colornode,...
                'MarkerSize',13,'Parent',axesid);
            legendString{2} = char('Reservoirs');
        end
        % Plot Tanks
        if sum(strfind(handles.B.NodeTankIndex,i))
            colornode='c';
            if length(hh) && isempty(selectColorNode)
                colornode='r';
            elseif length(hh) && ~isempty(selectColorNode)
                colornode= 'c';
            end
            h(:,6)=plot(x,y,'p','LineWidth',2,'MarkerEdgeColor','c',...
                'MarkerFaceColor','c',...
                'MarkerSize',16,'Parent',axesid);
            if ~l(6), legendIndices = [legendIndices 6]; l(6)=1; end

            plot(x,y,'p','LineWidth',2,'MarkerEdgeColor',colornode,...
                'MarkerFaceColor',colornode,...
                'MarkerSize',16,'Parent',axesid);

            legendString{3} = char('Tanks');
        end

        % Show Node id
        if (strcmp(lower(Node),'yes') && ~length(hh))
            text(x,y,handles.B.NodeNameID(i),'Fontsize',fontsize,'Parent',axesid);%'BackgroundColor',[.7 .9 .7],'Margin',margin/4);
        end

        if length(hh) && isempty(selectColorNode)
            plot(x, y,'o','LineWidth',2,'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',10,'Parent',axesid);
            text(x,y,handles.B.NodeNameID(i),'Fontsize',fontsize,'Parent',axesid);%'BackgroundColor',[.7 .9 .7],'Margin',margin/4);
        elseif length(hh) && ~isempty(selectColorNode)
            try 
                tt=length(selectColorNode{hh});
            catch err
                tt=2;
            end
           if tt>1
                if length(selectColorNode(hh))==1
                    nm{1}=selectColorNode(hh);
                else
                    nm=selectColorNode(hh);
                end
                if iscell(nm{1}) 
                    if handles.B.NodeBaseDemands{1}(i)~=0 && sum(round(Flow(r{i})))~=0
                        plot(x, y,'o','LineWidth',2,'MarkerEdgeColor',nm{1}{1},'MarkerFaceColor',nm{1}{1},'MarkerSize',10,'Parent',axesid);
                    end
                else
                    plot(x, y,'o','LineWidth',2,'MarkerEdgeColor',nm{1},'MarkerFaceColor',nm{1},'MarkerSize',10,'Parent',axesid);
                end
           elseif gof==0
                plot(x, y,'o','LineWidth',2,'MarkerEdgeColor',char(selectColorNode(hh)),'MarkerFaceColor',char(selectColorNode(hh)),...
                'MarkerSize',10,'Parent',axesid);               
           end
    %         text(x,y,handles.B.NodeNameID(i),'Fontsize',fontsize)%'BackgroundColor',[.7 .9 .7],'Margin',margin/4);
        end
        gof=0;
    end

    h(:,1)=plot(x,y,'o','LineWidth',2,'MarkerEdgeColor','b',...
    'MarkerFaceColor','b',...
    'MarkerSize',5,'Parent',axesid);
    legendString{1}= char('Junctions');

    % Legend Plots
    if isempty(highlightnodeindex) || isempty(highlightnodeindex)
        legendString={'Pipes','Pumps','Valves',...
            'Junctions','Reservoirs','Tanks'}; 
        legendIndices=sort(legendIndices,'descend');
        legend(h(legendIndices),legendString(legendIndices));
    end
    delete(h(:,1));
    % Axis OFF and se Background
    [xmax,~]=max(handles.B.NodeCoordinates{1});
    [xmin,~]=min(handles.B.NodeCoordinates{1});
    [ymax,~]=max(handles.B.NodeCoordinates{2});
    [ymin,~]=min(handles.B.NodeCoordinates{2});

    if ~isnan(ymax)
        if ymax==ymin
            xlim([xmin-((xmax-xmin)*.1),xmax+((xmax-xmin)*.1)]);
            ylim([ymin-.1,ymax+.1]);
        elseif xmax==xmin
            xlim([xmin-.1,xmax+.1]);
            ylim([ymin-(ymax-ymin)*.1,ymax+(ymax-ymin)*.1]);
        else
            xlim([xmin-((xmax-xmin)*.1),xmax+((xmax-xmin)*.1)]);
            ylim([ymin-(ymax-ymin)*.1,ymax+(ymax-ymin)*.1]);
        end
    else
        warning('Undefined coordinates.');
    end
    axis off
    whitebg('w');
    set(axesid,'position',[0 0 1 1],'units','normalized');
   


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isempty(handles.file) %|| (handles.file==0)
        [handles.file,~] = uigetfile('MISC\*.txt');
    end
    if handles.file~=0
        fid = fopen([pwd,'\MISC\',handles.file],'r+');
%         delete(handles.dataplots)
        tline=fgetl(fid);
        a=regexp(tline,'\s*','split');hold on;format long g;
        if ~strcmp(a{1},'[Data]') || ~strcmp(a{2},['[',handles.B.inputfile,']'])
            warndlg('Wrong Data.','Load Data');
            return;
        end
            
        i=1;
        while ~feof(fid)
            tline=fgetl(fid);
            info{i} = tline;
            a=regexp(info{i},'\s*','split');hold on;format long g;
            if i>2
                if get(handles.s1,'Value')%Age
                    xtick = [10 25 40 60 85];
                    DataValues=0;
                    if strcmpi(get(handles.s1,'enable'),'inactive')
                        return
                    else
                        warndlg('No WATER AGE data.','Load Data');return;
                    end
                elseif get(handles.s2,'Value')%Chlorine
                    xtick = [0.25 0.5 0.75 1 1.2];
                    DataValues=str2num(a{5});
                elseif get(handles.s3,'Value')%THMs
                    DataValues=str2num(a{4});%return
                    xtick = [0 30 60 80 100];
                elseif get(handles.s4,'Value')%TOC
                    xtick = [0.5 1 2 2.5 3];
                    DataValues=0;
                    if strcmpi(get(handles.s1,'enable'),'inactive')
                        return
                    else
                        warndlg('No TOC data.','Load Data');return;
                    end
                end
                handles.x(i)=str2num(a{2});
                handles.y(i)=str2num(a{3});
                hold on;
                if DataValues<xtick(2) 
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10,'Parent',handles.previousg);
                elseif xtick(2)<DataValues && DataValues<xtick(3) 
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor','c','MarkerFaceColor','c','MarkerSize',10,'Parent',handles.previousg);
                elseif xtick(3)<DataValues && DataValues<xtick(4) 
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',10,'Parent',handles.previousg);
                elseif xtick(4)<DataValues && DataValues<xtick(5) 
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor',[1 .5 0],'MarkerFaceColor',[1 .5 0],'MarkerSize',10,'Parent',handles.previousg);
                elseif xtick(5)<DataValues 
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',10,'Parent',handles.previousg);
                else%if Demands(i)~=0
                    h(i,:)=plot(handles.x(i),handles.y(i),'x','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10,'Parent',handles.previousg);
                end
            end
            i= i+1;
        end
        handles.dataplots=h;
        set(handles.LoadData,'enable','off');
    end
    
    guidata(hObject, handles);
