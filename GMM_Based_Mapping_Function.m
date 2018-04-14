function [ ] = 	GMM_Based_Mapping_Function( path,train_list,mode )
%
%   This function builds GMM-based mapping fuction
%   It is a prediction mehod

% train_data is features of N x M dim. N--Frames, M--Dimensions
% train_gt is training data labels N x 3 dim 
%                                  N--Frames
%                                  Column1--Arousal C2--Valence
%                                  C3--Dominance 
% mix_num is GMM model mix number
% train_list is the training files name list

%   path            --- path for HTK
%   train_list      --- the path of trian list 
%                       (train list is for HTK training (strings of training utterance names))

%   mode            --- power of 2 indicating mixture number
%                       i.e mode=3 means 2^3=8 mixtures
%                           mode=2 means 2^2=4 mixtures

cd(path);
mkdir('GMM_mix1'); % store the generated protofiles

dos(['HCompV -m -S ',train_list,' -M GMM_mix1 proto.txt']);

%%
% if nargin<3
    for noOfMixBase=1
        noOfMix=2^noOfMixBase;
        strSplitGMM=['MU' ' ' num2str(noOfMix) ' ' '{*.state[2].mix}'];
        fid=fopen('GMM_mix1/mix.txt','wt');
        fprintf(fid,'%s\n',strSplitGMM);
        fclose(fid);
        
        dos('HHEd -H GMM_mix1/proto GMM_mix1/mix.txt GMM_mix1/hmmLst.txt');
        % dos(['HRest -T 1 -i 20 -m 1 GMM_mix1/proto -S ',train_list]);
        for it=1:5
            dos(['HERest -T 1 -S ',train_list,' -I GMM_mix1/labsGenuine.mlf -H GMM_mix1/proto -M GMM_mix1 GMM_mix1/monophonesGenuine.txt']);
        end
        %     copyfile('GMM_mix1/proto',['GMM_mix1/split',num2str(i_spkr)]);
    end
% 

    for noOfMixBase=2:mode
        noOfMix=2^noOfMixBase;
        strSplitGMM=['MU' ' ' num2str(noOfMix) ' ' '{*.state[2].mix}'];
        fid=fopen('GMM_mix1/mix.txt','wt');
        fprintf(fid,'%s\n',strSplitGMM);
        fclose(fid);        

        dos('HHEd -H GMM_mix1/proto GMM_mix1/mix.txt GMM_mix1/hmmLst.txt');
        % dos(['HRest -T 1 -i 20 -m 1 GMM_mix1/proto -S ',train_list]);
        if noOfMixBase~=mode
            for it=1:2
                dos(['HERest -T 1 -S ',train_list,' -I GMM_mix1/labsGenuine.mlf -H GMM_mix1/proto -M GMM_mix1 GMM_mix1/monophonesGenuine.txt']);
            end
        else
            for it=1:10
                dos(['HERest -T 1 -S ',train_list,' -I GMM_mix1/labsGenuine.mlf -H GMM_mix1/proto -M GMM_mix1 GMM_mix1/monophonesGenuine.txt']);
            end
        end
    end

end