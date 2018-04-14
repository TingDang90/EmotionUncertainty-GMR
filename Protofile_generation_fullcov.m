function [ ] = Protofile_generation_fullcov( path,N )
%This function generates the protofile that is used for HTK training of a
%GMM model. The GMM is of full covariance matrix.

% path ---- folder path to store the generated protofile
% N --- dimension of GMM

Filename=[path,'\proto.txt'];
fileID = fopen(Filename,'wt');

string=['~o <Vecsize> ',num2str(N),' <MFCC>\n'];
fprintf(fileID,string);

fprintf(fileID,['~h "proto"\n']);
fprintf(fileID,'<BeginHMM>\n');
fprintf(fileID,' <Numstates> 3\n');
fprintf(fileID,' <State> 2\n');
fprintf(fileID,['    <Mean> ',num2str(N),'\n']);

mean=zeros(1,N);
fprintf(fileID,blanks(5));
fprintf(fileID,'%4.1f',mean);
fprintf(fileID,'\n');


% fprintf(fileID,['    <Variance> ',num2str(N),'\n']);
% variance=ones(1,N);
% fprintf(fileID,blanks(5));
% fprintf(fileID,'%4.1f',variance);
% fprintf(fileID,'\n');

fprintf(fileID,['    <InvCovar> ',num2str(N),'\n']);
for i=N:-1:1
    if mod(i,2)==0
        var=[1,zeros(1,i-1)];
    else if mod(i,5)==0
            var=[1,0.2,zeros(1,i-2)]; 
        else if i==1
                var=[1,zeros(1,i-2)]; 
            else
                var=[1,0.5,zeros(1,i-2)]; 
            end
        end
    end
    blank_num=5+4*(N-i);
    fprintf(fileID,blanks(blank_num));
    fprintf(fileID,'%4.1f',var);
    fprintf(fileID,'\n');
end

fprintf(fileID,'<TransP> 3\n');
fprintf(fileID,'   0.0 1.0 0.0\n');
fprintf(fileID,'   0.0 0.6 0.4\n');
fprintf(fileID,'   0.0 0.0 0.0\n');
fprintf(fileID,'<EndHMM>');

fclose(fileID);


end

