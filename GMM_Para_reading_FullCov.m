function [GMM_weight,GMM_mean,GMM_cov ] = GMM_Para_reading_FullCov( filepath,dimension )
%This function simply reads the GMM parameters in protofile (full cov GMM) and stores them
%in matlab array seperatly

% filepath   --- path that stores the trained protofile
% dimension   --- dimension means the dimension of GMM

% GMM_weight --- GMM weights of shape 1 x n
%                 n  --- mixture number

% GMM_mean   --- GMM mean vectors n x m 
%                 n  --- mixture number
%                 m  --- feature dimension

% GMM_cov    --- GMM covariance matrix (n cell)
%                each cell represents the covariance of each mixture
%                matrix in each cell is of shape m x m


fidin=fopen([filepath,'\proto']);

t=1;t1=1;t2=1;

flag_mean=0;flag_var=0;

Varcount=1;Mix_num=1;

while ~feof(fidin)
    tline=strsplit(fgetl(fidin));
    
    if length(cell2mat(tline(1)))==9 & cell2mat(tline(1))=='<MIXTURE>'
        GMM_weight(t)=str2num(tline{3});
        t=t+1;
    end
    
    if length(cell2mat(tline(1)))==6 & cell2mat(tline(1))=='<MEAN>'
        flag_mean=1;
    end
    
    if length(cell2mat(tline(1)))==10 & cell2mat(tline(1))=='<INVCOVAR>'
        flag_var=1;
    end
    
    if length(cell2mat(tline(1)))==0 & flag_mean==1
        for i=1:length(tline)-1
            GMM_mean(t1,i+Varcount-1)=str2num(tline{i+1});
        end
        flag_mean=0;
        t1=t1+1;
    end
    
    if length(cell2mat(tline(1)))==0 & flag_var==1
        for i=1:length(tline)-1
            GMM_var(t2,i+Varcount-1)=str2num(tline{i+1});
        end
        Varcount=Varcount+1;
        t2=t2+1;
        if Varcount==dimension
            flag_var=0;
            t2=1;
            Varcount=1;
            GMM_cov{Mix_num}=inv((GMM_var+GMM_var')-diag(diag(GMM_var)));
            Mix_num=Mix_num+1;
            clear GMM_var
        end
    end
end

if exist('GMM_weight')==0
    GMM_weight=1;
end

fclose(fidin);


