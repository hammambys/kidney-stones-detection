function mat2m(calib_name)
% Convert file_name.mat to file_name.m
% Copy variable (in upper case) names and values as follows:
% A = "value of A"; or A = ["values of A"];

path_name = which(calib_name); % get loading file path
path_name = strrep(path_name,'.mat','.m'); % create output file path

% try/catch for .mat loading
try 
    load(calib_name)
    error=0;
catch
    disp(['Error loading ',calib_name])
    error=1;
end

if error == 0

      fid = fopen(path_name,'w'); % open file and get file id
      dd=whos; % get DD list (loading calib + working variables as dd)
      for j=1:length(dd) % parse DD list
          if strcmp(lower(dd(j,1).name(1)),dd(j,1).name(1))
              % check if first letter is lower case
              % lower case = working variables (not used)
          else
              fprintf(fid,dd(j,1).name); % write one var name in file
              siz=eval(['size(',dd(j,1).name,')']); % check var size
              if siz(1,1)==1 % Xdim = 1
                  if siz(1,2)==1 % Ydim = 1
                      %0-D
                      fprintf(fid,' = '); % write start of the assignation
                      fprintf(fid,num2str(eval(dd(j,1).name))); % write value of the variable
                      fprintf(fid,';'); % write end of the assignation
                  else % Ydim > 1 (siz(1,2)>1)
                      %1-D
                      fprintf(fid,' = ['); % write start of the assignation
                      for k=1:siz(1,2)-1
                          fprintf(fid,num2str(eval([dd(j,1).name,'(k)'])));
                          fprintf(fid,',');
                      end
                      fprintf(fid,num2str(eval([dd(j,1).name,'(siz(1,2))'])));   
                      fprintf(fid,'];'); % write end of the assignation
                  end            
              else % Xdim > 1 (siz(1,1)>1)
                  fprintf(fid,' = ['); % write start of the assignation
                  if siz(1,2)>1 %2-D % specific case of 2D matrix
                      for k=1:siz(1,1)
                          for l=1:siz(1,2)
                              fprintf(fid,num2str(eval([dd(j,1).name,'(k,l)'])));
                              if l~=siz(1,2)
                                  fprintf(fid,',');
                              end
                          end
                          if k~=siz(1,1)
                              fprintf(fid,';');
                          end
                      end
                  else
                      %1-D
                      for k=1:siz(1,1)-1
                          fprintf(fid,num2str(eval([dd(j,1).name,'(k)'])));
                          fprintf(fid,';');
                      end
                      fprintf(fid,num2str(eval([dd(j,1).name,'(siz(1,1))'])));
                  end
                  fprintf(fid,'];'); % write end of the assignation
              end
              fprintf(fid,'\n'); % write end of the line for next var
              eval(strcat('clear(''',dd(j,1).name,''')')); % clear var from workspace
          end
      end
      fclose(fid); % close file with its id

else
    % Do nothing
end

end