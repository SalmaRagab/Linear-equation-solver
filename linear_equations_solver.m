function varargout = linear_equations_solver(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @linear_equations_solver_OpeningFcn, ...
                   'gui_OutputFcn',  @linear_equations_solver_OutputFcn, ...
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


% --- Executes just before linear_equations_solver is made visible.
function linear_equations_solver_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for linear_equations_solver
handles.output = hObject;
set(handles.equ_table, 'visible', 'off');
set(handles.method_staticText, 'visible', 'off');
set(handles.methods_menu, 'visible', 'off');
set(handles.error_no, 'visible', 'off');
set(handles.error_table, 'visible', 'off');
set(handles.maxIterations_static, 'visible', 'off');
set(handles.maxIterations_edit, 'visible', 'off');
set(handles.maxError_static, 'visible', 'off');
set(handles.maxError_edit, 'visible', 'off');
set(handles.submit_btn, 'visible', 'off');
set(handles.initialValues_static, 'visible', 'off');
set(handles.initialValues_table, 'visible', 'off');
set(handles.error_initial, 'visible', 'off');
set(handles.error_upload, 'visible', 'off');



% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = linear_equations_solver_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




function set_visible (handles)
    set(handles.equ_table, 'visible', 'on');
    set(handles.uploadData_btn, 'visible', 'on');
    set(handles.method_staticText, 'visible', 'on');
    set(handles.methods_menu, 'visible', 'on');
    set(handles.submit_btn, 'visible', 'on');


% --- Executes on button press in ge_button.
function ge_button_Callback(hObject, eventdata, handles)
global no_of_equations

set (handles.error_no, 'visible', 'off');
noe_string = get(handles.noe_edit, 'String');
[isCorrect, error, no_of_equations] = validate(noe_string, 'no#'); % check no entered is a valid number

if isCorrect == 0 % error
    set (handles.error_no, 'String', error);
    set (handles.error_no, 'visible', 'on');
       
else % correct >> create equations
    generate_equation_table(handles);
    fill_equ_table_coeffs(handles);
    update_initial_table(handles); 

    
end

function [] = update_initial_table(handles)
global no_of_equations;
 data{no_of_equations, 1} = [];
 set(handles.initialValues_table, 'Data',data);

function [] = fill_equ_table_coeffs(handles)
 global no_of_equations;
 table = handles.equ_table; 

row_counter = 1;
for i = 1 : 2 * no_of_equations % rows
    x_counter = 1; % coeff no
    if (mod(i,2) == 1) % empty row 
         for j = 1 :  2*no_of_equations+2
             tableData{i,j} = '';
         end
    else
        for j = 1 :  2*no_of_equations+2 % fill row
                if (j == 1) % equ no
                    coeff = strcat('Equ',num2str(row_counter));
                    coeff = strcat(coeff,': ');
                    tableData{i,j} = coeff;
                else % coeffs
                    coeff = strcat('   X',num2str(x_counter));
                    if (j ~= 2 * no_of_equations+1) % not last x
                        coeff = strcat(coeff, ' +');
                    else % last x
                        coeff = strcat(coeff, ' =');
                    end
                    if (mod(j,2) == 1 ) % coeff cell
                         tableData{i,j} = coeff;
                         x_counter = x_counter +1;
                    else % no cell
                      editable_array(j) = 1;
                      columnformat={'numeric'};
                    end;
                end
                
        end
        row_counter = row_counter +1;
    end
    
end
 set(table,'ColumnEditable',logical(editable_array),'ColumnFormat',columnformat);
 set(table,'data',tableData);


function [] = generate_equation_table(handles)
    global no_of_equations; 
     set_visible(handles);
     table = handles.equ_table; 
     set(table , 'ColumnName',[]);
     set(table , 'rowName',[]); 
     data{no_of_equations, 2*no_of_equations+2} = [];
     set(table, 'Data',data);
     data2{no_of_equations, 2} = []; % for initial values table
     set(handles.initialValues_table, 'Data', data2);
     tableData = get(table,'data');
     editable_array = zeros (1,2*no_of_equations+1);


% --- Executes during object creation, after setting all properties.
function error_no_CreateFcn(hObject, eventdata, handles)


% --- Executes when selected cell(s) is changed in equ_table.
function equ_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to equ_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function equ_table_CreateFcn(hObject, eventdata, handles)
set(hObject, 'ColumnWidth', {45});
set(hObject, 'RowStriping', 'off');


% --- Executes on button press in uploadData_btn.
function uploadData_btn_Callback(hObject, eventdata, handles)
global no_of_equations;
set(handles.error_upload, 'visible', 'off');
[FileName,PathName] = uigetfile;
if(FileName ~= 0)
    path = strcat(PathName, FileName);
    [method_name, A, B, max_iteration, max_error, initial_values] = read_from_file(path);
    [rows_no, cols_no] = size(A);
     no_of_equations = max(rows_no, cols_no - 1);
    err = fill_method_name(handles, method_name);
    if (err == 0) % method exist >> proceed with data
        generate_table_from_file(handles, A, B);
        fill_extra(handles, max_iteration, max_error, initial_values);
    else
        set(handles.error_upload, 'String', 'Error in Method name');
        set(handles.error_upload, 'visible', 'on');
    end

        
end

function [] = generate_table_from_file(handles, A, B)
global no_of_equations;
% check rows = cols 
[rows_no, cols_no] = size(A);
no_of_equations = max(rows_no, cols_no -1 );

%set it gui
set(handles.noe_edit, 'String', num2str(no_of_equations));
set_visible (handles);

%table
generate_equation_table(handles);
fill_equ_table_coeffs(handles);
fill_equation_table_data(handles,A, B);

function [] = fill_equation_table_data(handles, A, B)
global no_of_equations;
table = handles.equ_table;
tableData = get(table, 'Data');
row_counter = 1;
col_counter = 1;

% fill A and B with NaN
A_temp = A;
B_temp = B;
A(1 : no_of_equations, 1 : no_of_equations) = NaN;
B(1 : no_of_equations, 1) = NaN;

A(1 : size(A_temp,1) , 1 : size(A_temp,2)) = A_temp(: ,:  );
B(1 : size(B_temp,1) , 1 : size(B_temp,2)) = B_temp(: ,:  );



for i = 1 : 2 * no_of_equations % rows
    if (mod(i,2) == 1) % empty row 
    else
        for j = 1 :  2*no_of_equations+2 % fill row
                if (j == 1) % equ no
                else % coeffs
                    if (mod(j,2) == 1 ) % coeff cell
                    else % no cell
                        if j == 2*no_of_equations+2 % last cell >> B matrix
                            tableData{i, j} = B(row_counter, 1); 
                        else % A matrix
                          tableData{i, j} = A(row_counter, col_counter); 
                          col_counter = col_counter +1;
                        end
                    end;
                end
                
        end
        row_counter = row_counter +1;
        col_counter = 1;
    end
    
end
set(table, 'Data', tableData);

function [err] = fill_method_name(handles, method_name)
drop_down = handles.methods_menu;
err = 0;
switch method_name
    case 'Gaussian-elimination'
        set(drop_down, 'value' ,1);
        hide_for_seidel(handles);
    case 'LU decomposition'
        set(drop_down, 'value' ,2);
        hide_for_seidel(handles);
    case 'Gaussian-Jordan'
        set(drop_down, 'value' ,3);
        hide_for_seidel(handles);
    case 'Gauss-Seidel'
        set(drop_down, 'value' ,4);
        display_for_seidel(handles);
    case 'All'
        set(drop_down, 'value' ,5);
        display_for_seidel(handles);
    otherwise 
        err = 1;
        
end

function [] = fill_extra(handles, max_iteration, max_error, initial_values)
global no_of_equations;
if ~isnan(max_iteration) % if nan leave default
    set(handles.maxIterations_edit, 'String', max_iteration);
end
if ~isnan(max_error) % if nan leave default
    set(handles.maxError_edit, 'String', max_error);
end

initial_table = handles.initialValues_table;
data{no_of_equations, 1} = [];
length = size(initial_values, 1);
for i = 1 : size(data,1) 
    try
        data{i, 1} = initial_values(i, 1);
    catch Exception % initial value < data 
        data{i, 1} = NaN;
    end
end

set(initial_table, 'Data', data);






% --- Executes during object creation, after setting all properties.
function uploadData_btn_CreateFcn(hObject, eventdata, handles)


% --- Executes on selection change in methods_menu.
function methods_menu_Callback(hObject, eventdata, handles)

if get(hObject, 'value') == 4 ||  get(hObject, 'value') == 5 % seidel or all >> display 
    display_for_seidel(handles);

else % hide
    hide_for_seidel(handles);
end


function [] = display_for_seidel(handles)
global no_of_equations;
 table = handles.initialValues_table; 
 data{no_of_equations, 1} = [];
 editable_array = [1];
 numeric = {'numeric'};
 set(table, 'Data',data);
 set(table,'ColumnEditable',logical(editable_array),'ColumnFormat',numeric);
 set(table,'data',data);
 set(table , 'ColumnName',[]);
 
 set(table , 'visible','on');
 set(handles.maxIterations_static, 'visible', 'on');
set(handles.maxIterations_edit, 'visible', 'on');
set(handles.maxError_static, 'visible', 'on');
set(handles.maxError_edit, 'visible', 'on');
set(handles.initialValues_static, 'visible', 'on');

function [] = hide_for_seidel(handles)
set(handles.maxIterations_static, 'visible', 'off');
set(handles.initialValues_table , 'visible','off');
set(handles.maxIterations_edit, 'visible', 'off');
set(handles.maxError_static, 'visible', 'off');
set(handles.maxError_edit, 'visible', 'off');
set(handles.initialValues_static, 'visible', 'off');


% --- Executes during object creation, after setting all properties.
function methods_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methods_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in submit_btn.
function submit_btn_Callback(hObject, eventdata, handles)
set(handles.error_initial, 'visible', 'off');
set(handles.error_table, 'visible', 'off');
data = get(handles.equ_table, 'data');
no_of_rows = size (data,1);
no_of_cols = size (data,2);

[A, B, cont, row_counter, col_counter] = generate_matrix(no_of_rows, no_of_cols, data);
% A = cell2mat(A);
% B = cell2mat(B);

    if (cont)
        method_name = get(handles.methods_menu,'value');
        if strcmp(get(handles.initialValues_static,'visible'),'on') % seidel method >> check initial values
        [initial, error_msg_in] = get_initial(handles);
        else 
            error_msg_in = ''; %empty
            initial = NaN;
        end
        if ~isempty(error_msg_in) % there is error in initial values
            set(handles.error_initial, 'String', error_msg_in);
            set(handles.error_initial,'visible', 'on');
        else
            
            no_of_it = get(handles.maxIterations_edit,'String');
            [correct,error_it, no_of_it] = validate(no_of_it, 'no#');
            if correct == 1 % no_of_it correct >> check max error
                 error = get(handles.maxError_edit,'String');
                [correct, error_msg_err, error] = validate(error, '+ve');
            if correct == 1 % max error correct  >> send to controller
                error_msg_contr = controller (A , B , method_name,initial,no_of_it,error);
                if ~isempty(error_msg_contr) % there is error >> display it and wait for new submission
                    set(handles.error_table, 'String', error_msg_contr);
                    set(handles.error_table,'visible', 'on');
                end  
            else % max error not correct 
                 set(handles.error_initial, 'String', ['Error ' error_msg_err]);
                 set(handles.error_initial,'visible', 'on');
            end
            else % error in no_of_it
                 set(handles.error_initial, 'String', ['Iteration ' error_it]);
                 set(handles.error_initial,'visible', 'on');
            end
            
  
        end
       
    else % error in equations coeff
        x1 = 'Error in equation ';
        x2 = num2str(row_counter);
        x3 = ' coeff of X';
        x4 = num2str(col_counter);
        error = [x1 x2 x3 x4];
        set(handles.error_table, 'String', error);
        set(handles.error_table,'visible', 'on');
    end
    
    
    
function [A, B, cont, row_counter, col_counter] = generate_matrix(no_of_rows, no_of_cols, data)
A = NaN;
B = NaN;
cont = 1;
row_counter = 1;
col_counter = 1;
for i = 1 : no_of_rows
    if (~cont)
        break;
    end
    if mod(i,2) == 1 % empty
        continue;
    end
    for j = 1 : no_of_cols
        if mod(j,2) == 0 %data
            if cellfun('isempty',data(i, j)) || cellfun(@(C) isequaln(C, NaN), data(i, j))
                cont = 0;
                break;
            else
                if (j == no_of_cols) % b matrix
                    B(row_counter,1) = (data{i, j});
                    row_counter = row_counter +1;
                    col_counter = 1;
                else
                    A(row_counter,col_counter) = (data{i, j});
                    col_counter = col_counter+1;
                end
            end
        end
    end
end  

        
function[initials, error] = get_initial(handles)
 data = get(handles.initialValues_table,'Data');
 error ='';
 initials = NaN;
 cont = 1;
 for i = 1 : size (data,1)
     data(i, 1)
     if cellfun('isempty',data(i, 1)) || cellfun(@(C) isequaln(C, NaN), data(i, 1))
         cont = 0;
         break;
     else
         initials(i, 1) = data{i, 1};
     end
 end
 
 if (~cont)
     error1 = 'Error in initial values';
     error = [error1 i];
 end     



function maxIterations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxIterations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIterations_edit as text
%        str2double(get(hObject,'String')) returns contents of maxIterations_edit as a double


% --- Executes during object creation, after setting all properties.
function maxIterations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIterations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxError_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxError_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxError_edit as text
%        str2double(get(hObject,'String')) returns contents of maxError_edit as a double


% --- Executes during object creation, after setting all properties.
function maxError_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxError_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function initialValues_table_CreateFcn(hObject, eventdata, handles)
set(hObject, 'ColumnWidth', {25});


% --- Executes during object creation, after setting all properties.
function noe_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noe_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noe_edit_Callback(hObject, eventdata, handles)
% hObject    handle to noe_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noe_edit as text
%        str2double(get(hObject,'String')) returns contents of noe_edit as a double


% --- Executes during object deletion, before destroying properties.
function noe_edit_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to noe_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
