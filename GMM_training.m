function [ GMM_weight,GMM_mean,GMM_var  ] = GMM_training( path,features_train,label_train, mode )
% This function trains the joint GMM of the feature vector and label
% vectors

%   features_train   --- training features (each cell stores one utterance)
%                    --- In each cell, feature matrix is of shape n*m1
%                                      n -- frames
%                                      m1 -- feature dimensions

%   label_train    --- training labels (each cell stores one utterance)
%                    --- In each cell, label matrix is of shape n*m2
%                                      n -- frames
%                                      m2 -- label dimensions (can be muiltidimensional modelling)

%   mode            --- power of 2 indicating mixture number
%                       i.e mode=3 means 2^3=8 mixtures
%                           mode=2 means 2^2=4 mixtures

%%%%%%%%%%%%%%%%%%%%%%%%%Protofile generation%%%%%%%%%%%%%%%%%%%%%
D_num=size(features_train{1},2)+size(label_train{1},2); % joint training

Protofile_generation_fullcov( path, D_num );

%%%%%%%%%%%%%%%%%%%%%%Writing trainlist%%%%%%%%%%%%%%%%%%%%%%%%%%%
HTK_train_list_written( path,features_train,label_train);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UBM TRAINING%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath1=[path,'\train_list.txt']; 

GMM_Based_Mapping_Function( filepath1,D_num, mode );%%%GMM Model trainning
[GMM_weight,GMM_mean,GMM_var ] = GMM_Para_reading_FullCov( 'D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\GMM_mix1',D_num+1);
%     [GMM_weight1{session_num},GMM_mean1{session_num},GMM_var1{session_num} ] = GMM_Para_reading( 'D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\GMM_mix1');
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%UBM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete('D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\mfc\*.mfc');%%deleting mfc files
delete(['D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\GMM_mix1\proto',num2str(D_num),'c']);
delete(['D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\GMM_mix1\proto']);
delete(['D:\PhD_UNSW\Emotion\CreativeIT\mfcc2\HTK\proto',num2str(D_num),'c.txt']);
end

