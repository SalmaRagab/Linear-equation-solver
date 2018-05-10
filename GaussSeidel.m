function [values_matrix, Number_of_iterations, execution_time, err_msg, precision] = GaussSeidel (A, b, x, NoOfIterations, ErrorBound)
%x >> initial guess, default:: zero matrix ((Xold))
n = size(A,1);
values_matrix = [n, NoOfIterations];
err_msg = '';
diagonal = diag(A); %Main Diagonal matrix
 
i = 1;
j = 1;
 
flag = true;
 
%creating the diagonal matrix
while i <= n
    j = 1;
    while j <= n 
        if (i == j)
            D(i,j) = diagonal(i);
        end
        j = j + 1;
    end
    i = i + 1;
end
 
 
for i = 1:n
    j = 1:n;
    j(i) = [];
    B = abs(A(i,j));
    Check(i) = abs(A(i,i)) - sum(B); % Is the diagonal value greater than the remaining row values combined?
    if Check(i) < 0
        err_msg = 'The matrix is not strictly diagonally dominant';
        flag = false;
    end
end
 
iteration = 0;
 
AminusD = A - D;
 
absolute_error = 10000; 
 
tic;
while ((iteration < NoOfIterations) && (absolute_error > ErrorBound))
 
    iteration = iteration + 1;
    k = 1;
    for l = 1:n
        Xtemp = x;  % copy the unknows to a new variable
        valueBefore = Xtemp(l); %Xi-1; in order to calculate the absolute error
        Xtemp(l) = [];  % eliminate the unknown under question from the set of values
        AminusDnew = AminusD(l:l,:); %matrix of the needed row
        L = AminusDnew(AminusDnew~=0);
        try 
                x(l) = (b(l) - L * Xtemp) / A(l,l);
        catch %A is a one dimension matrix
            x(l) = b(l) / A(l);
        end
        
        absolute_error = abs(valueBefore - x(l));
        values_matrix(iteration, k) = x(l);
        values_matrix(iteration, k+1) = absolute_error;
        k = k + 2;
    end
 
end
toc;
% Display Results
% GaussSeidelTable = [1:iteration;Xsolution]
if flag == false
    values_matrix = zeros(1);
end
 
% matrix = x;
 
execution_time = toc;
Number_of_iterations = iteration;
 
 
precision = absolute_error;