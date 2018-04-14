function [ ] = HTK_train_list_written( path,features_train,train_label)
%This function generates the trianing list for HTK training

%   path --- folder path to store the training list
%   features_train   --- training features (each cell stores one utterance)
%                    --- In each cell, feature matrix is of shape n*m1
%                                      n -- frames
%                                      m1 -- feature dimensions

%   label_train    --- training labels (each cell stores one utterance)
%                    --- In each cell, label matrix is of shape n*m2
%                                      n -- frames
%                                      m2 -- label dimensions (can be muiltidimensional modelling)

filepath1=[path,'\train_list.txt']; %%Writing train file
fidin1=fopen(filepath1,'wt');

count=1;
for i=1:length(train_label)
    s=[path,'\mfc\features',num2str(count),'.mfc']; % forlder to store the mfc files for HTK training
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    joint_features_train{count}=[features_train{i},train_label{i}];%%adding three attributes to jointly train the GMR model
    
    if size(joint_features_train{count},1)~=0
        %             train_data_q{i}(1:size(features_train{i}{ii},1),:)=[];
        writehtk(s,joint_features_train{count},0.040,6);
        count=count+1;
        fprintf(fidin1,'%s\n',s);
    end
end

fclose(fidin1);

