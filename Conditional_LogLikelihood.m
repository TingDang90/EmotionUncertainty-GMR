function [ posterior_weights ]=Conditional_LogLikelihood(Matrix, MeanVector, CovMat, MixWeig)
% This function calculated posterior weights of GMM for each frame 
%
%Input

% Matrix - Feature vectors in matrix form, one feature vectors one column

% MeanVector - Mean Vectors mentioned in GMM parameters, one vector one column

% CovMat - Covariance matrices mentioned in GMM parameters,

% MixWeig - Mixture Weights in a column vector form, one mix weight one element

% Output:
%posterior_weights: weights for each frame-wise GMM
%                    matrix shape is m x n
%                                    m --- mixture number
%                                    n --- frame number


for k=1:length(MixWeig)
    
%     Cov = diag(CovMat(:,k));
        Cov = CovMat{k};
    
    p(k,:)=gaussian_prob(Matrix, MeanVector(:,k), Cov)';
    
end

weight=repmat(MixWeig,1,size(p,2));
p=weight.*p;
sumation=sum(p,1);
sumation(find(sumation==0))=1;
p=p./repmat(sumation,length(MixWeig),1);

end

