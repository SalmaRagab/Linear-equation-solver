function [method_name, A, B, max_iteration, max_error, initial_values] = read_from_file (path)
fileID = fopen(path);
method_name = fgetl(fileID);

[matrix] = read_matrix (fileID);
[A, B] = divide_matrix(matrix);


max_iteration = fgetl(fileID);
if ~ischar(max_iteration) %  no max iterations >> stop 
    max_iteration = NaN;
    max_error = NaN;
    initial_values = NaN;
else % max iterations exist >> read max error
    max_error = fgetl(fileID);
    if ~ischar(max_error) % no max error >> stop
        max_error = NaN;
        initial_values = NaN;
    else % max error exist >> read initials
        line = fgetl(fileID); % initial values
        initial_values = get_initials(line);
    end
end
% method_name
% A
% B
% max_iteration
% max_error
% initial_values

end


function [matrix] = read_matrix (fileID)
matrix = NaN;
row_no = 1;
col_no = 1;
line = fgetl(fileID);

while ischar(line)
    if (size(line,2) == 0) % empty line
        line = fgetl(fileID);
        continue;
    end
    if (line(1:1)~= '-') % reading matrix
        length = size(line, 2);
        num = ' ';
        matrix(row_no , :) = NaN;
        for i = 1 : length    
            char = line(i:i);
            
            %  matrix
            if char == ' ' % new number
                
                if num ~= ' ' % not empty
                    matrix(row_no, col_no) = str2double(num);
                else
                    matrix(row_no, col_no) = NaN;
                end
                col_no = col_no +1;
                num =' ';
            else % cont number
                num = strcat(num, char);
            end

        end
        if num ~= ' ' % not empty
           matrix(row_no, col_no) = str2double(num);
        else
           matrix(row_no, col_no) = NaN;
        end

    else
        break;  
    end
    row_no = row_no +1;
    col_no = 1;
    line = fgetl(fileID);
end

end

function [A, B] = divide_matrix(matrix)
if isnan(matrix)
    A = NaN;
    B = NaN;
    return;
end
[row_no , col_no] = size(matrix);
A(: , :) = matrix (:,  1 : (col_no - 1));
B( :, 1) = matrix (: , col_no) ;

end

function [initials] = get_initials(line)
initials = NaN;
i = 1;
length = size(line, 2);
num = '';
counter = 1;
for i = 1 : length % whole line
    char = line(i:i);
    if (char ~= ' ') % same number
        num = strcat(num, char);
    else % new num >> add last 
        if num ~= ' ' % not empty
           initials(counter, 1) = str2double(num);    
        else
           initials(counter, 1) = NaN;
        end
        counter = counter +1;
        num = '';
    end
end
    if num ~= ' ' % not empty
        initials(counter, 1) = str2double(num);    
    else
        initials(counter, 1) = NaN;
    end
        
    

end


