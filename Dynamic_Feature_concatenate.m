function [ FeatureAll ] = Dynamic_Feature_concatenate( Original_Feature )
%This function computes the regression delta features [1] and concantenate them
%with the orginal feature vectors.

%   Original_Features :  n * m matrix
%                        n --- frames
%                        m --- feature dimensions


% [1] Metallinou, Angeliki, Athanasios Katsamanis, and Shrikanth Narayanan.
% "Tracking continuous emotional trends of participants during affective 
% dyadic interactions using body language and speech information." 
% Image and Vision Computing 31.2 (2013): 137-152.

FeatureAll=[];

for itr=1
    for i=1:size(Original_Feature,1)
        if i+1>size(Original_Feature,1)
            Dyna_feature(i,:)=-0.5*Original_Feature(i-1,:);
        else if i-1<1
                Dyna_feature(i,:)=0.5*(Original_Feature(i+1,:));
            else
                Dyna_feature(i,:)=0.5*(Original_Feature(i+1,:)-Original_Feature(i-1,:));
            end
        end
    end
end

FeatureAll=[Original_Feature,Dyna_feature];
end