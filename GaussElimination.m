function [Xout,executionTime,error] = GaussElimination(EquationsCoefficients,EquationsResults)
% Solve linear system Ax = b
% using Gaussian elimination with pivoting
% EquationsCoefficients is an n by n matrix
% EquationsResults is an n by k matrix (k copies of n-vectors)
% X is an n by k matrix (k copies of solution vectors)
% Find size of matrix EquationsCoefficients
format('long');
[n,m]=size(EquationsCoefficients);
X = zeros(n,1);      % Initialize x 
Xout = zeros(1,n);
error = '';
tic;
if m~= n 
    error('Matrix A must be square');
end
nb = n +1;
Aug =zeros(n,n+1);
for i = 1 : n
    for j = 1 : n 
        Aug(i,j) = EquationsCoefficients(i,j);
    end
end
 for k = 1 : n 
        Aug(k,n+1) = EquationsResults(k,1);
    end
% forward Elimintation
for k = 1 : n -1
    pivot = k ;
    max = Aug(k,k);
     for i = k+1 : n 
        dummy = abs(Aug(i,k));
        if (dummy > max) 
            max = dummy ;
            pivot = i ;      
        end
     end
    if pivot ~= k
        p = pivot;
        for j = k : n +1;
        dummy = Aug(p,j);
        Aug(p,j) = Aug(k,j);
        Aug(k,j) = dummy ;
       end
    end
    for i = k+1 : n 
        multiplier = Aug(i,k) / Aug(k,k);
        Aug(i,k:nb)  = Aug(i,k:nb) - (multiplier * Aug(k,k:nb));
    end
end
%back substitution
    X(n) =Aug(n,nb)/Aug(n,n);
    for i = n-1:-1:1
        X(i)= (Aug(i,nb)-Aug(i,i+1:n)*X(i+1:n))/Aug(i,i);
    end
    Xout = rot90(X);
executionTime = toc; 



