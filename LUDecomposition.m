function [roots,executionTime,error_msg] = LUDecomposition(cofficients, b) 
    format long;
    ErrorBound = 0.001;
    error_msg ='';
    noOfEquations = size(cofficients, 1);
    rowsOrder = zeros(noOfEquations,1);
    scalingFactors = zeros(noOfEquations,1); 
    roots = zeros(1,noOfEquations);
    tic;
    [errorFlag,cofficients,rowsOrder] = Decompose(cofficients, noOfEquations, ErrorBound, rowsOrder, scalingFactors);
    if (errorFlag ~= -1)
      [roots] = Substitute(cofficients, rowsOrder,  noOfEquations, b);
    else
        error_msg = 'Singularity occured';
    end;
    executionTime = toc;

function [errorFlag,cofficients,rowsOrder] =  Decompose(cofficients, noOfEquations, ErrorBound, rowsOrder, scalingFactors)
    errorFlag = 0;
    for i = 1 : noOfEquations
        rowsOrder(i) = i;
        scalingFactors(i) = abs(cofficients(i,1));
        for j = 2 : noOfEquations
          if (abs(cofficients(i,j)) > scalingFactors(i))
            scalingFactors(i) = abs(cofficients(i,j));
          end;
        end;
    end;
        for k = 1 : noOfEquations - 1
        [cofficients, rowsOrder, scalingFactors] = Pivot(cofficients, rowsOrder, scalingFactors, noOfEquations, k);
            if (abs(cofficients(rowsOrder(k),k) / scalingFactors(rowsOrder(k))) < ErrorBound )
                errorFlag = -1;
                return
            end
            for i = k+1 : noOfEquations 
                factor = cofficients(rowsOrder(i),k) / cofficients(rowsOrder(k),k);
                cofficients(rowsOrder(i),k) = factor;
                for j = k+1 : noOfEquations
                   cofficients(rowsOrder(i),j) = cofficients(rowsOrder(i),j) - (factor * cofficients(rowsOrder(k),j));
                end;
            end;
        end;

if (abs(cofficients(rowsOrder(noOfEquations), noOfEquations)) / scalingFactors(rowsOrder(noOfEquations)) < ErrorBound)
    errorFlag = -1;
end;


function   [cofficients, rowsOrder, scalingFactors] = Pivot(cofficients, rowsOrder, scalingFactors, noOfEquations, k)

    pivotIndex = k ;
    big = abs(cofficients(rowsOrder(k),k) / scalingFactors(rowsOrder(k)));
    for ii = k+1 : noOfEquations
        dummy = abs(cofficients(rowsOrder(ii),k) / scalingFactors(rowsOrder(ii)));
        if (dummy > big) 
            big = dummy;
            pivotIndex  = ii;
        end;
    end;
    dummy = rowsOrder(pivotIndex); 
    rowsOrder(pivotIndex) = rowsOrder(k);
    rowsOrder(k) = dummy;   
    
    
function [roots]=  Substitute(cofficients, rowsOrder, noOfEquations, b)
 roots = zeros(1,noOfEquations);
 for i = 2 : noOfEquations
    sum = b(rowsOrder(i));
    for j = 1 : i-1
      sum = sum  - (cofficients(rowsOrder(i),j) * b(rowsOrder(j)));
    end;
    b(rowsOrder(i)) = sum;
 end;

roots(1,noOfEquations) = b(rowsOrder(noOfEquations)) / cofficients(rowsOrder(noOfEquations),noOfEquations);
for i = noOfEquations-1 :-1: 1 
  sum = 0;
  for j = i+1 : noOfEquations
      sum = sum + cofficients(rowsOrder(i),j) * roots(j);
  end;
roots(1,i) = (b(rowsOrder(i)) - sum) / cofficients(rowsOrder(i),i);
end;   
    
    
    
    
    
    