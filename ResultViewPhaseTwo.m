function varargout = ResultViewPhaseTwo(varargin)
% RESULTVIEWPHASETWO MATLAB code for ResultViewPhaseTwo.fig
%      RESULTVIEWPHASETWO, by itself, creates a new RESULTVIEWPHASETWO or raises the existing
%      singleton*.
%
%      H = RESULTVIEWPHASETWO returns the handle to a new RESULTVIEWPHASETWO or the handle to
%      the existing singleton*.
%
%      RESULTVIEWPHASETWO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTVIEWPHASETWO.M with the given input arguments.
%
%      RESULTVIEWPHASETWO('Property','Value',...) creates a new RESULTVIEWPHASETWO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResultViewPhaseTwo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResultViewPhaseTwo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResultViewPhaseTwo

% Last Modified by GUIDE v2.5 14-May-2017 02:32:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResultViewPhaseTwo_OpeningFcn, ...
                   'gui_OutputFcn',  @ResultViewPhaseTwo_OutputFcn, ...
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


% --- Executes just before ResultViewPhaseTwo is made visible.
function ResultViewPhaseTwo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResultViewPhaseTwo (see VARARGIN)

% Choose default command line output for ResultViewPhaseTwo
handles.output = hObject;


handles.fileName = '';
handles.iterations = [];
handles.roots = [];
handles.is_seidel = 0; %if Seidel, it'll be (1)


set(handles.results_panel, 'visible', 'off');
set(handles.analysis_panel, 'visible', 'off');
set(handles.results_btn, 'visible', 'off');
set(handles.analysis_btn, 'visible', 'off');
set(handles.viewResults_btn, 'visible', 'on');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ResultViewPhaseTwo wait for user response (see UIRESUME)
% uiwait(handles.ResultView);


% --- Outputs from this function are returned to the command line.
function varargout = ResultViewPhaseTwo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in viewResults_btn.
function viewResults_btn_Callback(hObject, eventdata, handles)
% hObject    handle to viewResults_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.viewResults_btn, 'visible', 'off');
set(handles.results_btn, 'visible', 'on');
set(handles.results_panel, 'visible', 'on');

if handles.is_seidel == 1 
    set(handles.analysis_btn, 'visible', 'on');
end;


fileID = fopen(handles.fileName);

% line = fgetl(fileID);
% sprintf('\n');
% set(handles.results_text,'String',line);
%  t = uitable;
%  set(handles.results_table,'Position',[10 10 1000 500]);
 tableData = get(handles.results_table,'data');
 i = 1;
while ~feof(fileID)
    line = fgetl(fileID);
    if(~isempty(line) && line(1) == '_')
        continue;
    end;
    C = strsplit(line);
    [row,col] = size(C);
    for j = 1 : col
         tableData{i,j} = char(C{1,j});
    end;
   
    i = i+1;
end;
fclose(fileID);
set(handles.results_table,'Data',tableData);
set(handles.results_table , 'ColumnName',[]);
set(handles.results_table , 'rowName',[]);
set(handles.results_table,'ColumnWidth',{100});
set(handles.results_table,'BackgroundColor',[0.9 0.9 0.9]);

    

% --- Executes on button press in results_btn.
function results_btn_Callback(hObject, eventdata, handles)
% hObject    handle to results_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.analysis_panel, 'visible', 'off');

set(handles.results_panel, 'visible', 'on');


% --- Executes on button press in analysis_btn.
function analysis_btn_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.results_panel, 'visible', 'off');

set(handles.analysis_panel, 'visible', 'on');


axes(handles.analysis_axes); %The number of iterations vs error graph

[length, width] = size (handles.iterations); %- - - - - >> Width = 5
[l, w] = size (handles.roots);

iterations_matrix = handles.iterations;
roots_matrix = [];

% x = [];
y = [];

m = 0;

k = 1;
it = 0;


for j = 1:w
    roots_matrix = [];
    for i = 1:width
%     iterations_matrix(i)= handles.iterations(k, i);
        m = m + 1;       
    
        if (isempty(iterations_matrix(i)) == 0) %not empty
            roots_matrix(i) = handles.roots(i,k);
        
%         x(m) = iterations_matrix(i);
            y(m) = roots_matrix(i);
        
%         x{m} = cell2mat(iterations_matrix(i));
%         y{m} = cell2mat(roots_matrix(i));
        end
    
    end
    k = k + 1;
    plot(iterations_matrix, roots_matrix, 'color', rand(1,3), 'DisplayName',  num2str(j', 'X %-d'), 'LineWidth', 2);
    
    hold on
end

xlabel('Number of iterations') % x-axis label
ylabel('Solutions') % y-axis label
legend('show');
