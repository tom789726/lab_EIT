function varargout = EIT_mesh_GUI(varargin)
% EIT_MESH_GUI MATLAB code for EIT_mesh_GUI.fig
%      EIT_MESH_GUI, by itself, creates a new EIT_MESH_GUI or raises the existing
%      singleton*.
%
%      H = EIT_MESH_GUI returns the handle to a new EIT_MESH_GUI or the handle to
%      the existing singleton*.
%
%      EIT_MESH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIT_MESH_GUI.M with the given input arguments.
%
%      EIT_MESH_GUI('Property','Value',...) creates a new EIT_MESH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EIT_mesh_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EIT_mesh_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EIT_mesh_GUI

% Last Modified by GUIDE v2.5 27-Sep-2021 14:26:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EIT_mesh_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EIT_mesh_GUI_OutputFcn, ...
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


% --- Executes just before EIT_mesh_GUI is made visible.
function EIT_mesh_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EIT_mesh_GUI (see VARARGIN)

% Choose default command line output for EIT_mesh_GUI
handles.output = hObject;

clc;
set(handles.axes_Main,'XTick',[],'YTick',[]);
set(handles.edit_Status,'String','Welcome');



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EIT_mesh_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EIT_mesh_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_Status_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Status as text
%        str2double(get(hObject,'String')) returns contents of edit_Status as a double


% --- Executes during object creation, after setting all properties.
function edit_Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path] = uigetfile({'*.*'});
path_f = fullfile(path,filename)
handles.path = path_f;

img = imread(path_f);


% set(handles.axes_Main,'Units','pixels');
% resizePos = get(handles.axes_Main,'Position');
% img = imresize(img,[resizePos(3) resizePos(3)]);
% % axes(handles.axes_Main);
% % imshow(img);
% % set(handles.axes_Main,'Units','normalized');

axes(handles.axes_Main);
imshow(img,[]);
set(handles.edit_Status,'String','Image Loaded');


% Pass Handles
handles.img = img;
guidata(hObject, handles);




function edit_Num1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Num1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Num1 as text
%        str2double(get(hObject,'String')) returns contents of edit_Num1 as a double


% --- Executes during object creation, after setting all properties.
function edit_Num1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Num1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Button_Start.
function Button_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get mesh type
if ~isfield(handles,'str') 
    h=get(handles.uibuttongroup1,'SelectedObject');
    type = get(h,'String');
    handles.type = type;    
else
    type = handles.type;
end

% Get electrode number
h=get(handles.uibuttongroup2,'SelectedObject');
numL = get(h,'String');
handles.numL = str2double(numL);

tic % timer

if (strcmp(type,'Joshua'))
    disp('Joshua');
    [mesh,node] = mesh_josh(hObject,handles); % Function for Joshua Tree Mesh
else
    disp('Classic');
    [mesh,node] = mesh_class(hObject,handles);
end

tick1 = toc; %Timer ends


% set(handles.axes_Main,'Units','pixels');
% resizePos = get(handles.axes_Main,'Position');


axes(handles.axes_Main);
F = getframe(gca);
[img,map] = frame2im(F);
img = img(:,:,1);
% img = imresize(img,[resizePos(3) resizePos(3)]);
mask = (img>0);
img(mask) = 1;

% Display
% imshow(img,[]); 
% set(handles.axes_Main,'Units','normalized');

% Broadcast
set(handles.edit_Status,'String',['Meshing Completed, Time= ',num2str(tick1)]);


% Pass handles
handles.img = img;
handles.mesh = mesh;
handles.node = node;
guidata(hObject, handles);



function edit_Num2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Num2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Num2 as text
%        str2double(get(hObject,'String')) returns contents of edit_Num2 as a double


% --- Executes during object creation, after setting all properties.
function edit_Num2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Num2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Num3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Num3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Num3 as text
%        str2double(get(hObject,'String')) returns contents of edit_Num3 as a double


% --- Executes during object creation, after setting all properties.
function edit_Num3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Num3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb1.
function rb1_Callback(hObject, eventdata, handles)
% hObject    handle to rb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb1


% --- Executes on button press in rb2.
function rb2_Callback(hObject, eventdata, handles)
% hObject    handle to rb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb2


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=get(handles.uibuttongroup1,'SelectedObject');
str = get(h,'String');

set(handles.edit_Status,'String',str);
handles.type = str;
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes_Main_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function [mesh,node] = mesh_josh(hObject,handles)

% set(handles.edit_Status,'String','IN!');

sz = get(handles.edit_Num2,'String');
sz = str2double(sz);
img_bw = ones(sz);


%% Data Format Definition
% L_max = get(handles.edit_Num1,'String'); % no. of electrodes
% L_max = str2double(L_max);
L_max = 32; % no. of electrodes (32)
N = L_max*(L_max-1)/2; % no. of elements

space = 32/handles.numL; % For re-mapping, space = 1(32)/ 2(16)/ 4(8)
if (space>1)
    disp(['re-mapping, electrode num =',num2str(32/space)]);
    disp(num2str(space));
end


mid = sz/2; % Center
mesh = zeros(4,N); % element matrix, NULL = 0
node = zeros(5,N); % Node matrix, (theta/ring/r) --> (x,y)

axes(handles.axes_Main);
imshow(img_bw,[]);

%% Test: level 1
sz_ring = 8; % L, no. of elements at that level
sz_ring_mesh = sz_ring/space; % replace sz_ring for mesh matrix, node matrix unchanged

R = get(handles.edit_Num3,'String');
R = str2double(R);
r = sqrt(sz_ring/N)*R;


% element matrix (node assign)
mesh(1,1:sz_ring) = 1;
mesh(2,1:sz_ring) = (1:sz_ring)+1;
mesh(3,1:sz_ring) = (1:sz_ring)+2;
mesh(4,1:sz_ring) = 0;
% fine tune element #8
mesh(3,sz_ring) = 2;


mesh = sort(mesh);

% node matrix (coordinate assign)
node(:,1) = 0; 
node(4:5,1) = mid; % node #1: center point

idx_node = 2:sz_ring+1;
node(1,idx_node) = (0:sz_ring-1)*360/sz_ring; % theta (in degree)
node(2,idx_node) = 1; % level 1
node(3,idx_node) = r;
node(4,idx_node) = mid+ round( node(3,idx_node).*cosd( node(1,idx_node) ) ); % rcos()
node(5,idx_node) = mid+ round( node(3,idx_node).*sind( node(1,idx_node) ) ); % rsin()

% set(handles.edit_Status,'String','Level 1 completed.');
% disp('Level 1 complete.');

%% Test: level 2 & so-on
map_ring = [8,8,8,8,16,16,16,16,24,24,24,24,24,24,32,32,32,32,32,32,32,32];
map_radius = zeros(size(map_ring));
map_radius(1) = r;

for j = 2:22 % 22 = size(map_ring)
    
    sz_ring = map_ring(j);
    r2 = sqrt( sz_ring* (R^2/N) + r^2 );
    map_radius(j) = r2; % store radius
    % r = r2;
    
    % element matrix (node assign)
    idx_mesh_loc = sum(map_ring(1:j-1) );  % shift to local co-ordinate
    idx_node_loc = 9 + sum( map_ring(2:j-1) )*2; % shift to local co-ordinate
    
    idx_mesh = idx_mesh_loc+1 : sum(map_ring(1:j) );
    mesh(1,idx_mesh) = idx_node_loc + (1:sz_ring);
    mesh(2,idx_mesh) = idx_node_loc + (1:sz_ring) + 1;
    mesh(3,idx_mesh) = idx_node_loc + (1:sz_ring) + sz_ring;
    mesh(4,idx_mesh) = idx_node_loc + (1:sz_ring) + sz_ring + 1;
    
    % fine tune element #8
    mesh(2,idx_mesh(end)) = idx_node_loc + 1;
    mesh(4,idx_mesh(end)) = idx_node_loc + sz_ring + 1;
    
    mesh = sort(mesh);
    
    % node matrix (coordinate assign)
    idx_node_r1 = idx_node_loc + (1:sz_ring);
    idx_node_r2 = idx_node_loc + (1:sz_ring) + sz_ring;
    
    % theta (in degree)
    node(1,idx_node_r1) = (1:sz_ring)*360/sz_ring - (360/sz_ring)/2 * mod(j-1,2); % level 1
    node(1,idx_node_r2) = (1:sz_ring)*360/sz_ring - (360/sz_ring)/2 * mod(j-1,2); % level 2
    % ring
    node(2,idx_node_r1) = j-1;
    node(2,idx_node_r2) = j;
    % radius
    node(3,idx_node_r1) = r;
    node(3,idx_node_r2) = r2;
    % Coordinates
    idx_node = idx_node_r1(1):idx_node_r2(end);
    node(4,idx_node) = mid + round( node(3,idx_node).*cosd(node(1,idx_node)) );
    node(5,idx_node) = mid + round( node(3,idx_node).*sind(node(1,idx_node)) );
    
%     set(handles.edit_Status,'String',['Level ',num2str(j),' completed.']);
%     disp(['Level ',num2str(j),' complete.']);
    
    r = r2;
end


%% Draw circle
for row = 1:sz
    for col = 1:sz
        flag = sqrt((row-mid)^2+(col-mid)^2);
        for j = 1:size(map_radius,2)
            r = map_radius(j);
            if ( abs(flag - (r)) <= 1 )
                img_bw(row,col) = 0;
            end
        end
    end
end


%% Display (Complete)


imshow(img_bw,[]);

for i = 1:8
    hold on 
    plot([mid,node(4,i+1)], [mid,node(5,i+1)],'k','LineWidth',2);
end


for j = 2:22
    idx_mesh_loc = sum(map_ring(1:j-1) );  % shift to local co-ordinate
        %% Draw lines
    idx_mesh = idx_mesh_loc+1 : sum(map_ring(1:j) );
    for i = idx_mesh
        hold on
        idx_line = mesh([1,3],i);
        plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
        if (i==idx_mesh(end)) %% For speed up
           idx_line = mesh([2,4],i);
           plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
        end
%         pause(0.1);
    end
end

guidata(hObject, handles);

function [mesh,node] = mesh_class(hObject,handles)




% --- Executes on button press in rb3.
function rb3_Callback(hObject, eventdata, handles)
% hObject    handle to rb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb3
