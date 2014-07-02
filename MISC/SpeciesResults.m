function varargout = SpeciesResults(varargin)
% SPECIESRESULTS MATLAB code for SpeciesResults.fig
%      SPECIESRESULTS, by itself, creates a new SPECIESRESULTS or raises the existing
%      singleton*.
%
%      H = SPECIESRESULTS returns the handle to a new SPECIESRESULTS or the handle to
%      the existing singleton*.
%
%      SPECIESRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECIESRESULTS.M with the given input arguments.
%
%      SPECIESRESULTS('Property','Value',...) creates a new SPECIESRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpeciesResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpeciesResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpeciesResults

% Last Modified by GUIDE v2.5 28-Mar-2014 15:37:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpeciesResults_OpeningFcn, ...
                   'gui_OutputFcn',  @SpeciesResults_OutputFcn, ...
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


% --- Executes just before SpeciesResults is made visible.
function SpeciesResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpeciesResults (see VARARGIN)

% Choose default command line output for SpeciesResults
handles.output = hObject;
if ~isempty(varargin)
    handles.Ps=varargin{1};
end
set(handles.figure1,'name','Results');

% UIWAIT makes SpeciesResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);

for i=1:handles.Ps.B.NodeCount
    %type
    table(i,1) ={char(handles.Ps.B.NodeType(i))};
    %id
    id = sprintf(' %s',char(handles.Ps.B.NodeNameID(i)));
    table(i,1) = strcat(table(i,1),id);
end
set(handles.listbox1,'String',table);
set(handles.listbox1,'value',1);

set(handles.s1,'String','WaterAge');
set(handles.s2,'String','Chlorine');
set(handles.s3,'String','THMs');
set(handles.s4,'String','TOC');   
set(handles.s1,'Value',1);

set(handles.NodesID,'Value',1);
set(handles.LinksID,'Value',0);
set(handles.frplot,'enable','off');
set(handles.allnodes,'enable','off');

handles.Text=[];
handles.Text2=[];

set(handles.StartTime,'String',1);
set(handles.frplot,'Value',0);
set(handles.EndTime,'String',handles.Ps.P.EndTime);

% Update handles structure
guidata(hObject, handles);
listbox1_Callback(hObject, eventdata, handles)

% --- Outputs from this function are returned to the command line.
function varargout = SpeciesResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.previousg;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
try
delete(handles.Text);
delete(handles.Text2);
catch err
end
index=get(handles.listbox1,'value');
    
% timehrs=handles.Ps.Time/3600;
timehrs=0:handles.Ps.P.EndTime;

endT=str2num(get(handles.EndTime, 'String'));
if ~length(endT) || endT<0 || endT==0 || endT>handles.Ps.P.EndTime
    s=['Give End Time.',' Simulation Time is ',num2str(handles.Ps.P.EndTime),'hrs'];
    msgbox(s, 'Error', 'modal');
    return
end
endT=endT+1;
start=str2num(get(handles.StartTime, 'String'));
if ~length(start) || start<0
    msgbox('            Give Start Time', 'Error', 'modal')
    return
end
if start>handles.Ps.P.EndTime || start<0 || start==0
    start=1;
end

species=[get(handles.s1,'Value') get(handles.s2,'Value') get(handles.s3,'Value') get(handles.s4,'Value')];
handles.speciesInd=find(species==1);
if sum(species)>1
    set(handles.frplot,'enable','on');
else
    set(handles.frplot,'enable','off');
end
if sum(species)==0
%     warndlg(' Choise Substance.','Select Substance');
    return;
end
if get(handles.NodesID,'Value')
    if get(handles.s1,'Value')%Age
        handles.vv=handles.Ps.CompQualityNodesAge;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityNodesAgeAverage;
    elseif get(handles.s2,'Value')%Chlorine
        handles.vv=handles.Ps.CompQualityNodesChlorine;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityNodesChlorineAverage;
    elseif get(handles.s3,'Value')%THMs
        handles.vv=handles.Ps.CompQualityNodesTHMs;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityNodesTHMsAverage;
    elseif get(handles.s4,'Value')%TOC
        handles.vv=handles.Ps.CompQualityNodesTOC;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityNodesTOCAverage;
    end
    type='Node ';
    IDs=handles.Ps.B.NodeNameID;
else
    if get(handles.s1,'Value')%Age
        handles.vv=handles.Ps.CompQualityLinksAge;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityLinksAgeAverage;
    elseif get(handles.s2,'Value')%Chlorine
        handles.vv=handles.Ps.CompQualityLinksChlorine;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityLinksChlorineAverage;
    elseif get(handles.s3,'Value')%THMs
        handles.vv=handles.Ps.CompQualityLinksTHMs;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityLinksTHMsAverage;
    elseif get(handles.s4,'Value')%TOC
        handles.vv=handles.Ps.CompQualityLinksTOC;
        handles.Ps.MsxResultsAverage=handles.Ps.CompQualityLinksTOCAverage;
    end
    type='Link ';
    IDs=handles.Ps.B.LinkNameID;
end
    
if sum(species)>1
    handles.vv={};
    if get(handles.NodesID,'Value')
        handles.vv{1}=handles.Ps.CompQualityNodesAge;
        handles.vv{2}=handles.Ps.CompQualityNodesChlorine;
        handles.vv{3}=handles.Ps.CompQualityNodesTHMs;
        handles.vv{4}=handles.Ps.CompQualityNodesTOC;
    else
        handles.vv{1}=handles.Ps.CompQualityLinksAge;
        handles.vv{2}=handles.Ps.CompQualityLinksChlorine;
        handles.vv{3}=handles.Ps.CompQualityLinksTHMs;
        handles.vv{4}=handles.Ps.CompQualityLinksTOC;
    end
    if sum(species)==3
        pp=1;mm=3;
    elseif sum(species)==2
        pp=1;mm=2;
    elseif sum(species)==4
        pp=2;mm=2;
    end
    sb=subplot(2,pp,1,'Parent',handles.uipanel1);
    cla(handles.uipanel1)
    
    set(handles.uipanel1,'position',[46.0000 0.6154 123.8000 45.3077]);
    set(handles.text9,'visible','off');
    set(handles.text3,'visible','off');
    set(handles.text4,'visible','off');
    set(handles.text5,'visible','off');
    set(handles.Min,'visible','off');
    set(handles.Max,'visible','off');
    set(handles.Mean,'visible','off');
    k=1;
    for i=handles.speciesInd
        if get(handles.frplot,'Value') && get(handles.allnodes,'value')
            if i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine'))
                str=['Chlorine of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits=sprintf('Chlorine(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine')))));
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'WaterAge'))
                str=['Age of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits='Age(hrs)';
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC'))
                handles.MsxSpeciesUnits=sprintf('TOC(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC')))));
                str=['TOC of ',type,char(IDs(index))];
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs'))
                handles.MsxSpeciesUnits=sprintf('THMs(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs')))));
                str=['THMs of ',type,char(IDs(index))];
            end
    
            Max=max(handles.vv{i}(start:endT,index));
            Min=min(handles.vv{i}(start:endT,index));
            Mean=mean(handles.vv{i}(start:endT,index));

            sb=subplot(mm,pp,k,'Parent',handles.uipanel1);
            hist(mean(handles.vv{i}),'Parent',sb);
            xlim('auto');
            a=regexp(str,'\s','split');a(3)=strcat(a(3),'s');
            title(['Frequency Plot: ',[a{1},' ',a{2},' ',a{3}]],'Parent',sb);
            xlabel(handles.MsxSpeciesUnits,'Parent',sb);
            if get(handles.NodesID,'value')
                ylabel('Nodes','Parent',sb);
            else
                ylabel('Links','Parent',sb);
            end
            set(handles.Max,'String',Max);
            set(handles.Min,'String',Min);
            set(handles.Mean,'String',Mean);
            k=k+1;
        elseif get(handles.frplot,'Value') && ~get(handles.allnodes,'value');
            if i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine'))
                str=['Chlorine of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits=sprintf('Chlorine(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine')))));
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'WaterAge'))
                str=['Age of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits='Age(hrs)';
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC'))
                handles.MsxSpeciesUnits=sprintf('TOC(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC')))));
                str=['TOC of ',type,char(IDs(index))];
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs'))
                handles.MsxSpeciesUnits=sprintf('THMs(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs')))));
                str=['THMs of ',type,char(IDs(index))];
            end
    
            Max=max(handles.vv{i}(start:endT,index));
            Min=min(handles.vv{i}(start:endT,index));
            Mean=mean(handles.vv{i}(start:endT,index));

            sb=subplot(mm,pp,k,'Parent',handles.uipanel1);
            hist(handles.vv{i}(start:endT,index),'Parent',sb);
            xlim('auto');
            title(['Frequency Plot: ',str],'Parent',sb);
            xlabel(handles.MsxSpeciesUnits,'Parent',sb);
            ylabel('','Parent',sb);
            set(handles.Max,'String',Max);
            set(handles.Min,'String',Min);
            set(handles.Mean,'String',Mean);
            k=k+1;
        else
            sb=subplot(mm,pp,k,'Parent',handles.uipanel1);
            plot(timehrs(start:endT),handles.vv{i}(start:endT,index),'Parent',sb,'LineWidth',1.5);
            xlim([start endT]);
            if i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine'))
                str=['Chlorine of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits=sprintf('Chlorine(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine')))));
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'WaterAge'))
                str=['Age of ',type,char(IDs(index))];
                handles.MsxSpeciesUnits='Age(hrs)';
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC'))
                handles.MsxSpeciesUnits=sprintf('TOC(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC')))));
                str=['TOC of ',type,char(IDs(index))];
            elseif i==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs'))
                handles.MsxSpeciesUnits=sprintf('THMs(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs')))));
                str=['THMs of ',type,char(IDs(index))];
            end
            xlabel('Time(hrs)','Parent',sb);
            ylabel(handles.MsxSpeciesUnits,'Parent',sb);
            title(str,'Parent',sb);k=k+1;            
        end
    end

else

    set(handles.uipanel1,'position',[46.0000 0.6154 123.8000 42.4615]);
    set(handles.text9,'visible','on');
    set(handles.text3,'visible','on');
    set(handles.text4,'visible','on');
    set(handles.text5,'visible','on');
    set(handles.Min,'visible','on');
    set(handles.Max,'visible','on');
    set(handles.Mean,'visible','on');

    sb=subplot(2,1,1,'Parent',handles.uipanel1);
    cla(handles.uipanel1)
    sb=subplot(2,1,1,'Parent',handles.uipanel1);
    plot(timehrs(start:endT),handles.vv(start:endT,index),'Parent',sb,'LineWidth',1.5);hold on;
    plot(timehrs(start:endT),handles.vv(start:endT,index)+handles.vv(start:endT,index)*0.05,'r','Parent',sb);
    plot(timehrs(start:endT),handles.vv(start:endT,index)-handles.vv(start:endT,index)*0.05,'r','Parent',sb);
    xlim([start endT]);

    if handles.speciesInd==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine'))
        str=['Chlorine of ',type,char(IDs(index))];
        handles.MsxSpeciesUnits=sprintf('Chlorine(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'Chlorine')))));
    elseif handles.speciesInd==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'WaterAge'))
        str=['Age of ',type,char(IDs(index))];
        handles.MsxSpeciesUnits='Age(hrs)';
    elseif handles.speciesInd==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC'))
        handles.MsxSpeciesUnits=sprintf('TOC(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'TOC')))));
        str=['TOC of ',type,char(IDs(index))];
    elseif handles.speciesInd==find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs'))
        handles.MsxSpeciesUnits=sprintf('THMs(%s/L)',char(handles.Ps.B.MsxSpeciesUnits(find(strcmp(handles.Ps.B.MsxSpeciesNameID,'THMs')))));
        str=['THMs of ',type,char(IDs(index))];
    end
    xlabel('Time(hrs)','Parent',sb);
    ylabel(handles.MsxSpeciesUnits,'Parent',sb);
    title(str,'Parent',sb);

    Max=max(handles.vv(start:endT,index));
    Min=min(handles.vv(start:endT,index));
    Mean=mean(handles.vv(start:endT,index));
    a=regexp(str,'\s','split');a(3)=strcat(a(3),'s');

    sb1=subplot(2,1,2,'Parent',handles.uipanel1);
    if get(handles.allnodes,'value');
        hist(handles.Ps.MsxResultsAverage,'Parent',sb1);
        title(['Frequency Plot: ',[a{1},' ',a{2},' ',a{3}]],'Parent',sb1);
        ylabel('Nodes','Parent',sb1);
    elseif ~get(handles.allnodes,'value');
        hist(handles.vv(start:endT,index),'Parent',sb1);
        title(['Frequency Plot: ',str],'Parent',sb1);
    end        
    xlabel(handles.MsxSpeciesUnits,'Parent',sb1);
    set(handles.Max,'String',Max);
    set(handles.Min,'String',Min);
    set(handles.Mean,'String',Mean);

end

if get(handles.NodesID,'Value')
    handles.Text=text(handles.Ps.B.NodeCoordinates{1}(index),handles.Ps.B.NodeCoordinates{2}(index),...
     char(handles.Ps.B.NodeNameID(index)),'Fontsize',15,'Parent',handles.Ps.previousg);
    handles.Text2=plot(handles.Ps.B.NodeCoordinates{1}(index),handles.Ps.B.NodeCoordinates{2}(index),'ok','markerSize',14,'Parent',handles.Ps.previousg);
else
    x1=handles.Ps.B.NodeCoordinates{1}(handles.Ps.B.NodesConnectingLinksIndex(index,1));
    x2=handles.Ps.B.NodeCoordinates{1}(handles.Ps.B.NodesConnectingLinksIndex(index,2));
    y1=handles.Ps.B.NodeCoordinates{2}(handles.Ps.B.NodesConnectingLinksIndex(index,1));
    y2=handles.Ps.B.NodeCoordinates{2}(handles.Ps.B.NodesConnectingLinksIndex(index,2));
    handles.Text=text((x1+x2)/2,(y1+y2)/2,char(handles.Ps.B.LinkNameID(index)),'Fontsize',15,'Parent',handles.Ps.previousg);
end

% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LastHoursTime_Callback(hObject, eventdata, handles)
% hObject    handle to LastHoursTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LastHoursTime as text
%        str2double(get(hObject,'String')) returns contents of LastHoursTime as a double


% --- Executes during object creation, after setting all properties.
function LastHoursTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LastHoursTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function simulationTime_Callback(hObject, eventdata, handles)
% hObject    handle to simulationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simulationTime as text
%        str2double(get(hObject,'String')) returns contents of simulationTime as a double


% --- Executes during object creation, after setting all properties.
function simulationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NodesID.
function NodesID_Callback(hObject, eventdata, handles)
% hObject    handle to NodesID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NodesID
set(handles.NodesID,'Value',1);
set(handles.LinksID,'Value',0);
for i=1:handles.Ps.B.NodeCount
    %type
    table(i,1) ={char(handles.Ps.B.NodeType(i))};
    %id
    id = sprintf(' %s',char(handles.Ps.B.NodeNameID(i)));
    table(i,1) = strcat(table(i,1),id);
end
set(handles.listbox1,'String',table);
set(handles.listbox1,'value',1);
listbox1_Callback(hObject, eventdata, handles)
% --- Executes on button press in LinksID.
function LinksID_Callback(hObject, eventdata, handles)
% hObject    handle to LinksID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LinksID
set(handles.NodesID,'Value',0);
set(handles.LinksID,'Value',1);
for i=1:handles.Ps.B.LinkCount
    %type
    table(i,1) ={char(handles.Ps.B.LinkType(i))};
    %id
    id = sprintf(' %s',char(handles.Ps.B.LinkNameID(i)));
    table(i,1) = strcat(table(i,1),id);
end
set(handles.listbox1,'String',table);
set(handles.listbox1,'value',1);
listbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in Okshow.
function Okshow_Callback(hObject, eventdata, handles)
% hObject    handle to Okshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Uncertainty.
function Uncertainty_Callback(hObject, eventdata, handles)
% hObject    handle to Uncertainty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PipeAge.
function PipeAge_Callback(hObject, eventdata, handles)
% hObject    handle to PipeAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in s1.
function s1_Callback(hObject, eventdata, handles)
% hObject    handle to s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s1
% a(1)=get(handles.s4,'Value');
% a(2)=get(handles.s2,'Value');
% a(3)=get(handles.s3,'Value');
% if sum(a)==0
%     set(handles.s1,'Value',1);
% end
listbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in s2.
function s2_Callback(hObject, eventdata, handles)
% hObject    handle to s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s2
% a(1)=get(handles.s1,'Value');
% a(2)=get(handles.s4,'Value');
% a(3)=get(handles.s3,'Value');
% if sum(a)==0
%     set(handles.s2,'Value',1);
% end
listbox1_Callback(hObject, eventdata, handles)
% --- Executes on button press in s3.
function s3_Callback(hObject, eventdata, handles)
% hObject    handle to s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s3
% a(1)=get(handles.s1,'Value');
% a(2)=get(handles.s2,'Value');
% a(3)=get(handles.s4,'Value');
% if sum(a)==0
%     set(handles.s3,'Value',1);
% end
listbox1_Callback(hObject, eventdata, handles)
% --- Executes on button press in s4.
function s4_Callback(hObject, eventdata, handles)
% hObject    handle to s4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s4
% a(1)=get(handles.s1,'Value');
% a(2)=get(handles.s2,'Value');
% a(3)=get(handles.s3,'Value');
% if sum(a)==0
%     set(handles.s4,'Value',1);
% end
listbox1_Callback(hObject, eventdata, handles)


function StartTime_Callback(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartTime as text
%        str2double(get(hObject,'String')) returns contents of StartTime as a double
listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function StartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndTime_Callback(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndTime as text
%        str2double(get(hObject,'String')) returns contents of EndTime as a double
listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function EndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
try
delete(handles.Text);
delete(handles.Text2);
catch err
end


% --- Executes on button press in frplot.
function frplot_Callback(hObject, eventdata, handles)
% hObject    handle to frplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frplot

if get(handles.frplot,'value')
    set(handles.allnodes,'enable','on');
else
    set(handles.allnodes,'enable','off');
end
listbox1_Callback(hObject, eventdata, handles)


% --- Executes on button press in allnodes.
function allnodes_Callback(hObject, eventdata, handles)
% hObject    handle to allnodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of allnodes
listbox1_Callback(hObject, eventdata, handles)
