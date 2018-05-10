function [error_msg, equation_solutions, execution_time] = GaussJordan(a, b) %coefficients matrix 

% a is on form |a11 x1  a12 x2  a13 x3|
%              |a21 x1  a22 x2  a23 x3|
%              |a31 x1  a32 x2  a33 x3|
tic;
error_msg = '';
pivot = 1;
noOfEqu = size(a, 1);
%     scaling pivot
    [factor, cont, a, b] = find_factor(a, b, pivot);
    if cont == 1        
        for j = pivot : noOfEqu
            a (pivot, j ) = a (pivot, j ) * factor;
        end
        b (pivot, 1 ) = b (pivot, 1 ) * factor;

    for pivot = 1: noOfEqu
    %     forward elimination
        for row = pivot + 1 : noOfEqu
            factor = a(row, pivot);
            for col = pivot : noOfEqu
                a(row, col) = a(row, col) - factor * a(pivot, col);
            end 
                b(row, 1) = b(row, 1) - factor * b(pivot, 1);
        end 
        %  scaling next pivot
        row = pivot + 1;
        if (row <= noOfEqu)
            if row == noOfEqu % last element
                if a(row, row) == 0 % divide by 0
                    cont = 0;
                     b = NaN;
                else
                    factor = 1 / a(row, row);
                    cont = 1;
                end
                
            else
                [factor, cont, a, b] = find_factor(a, b, row);
            end
            if cont == 1
                for j = row:noOfEqu % divide row to scale pivot = 1 
                    a(row, j )  = a (row, j) * factor;
                end 
                b(row, 1 )  = b (row, 1) * factor;

                for j = 1 : row - 1  % sub prev rows
                    factor = a(j, row); 
                    for col = 1 : noOfEqu
                        a (j , col) = a (j, col) - factor * a (row, col);
                    end
                     b (j , 1) = b (j, 1) - factor * b (row, 1);
                end
            else
                b = NaN;
                error_msg = ['pivot ', num2str(row), ' could not be found '];
                break;
            end
        end 
    end
    
    else
    equation_solutions = NaN;
    error_msg = ['pivot ', num2srt(1) , ' could not be found'];
    end
    
execution_time = toc;
equation_solutions = NaN;

%     sol = b 
if isnan(b)
    equation_solutions = NaN;
else
    for i = 1 : noOfEqu
        if isnan(b (i,1))
            continue;
        end
        equation_solutions(1, i) = b (i,1);
    end
end

end

function [factor, cont, a, b] = find_factor(a, b, pivot)
    if (a(pivot, pivot) == 0) % pivot is zero switch rows
        max_index = get_max(a,pivot);
        temp = a(pivot, :);
        a(pivot, :) = a (max_index, :);
        a (max_index, :) = temp;
        temp = b(pivot, :);
        b(pivot, :) = b(max_index, :);
        b (max_index, :) = temp;
    end
    if a(pivot, pivot) == 0 % even after switching no pivot exists (all = 0)
        factor = NaN;
        cont = 0;
    else
        factor = 1 / a(pivot, pivot); 
        cont = 1;
    end
        

end

function [max_index] = get_max(a, pivot)
rows = size(a,2);
    max = a(pivot +1 , pivot);
    max_index = pivot;
    for j = pivot +1 : rows
        if a(j , pivot) >= max && a(j, max_index) ~= 0
            a(j , pivot)
            max_index = j;
            max = a(j , pivot);
        end
    end
end

    
    




