function [] = output_to_file(method_name, solutions, error_msg, extra_results, has_error_cols)
file_name = strcat(method_name,'.txt');
fileID = fopen(file_name,'wt');

% file format:
% -------------
% Method name:
% solutins:
% Iterations | sol1 | sol2 | so3 | ......
% ________________________________________
% 1          | 1512 | 585  | 5484| ......
% 2          | 2.36 | 5448 | 55  | ......
% ----------------------------------------
% Error : ...... OR
% RESULTS : .....
%_________________________________________
%_________________________________________


row_no = size(solutions, 1);
col_no = size(solutions, 2);
space_no = 10;
formatspec = 200;


fprintf(fileID,'%s: ',method_name);
fprintf(fileID,'\n');
fprintf(fileID,'\n');

% check if result table is empty 
if ~isnan(solutions)
    if size(solutions,1) <= 0 
    if (~isempty(error_msg))
        fprintf(fileID,'%s ',error_msg);
    else 
        fprintf(fileID,'%s ','No solutions');
    end
    else
    

    % generate headers

    headers = generate_headers(row_no, col_no, has_error_cols);
    if (row_no > 1) % more than 1 iteration >> we need to fill iteration col
        solutions = fill_iteration_col(solutions, row_no);
    end

    % get max width:
     max = get_max(headers , solutions, size(headers, 2), row_no, formatspec);
     

    % solutions:
    fprintf(fileID,'%s:\n\n','Solutions');

    % header
    header_length = write_header(max, headers , size(headers, 2), space_no, fileID);
    
    fprintf(fileID,'\n');
    draw_separator(header_length, fileID);

    % data
    write_data(max, solutions ,size(solutions, 2), row_no, formatspec, space_no, fileID);
    

    fprintf(fileID,'\n');
    draw_separator(header_length, fileID);

    %     check to print error or results

    if (isempty(error_msg))
        % extra results 
        fprintf(fileID,'\n');
        results (extra_results, fileID)
    else
        fprintf(fileID,'%s', error_msg);
    end

    end
else
   fprintf(fileID,'%s', 'No solutions');
end
fclose(fileID);
end


% --------------------------------------------------------------------------------------------------------------------------------------
function [headers] = generate_headers(rows_no, cols_no, has_error_cols)
j =1;
sol = 1;
error = 1;
if rows_no > 1 % iterations
    headers{1, j} = 'Iteration';
    j = j+1;
    cols_no = cols_no +1;
    for j = j : cols_no
        if mod(j,2) == 0 % solution header
            text1 = 'Solution';
            text2 = num2str(sol);
            sol = sol +1;
            text3 = [text1 , text2];
            headers {1, j} = text3;
        else % Error header
            
            text1 = 'Error';
            text2 = num2str(error);
            error = error +1;
            text3 = [text1 , text2];
            headers {1, j} = text3;
        end
    end 
else
    for j = j : cols_no
            if mod(j, 2) == 0 && has_error_cols == 1  % error
                text1 = 'error';
                text2 = num2str(error);
                error = error +1;
            else
                text1 = 'solution';
                text2 = num2str(sol);
                sol = sol +1;
            end
        text3 = [text1 , text2];
        headers {1, j} = text3;
    end    
    
end


end

% --------------------------------------------------------------------------------
function [max] = get_max( column_names_matrix , data_matrix, col_no, row_no, formatspec)
max = 0;
for i = 1 : col_no
    max(1,i) = length (column_names_matrix{1,i});
end

for i = 1 : row_no
    for j = 1 : col_no
        if isnan(data_matrix(i,j))
            continue;
        end
        if max(1, j) < length (num2str(data_matrix(i,j),formatspec))
           max(1,j) =  length (num2str(data_matrix(i,j),formatspec));
        end
    end
    
end

end
% -------------------------------------------------------------------------------
function [header_length] = write_header(max,column_names_matrix, col_no, space_no, fileID)
header_length = 0;
for i = 1 : col_no
    fprintf(fileID,'%s',column_names_matrix{1,i});
    gap = space_no + max(1,i) - length (column_names_matrix{1,i});
    for j = 1 : gap
        fprintf(fileID,' ');
    end
    header_length = header_length + max(1,i) + space_no;
end
end

% ---------------------------------------------------------------------------------

function [] = draw_separator(header_length, fileID)

for i = 1 : header_length
   fprintf(fileID,'_');  
end
fprintf(fileID,'\n');

end 

% ---------------------------------------------------------------------------------

function [] = write_data(max, data_matrix ,col_no, row_no, formatspec, space_no, fileID)
for i = 1 : row_no
    for j = 1 : col_no
        if isnan(data_matrix(i,j)) 
            fprintf(fileID,'%s','');
            gap = space_no + max(1,j);
        else
%             fprintf(fileID,'%s',num2str(data_matrix(i,j),formatspec));
            fprintf(fileID,'%s',num2str(data_matrix(i,j)));
            gap = space_no + max(1,j) - length (num2str(data_matrix(i,j)));
        end
        
        for k = 1 : gap 
            fprintf(fileID,' ');
        end
        
    end
     fprintf(fileID,'\n');
end

end

% ---------------------------------------------------------------------------------

function [] = results (results_matrix, fileID)

row_no = size(results_matrix, 1);
for i = 1 : row_no
    if isnan(results_matrix{i,1})
        continue;
    end
   fprintf(fileID,'%s: %s', results_matrix{i,1}, results_matrix{i,2});
   fprintf(fileID,'\n');
end

end
% ------------------------------------------------------------------------------------
function [data_matrix] =  fill_iteration_col(data_matrix, row_no)
    temp_matrix = data_matrix;
    cols = size (temp_matrix, 2);
    for i = 1 : row_no
        data_matrix (i,1) = i;
        data_matrix (i, 2:cols +1) = temp_matrix(i, 1:cols);
    end
end        
        
    
        