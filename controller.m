function [err_msg] = controller (a , b , method,initial,no_of_it,error)

err_msg = ''; 
if(det(a) == 0)
    err_msg = 'ERROR SYSTEM HAS INFINITE NO. OF SOLUTIONS OR HAS NO SOLUTION';
else
      call_evaluating_methods(a , b , method , no_of_it,error,initial);
end;

function  call_evaluating_methods(a , b , method , no_of_it,error,initial)
 method_names = {'Gauss Elimination Results' ; 'Gauss Jordan Results';'LU Decomposition Results';'Gauss Seidel Results'};
 is_seidel = 0;
 roots = {};
 iterations = 0;
switch method
    case 1 %Gaussian-elimination
         fileName = method_names{1};
         call_gauss_elimination(a ,b , fileName);
       
    case 2 %LU decomposition
          fileName = method_names{3};
          call_lu_decomp(a,b,fileName);
    
    case 3 %Gaussian-Jordan
         fileName = method_names{2};
         call_gauss_jordan(a,b,fileName);
       
    case 4 %Gauss-Seidel
          fileName = method_names{4};
        [roots , iterations] = call_gauss_seidel(a ,b ,initial, no_of_it,error, fileName);
      
    case 5 %ALL
        call_gauss_elimination(a ,b, method_names{1});
        call_lu_decomp(a,b, method_names{3});
        call_gauss_jordan(a,b, method_names{2});
        [roots , iterations] = call_gauss_seidel(a, b, initial, no_of_it,error, method_names{4});
        fileName = 'allResults';
        is_seidel = 1;
        join_files(method_names ,strcat(fileName,'.txt'));
        deleteFiles(method_names);
end;
open_result_view(strcat(fileName,'.txt'),is_seidel, iterations ,roots);
        
function call_gauss_elimination(a ,b, fileName)
      [roots,executionTime,error_msg] = GaussElimination(a,b);
      output_to_file( fileName, roots, error_msg, [],0);
function call_lu_decomp(a,b, fileName)
    [roots,executionTime,error_msg] = LUDecomposition(a, b); 
    output_to_file( fileName, roots, error_msg, [] ,0);
function call_gauss_jordan(a,b, fileName)
    [error_msg, roots, execution_time] = GaussJordan(a, b);
    output_to_file( fileName, roots, error_msg, [] , 0);
function [roots , iterations] = call_gauss_seidel(a ,b ,initial, no_of_it,error, fileName)
    [values_matrix, Number_of_iterations, execution_time, err_msg, precision] = GaussSeidel (a, b, initial, no_of_it, error);
    extra_results = {'Precesion' num2str(precision);'NoOfIterations' num2str(Number_of_iterations); 'ExecutionTime' num2str(execution_time)};
    output_to_file( fileName,values_matrix , err_msg, extra_results ,1);
    if isempty(err_msg)
        [row , col] = size(values_matrix);
        roots = zeros(row,col/2);
        iterations = 1 : Number_of_iterations;
        j = 1;
        for i = 1:2:col
            roots(:,j) = values_matrix(:,i);
            j = j + 1;
        end;
    else 
        roots = [];
        iterations = [];
    end;
   
function  deleteFiles(file_names)
 for i = 1 : size(file_names,1)
     delete (strcat(file_names{i,1},'.txt'));
 end;
 
 function open_result_view(fileName,is_seidel, iterations,roots)
     close (ResultViewPhaseTwo);
     run ResultViewPhaseTwo;
     h = findobj('Tag','ResultView');
     data = guidata(h);
     data.fileName = fileName;
     data.is_seidel = is_seidel;
     data.roots = roots;
     data.iterations = iterations;
     guidata(h,data);

