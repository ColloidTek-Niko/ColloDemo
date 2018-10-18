function varargout = ColloDemo(varargin)
% ColloDemo MATLAB code for ColloDemo.fig
%      ColloDemo, by itself, creates a new ColloDemo or raises the existing
%      singleton*.
%
%      H = ColloDemo returns the handle to a new ColloDemo or the handle guito
%      the existing singleton*.
%
%      ColloDemo('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ColloDemo.M with the given input arguments.
%
%      ColloDemo('Property','Value',...) creates a new ColloDemo or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ColloDemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ColloDemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ColloDemo

% Last Modified by GUIDE v2.5 20-Sep-2018 10:25:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColloDemo_OpeningFcn, ...
                   'gui_OutputFcn',  @ColloDemo_OutputFcn, ...
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
end


% --- Executes just before ColloDemo is made visible.
function ColloDemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ColloDemo (see VARARGIN)

% Choose default command line output for ColloDemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ColloDemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global ColloDemo
warning off

RUNTIME = false;


if RUNTIME
    userProfile = getenv('USERPROFILE');
    ColloDemo.appRoot = fullfile(userProfile, '\Roaming\Collo\ColloDemo\');
else
    ColloDemo.appRoot = cd;
end
ColloDemo.dir_opetus = [ColloDemo.appRoot '\opetus\'];
ColloDemo.dir_data = [ColloDemo.appRoot '\data\'];
ColloDemo.dir_softat = [ColloDemo.appRoot '\Softat\'];
ColloDemo.dir_main = [ColloDemo.appRoot];

ColloDemo.arvot  = 0;
ColloDemo.arvot_plot  = []; % Tässä indeksi numeoita arvoista jotka plotataan
ColloDemo.FG = 0;
ColloDemo.BWG = 0;
ColloDemo.colors = 'ygm';
ColloDemo.run = false;
ColloDemo.pause = false;
ColloDemo.show_Ccond = true;
ColloDemo.show_Cperm = true;

ColloDemo.axes1Position = handles.axes1.Position;
ColloDemo.axes2Position = handles.axes2.Position;
ColloDemo.Position      = handles.axes2.Position;
h = ColloDemo.Position(4);b1 = ColloDemo.axes1Position(2);b2 = ColloDemo.axes2Position(2);
ColloDemo.Position(4) = h+b1-b2;
ColloDemo.small(1) = ColloDemo.axes2Position(1)+ColloDemo.axes2Position(1)*0.7;
ColloDemo.small(2) = ColloDemo.axes1Position(2);
ColloDemo.small(3) = ColloDemo.axes2Position(3)*0.1;
ColloDemo.small(4) = ColloDemo.axes2Position(4)*0.1;


ColloDemo.egg = [];
ColloDemo.DeveloperMode = false;
ColloDemo.plotNow = false;

% Softa kansio hakemistoon
addpath(ColloDemo.dir_softat);

%Etsitään kentät ja tallennetaan kahvat niihin
PushButtons = [findall(gcf,'Style','Pushbutton')];
[~, I] = sort({PushButtons.Tag});
ColloDemo.PushButtons = PushButtons(I);

RadioButtons = [findall(gcf,'Style','Radiobutton')];
[~, I] = sort({RadioButtons.Tag});
ColloDemo.RadioButtons = RadioButtons(I);

Edit = [findall(gcf,'Style','Edit')];
[~, I] = sort({Edit.Tag});
ColloDemo.Edit = Edit(I);

set(ColloDemo.PushButtons(3),'Backgroundcolor','w');
set(ColloDemo.PushButtons(2),'Backgroundcolor','r');
set(ColloDemo.PushButtons(1),'Backgroundcolor','w');

axes(handles.axes3)
imshow('Logo.png')


% POISTETAAN KAIKKI TIEDOSTOT DATA KANSIOSTA!!!
if ~isempty(dir(fullfile(ColloDemo.dir_data, '\*.mat')))
    choice = questdlg('Poistetaanko kaikki tiedostot kansiosta data?', ...
        'Tiedostojen poisto', ...
        'Kyllä','Ei kiitos','Ei kiitos');
    switch choice
        case 'Kyllä'
            delete(fullfile(ColloDemo.dir_data, '*.mat'));
    end
end

% KYSYTÄÄN ColloDemoSETTI
choice = questdlg('Mikä ColloDemo-laite on käytössä?', ...
    'Demo-laitteen valinta', ...
    '1','2','2');
switch choice
    case '1', ColloDemo.setti = 1;
        ColloDemo.lowLimit = 55;
        ColloDemo.highLimit = 75;
    case '2', ColloDemo.setti = 2;
        ColloDemo.lowLimit = 30;
        ColloDemo.highLimit = 70;
end
ColloDemo.Edit(1).String = num2str(ColloDemo.lowLimit);
ColloDemo.Edit(2).String = num2str(ColloDemo.highLimit);
        
% timer
    handles.timer = timer('Name','MyTimer',            ...
                       'Period',0.3,                    ... 
                       'StartDelay',1,                 ... 
                       'TasksToExecute',inf,           ... 
                       'ExecutionMode','fixedSpacing', ...
                       'TimerFcn',{@timerCallback,handles.figure1}); 
   
    start(handles.timer);
end

% --- Outputs from this function are returned to the command line.
function varargout = ColloDemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function timerCallback(~,~,guiHandle)
global ColloDemo

if ColloDemo.run
    if ~isempty(guiHandle)
          % get the handles
          handles = guidata(guiHandle);
    end

    files = dir(fullfile(ColloDemo.dir_data, '*.mat'))

    if ColloDemo.arvot < length(files)   
        try
            [ Mag, Pha, f ] = GetRawData( ColloDemo.dir_data , 'INDEX', ColloDemo.arvot+1);
            ColloDemo.Mag = Mag;
            ColloDemo.Pha = Pha;
            ColloDemo.f = f;
            
            [F] = CalculateFeatureFG( Mag,f);
            ColloDemo.FG(ColloDemo.arvot+1) = F;
            [F ] = CalculateFeatureBWG( Mag, f);
            ColloDemo.BWG(ColloDemo.arvot+1) = F;
            ColloDemo.arvot = ColloDemo.arvot+1;
            
            if ~ColloDemo.pause
                ColloDemo.plotNow = true;
                ColloDemo.arvot_plot =  [ColloDemo.arvot_plot ColloDemo.arvot];
                if length(ColloDemo.arvot_plot) < 50
                    pituus = 50;
                    min_pituus = 1;
                else
                    pituus = length(ColloDemo.arvot_plot)+1;
                    min_pituus = pituus-50;
                end
            end
        end
    end
    % UUDET PLOTTAUKSET
    if ColloDemo.plotNow
        ColloDemo.plotNow = false;
        if ColloDemo.show_Cperm
            axis(handles.axes1, 'on')
            handles.axes1.Visible = 'on';
            FGkerroin = 10;

            clear yarvot
            % Otetaan eka numero pois ja kerrotaan sadalla
            numero = floor(ColloDemo.FG(ColloDemo.arvot_plot(1)));
            yarvot = (ColloDemo.FG(ColloDemo.arvot_plot) - numero) *FGkerroin;
            plot(handles.axes1,[1:length(ColloDemo.arvot_plot)], ...
                yarvot,'r.','MarkerSize',32)

            ylaraja = max(max(yarvot),min(yarvot)+(0.003*FGkerroin));
            alaraja = min(min(yarvot), max(yarvot)-(0.003*FGkerroin));

            axis(handles.axes1, ...
                [ColloDemo.arvot_plot(1)-0.5 length(yarvot)+0.5 ...
                alaraja ylaraja])

            if length(yarvot) < 7
                set(handles.axes1,'XTick',1:length(yarvot), ...
                    'XTickLabel',num2str([1:length(yarvot)]'))
            end
            grid(handles.axes1)
            ylabel(handles.axes1,'C-perm')
        else
            axis(handles.axes1, 'off');
        end
        if ColloDemo.show_Ccond
            axis(handles.axes2, 'on')
            BWGkerroin = 100;

            clear yarvot 
            yarvot = ColloDemo.BWG(ColloDemo.arvot_plot)*BWGkerroin;
            plot(handles.axes2,[1:length(ColloDemo.arvot_plot)],[yarvot],'b.','MarkerSize',32)
            ylaraja = max(max(yarvot),min(yarvot)+(0.01*BWGkerroin));
            alaraja = min(min(yarvot), max(yarvot)-(0.01*BWGkerroin));

            axis(handles.axes2, ...
                [ColloDemo.arvot_plot(1)-0.5 length(yarvot)+0.5 ...
                alaraja ylaraja])

            if length(yarvot) < 7
                set(handles.axes2,'XTick',1:length(yarvot), ...
                    'XTickLabel',num2str([1:length(yarvot)]'))
            end

            grid(handles.axes2)
            xlabel(handles.axes2,'Time')
            ylabel(handles.axes2,'C-cond')   
        else
            axis(handles.axes2, 'off');
        end
        % Jos molemmat false niin näytetään viimeisin raakadata
        if ~ColloDemo.show_Ccond && ~ColloDemo.show_Cperm
            plot(handles.axes1,ColloDemo.f, ColloDemo.Mag,'LineWidth', 1.5)
            grid(handles.axes1)

            axis(handles.axes1, ...
                [ColloDemo.f(1) ColloDemo.f(end) min(ColloDemo.Mag)-0.25 max(ColloDemo.Mag)+0.25])
        end     
    end 
end
end





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ColloDemo

stop(timerfind)
delete(timerfind)
% Hint: delete(hObject) closes the figure
delete(hObject);


system(['TaskKill /IM Collo.exe /F']);
system(['TaskKill /IM cmd.exe /F']);

files = dir(fullfile(ColloDemo.dir_data, '*.mat'));
if ~isempty(files)
    choice = questdlg('Poistetaanko kaikki tiedostot kansiosta data?', ...
            'Tiedostojen poisto', ...
            'Kyllä','Ei','Ei');

        switch choice
            case 'Kyllä'
                delete(fullfile(ColloDemo.dir_data, '*.mat'));
        end
end
rmpath(ColloDemo.dir_softat);
cd(ColloDemo.appRoot)
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Startti nappula
global ColloDemo

if ~ColloDemo.run
    ColloDemo.run = true;
    ColloDemo.pause = false;
    ColloDemo.arvot  = 0;
    ColloDemo.arvot_plot  = []; % Tässä indeksi numeoita arvoista jotka plotataan
    ColloDemo.FG = 0;
    ColloDemo.BWG = 0;

    low = num2str(ColloDemo.lowLimit);
    high = num2str(ColloDemo.highLimit);
    
    cd(ColloDemo.dir_data) % Työkansio data kansioon koska mittaukset sinne
%         switch ColloDemo.setti
%             case 1
                string = ['start /min ' ColloDemo.dir_data '\Collo.exe 1.mat ' ...
                    low ':' high ':2000 -a4 -e2 -k -r5 & exit']
                system(string)
                %system(['start /min ' ColloDemo.dir_data '\Collo.exe 1.mat 30:55:2000 -a4 -e2 -k -r5 & exit']);
                 
%             case 2
%                  system(['start /min ' ColloDemo.dir_data '\Collo.exe 1.mat 55:75:2000 -a4 -e2 -k -r5 & exit']);
%         end
        
        cd(ColloDemo.dir_main)
else
    if ColloDemo.pause
        ColloDemo.pause = false;        
    end
end
set(ColloDemo.PushButtons(3),'Backgroundcolor','w');
set(ColloDemo.PushButtons(2),'Backgroundcolor','w');
set(ColloDemo.PushButtons(1),'Backgroundcolor','g');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop nappula
global ColloDemo    
ColloDemo.egg 
try
    if ColloDemo.pause && sum(ColloDemo.egg == [2 1 3 2]) == 4
        gifPlayerGUI('Logo.gif',handles)
        ColloDemo.egg = [];
    end
end

ColloDemo.run = false;
ColloDemo.pause = false;
system(['TaskKill /IM Collo.exe /F']);    
system(['TaskKill /IM cmd.exe /F']);
    
delete(fullfile(ColloDemo.dir_data, '*.mat'));

set(ColloDemo.PushButtons(3),'Backgroundcolor','w');
set(ColloDemo.PushButtons(2),'Backgroundcolor','r');
set(ColloDemo.PushButtons(1),'Backgroundcolor','w');

end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Pause nappula
global ColloDemo
ColloDemo.egg = [];

if ColloDemo.pause
    ColloDemo.pause = false;
    
    set(ColloDemo.PushButtons(3),'Backgroundcolor','w');
    set(ColloDemo.PushButtons(2),'Backgroundcolor','w');
    set(ColloDemo.PushButtons(1),'Backgroundcolor','g');

else
    ColloDemo.pause = true;

    set(ColloDemo.PushButtons(3),'Backgroundcolor','r');
    set(ColloDemo.PushButtons(2),'Backgroundcolor','w');
    set(ColloDemo.PushButtons(1),'Backgroundcolor','w');
end

end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ColloDemo

if ~isempty(ColloDemo.arvot_plot)
    ColloDemo.plotNow = true;
end


switch(get(eventdata.NewValue,'Tag'))
    case 'radiobutton1' % C-cond & C-perm nappula
        ColloDemo.show_Ccond = true;
        ColloDemo.show_Cperm = true;
        axis(handles.axes1, 'on')
        axis(handles.axes2, 'on')
        handles.axes1.Position = ColloDemo.axes1Position;
        handles.axes2.Position = ColloDemo.axes2Position;

        if length(ColloDemo.egg) < 5
            ColloDemo.egg(end+1) = 1;
        else
            ColloDemo.egg = [];
        end
        
    case 'radiobutton2' % C-cond nappula
        ColloDemo.show_Ccond = true;
        ColloDemo.show_Cperm = false;

        handles.axes2.Position = ColloDemo.Position;
        axis(handles.axes1, 'off')
        axis(handles.axes2, 'on')
        cla(handles.axes1)

        if length(ColloDemo.egg) < 5
            ColloDemo.egg(end+1) = 2;
        else
            ColloDemo.egg = [];
        end

    case 'radiobutton3' % C-perm nappula
        ColloDemo.show_Ccond = false;
        ColloDemo.show_Cperm = true;

        axis(handles.axes1, 'on')
        axis(handles.axes2, 'off')
        cla(handles.axes2)
        handles.axes1.Position = ColloDemo.Position;

        if length(ColloDemo.egg) < 5
            ColloDemo.egg(end+1) = 3;
        else
            ColloDemo.egg = [];
        end
        
    case 'radiobutton4' % RawData
        ColloDemo.show_Ccond = false;
        ColloDemo.show_Cperm = false;

        axis(handles.axes1, 'on')
        axis(handles.axes2, 'off')
        cla(handles.axes2)
        handles.axes1.Position = ColloDemo.Position;
        
end

% Developer mode
try
    if ColloDemo.pause && sum(ColloDemo.egg == [2 1 3 2]) == 4
        gifPlayerGUI('Logo.gif',handles)
        ColloDemo.egg = [];
        
        if ~ColloDemo.DeveloperMode
ColloDemo.DeveloperMode = true;

ColloDemo.RadioButtonsOldPostition(:,1) = ColloDemo.RadioButtons(1).Position;
ColloDemo.RadioButtonsOldPostition(:,2) = ColloDemo.RadioButtons(2).Position;
ColloDemo.RadioButtonsOldPostition(:,3) = ColloDemo.RadioButtons(3).Position;

ColloDemo.RadioButtons(2).Position(2) = ColloDemo.RadioButtons(2).Position(2) + ColloDemo.RadioButtons(2).Position(4)*0.7;
ColloDemo.RadioButtons(3).Position(2) = ColloDemo.RadioButtons(3).Position(2) + ColloDemo.RadioButtons(3).Position(4);

ColloDemo.RadioButtons(4).Visible = 'on';
ColloDemo.PushButtons(4).Visible = 'on';
ColloDemo.Edit(1).Visible = 'on';
ColloDemo.Edit(2).Visible = 'on';
        end
    end
end
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global ColloDemo
ColloDemo.lowLimit = str2double(get(hObject,'String'));
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global ColloDemo
ColloDemo.highLimit = str2double(get(hObject,'String'));
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Exit nappi
global ColloDemo

ColloDemo.DeveloperMode = 'off';
ColloDemo.PushButtons(4).Visible = 'off';
ColloDemo.RadioButtons(4).Visible = 'off';

ColloDemo.RadioButtons(2).Position = ColloDemo.RadioButtonsOldPostition(:,2);
ColloDemo.RadioButtons(3).Position = ColloDemo.RadioButtonsOldPostition(:,3);

ColloDemo.Edit(1).Visible = 'off';
ColloDemo.Edit(2).Visible = 'off';
end
