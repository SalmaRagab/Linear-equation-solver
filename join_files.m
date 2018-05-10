function  join_files( method_names ,fileName)
fileID = fopen(fileName,'wt');
for i = 1 : size(method_names,1) 
   file_name = strcat(method_names{i,1}, '.txt');
   file_read_ID = fopen(file_name,'r');
   line = fgets(file_read_ID);
    while ischar(line)
        fprintf(fileID,line);
        line = fgets(file_read_ID);
    end
    fclose(file_read_ID);
    fprintf(fileID,'\n______________________________________________________________________________________________________________________________________________________________________ \n\n\n');
end
fclose(fileID);
end

