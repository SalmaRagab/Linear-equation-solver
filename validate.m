function [is_correct, error_message, value ] = validate(text, object)
     

code = strcmp(object,'no#');
if code == 1
    [is_correct, error_message, value] = validate_no_equations(text);
    
else
    code = strcmp(object,'+ve');
    if code == 1 
        [is_correct, error_message, value] = validate_positive(text);
    end

end



end


function [is_correct, error_message, value] = validate_no_equations(text)
   no_equations = str2double(text);
   if isnan(no_equations) % error
       is_correct = 0;   
       error_message = 'Number Must Be a Valid number';
       value = NaN;
   else   
       if round(no_equations) == no_equations  % then its an integer
           if no_equations <= 0
               is_correct = 0;
               value = NaN;
               error_message = 'Number Must Be a positive number';
           else
               is_correct = 1;
               value = no_equations;
               error_message = NaN;
           end
       else
           is_correct = 0;
           error_message = 'Number Must Be Integer Number!';
           value = NaN;
       end
   end


end

function [is_correct, error_message, value] = validate_positive(text)
 no = str2double(text);
   if isnan(no) % error
       is_correct = 0;   
       error_message = 'Number Must Be a Valid number';
       value = NaN;
   elseif no < 0 %not positive
       is_correct = 0;
       value = NaN;
       error_message = 'Number Must Be a positive number';
   else
               is_correct = 1;
               value = no;
               error_message = NaN;
   end
end

