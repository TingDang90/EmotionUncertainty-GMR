function [ Condi_GMM_mean_frame,Condi_GMM_cov_frame,posterior_weight] = Conditional_prob_GMM( test_data,GMM_weight,GMM_mean,GMM_var,Dim )
%This function estimates the conditional probablity distribution of test
%labels given the test features and GMM model

% Input:

% test_data   --- test features (each cell stores one utterance)
%                    --- In each cell, feature matrix is of shape n*m1
%                                      n -- frames
%                                      m1 -- feature dimensions

% GMM_weight --- GMM weights of shape 1 x n
%                 n  --- mixture number

% GMM_mean   --- GMM mean vectors n x m
%                 n  --- mixture number
%                 m  --- feature dimension


% GMM_cov    --- GMM covariance matrix (n cell)
%                each cell represents the covariance of each mixture
%                matrix in each cell is of shape m x m

% Dim  --- GMM dimensions


% Output:

% Condi_GMM_mean_frame --- frame-wise GMM mean vectors 1 x u cell
%                           u  -- utterence number
%                          each cell contains a matrix of shape m x n
%                           m -- mixture number
%                           n -- frame number

% Condi_GMM_cov_frame ---frame-wise GMM cov vectors 1 x u cell
%                           u  -- utterence number
%                          each cell contains another cell of shape 1 x f
%                           f  -- frame number
%                         each cell then contains a matrix of shape m1 x m1
%                           m1 -- feature dimensions

% posterior_weight  ---  weights for each frame-wise GMM
%                    matrix shape is m x n
%                                    m --- mixture number
%                                    n --- frame number

% References:
%[1] Toda, Tomoki, Alan W. Black, and Keiichi Tokuda.
% "Voice conversion based on maximum-likelihood estimation 
% of spectral parameter trajectory." IEEE Transactions on Audio, 
% Speech, and Language Processing 15.8 (2007): 2222-2235.

% [2]Ting Dang, Vidhyasaharan Sethu, Eliathamby Ambikairajah.
%"Dynamic multi-rater Gaussian Mixture Regression incorporating 
% temporal dependencies of emotion uncertainty using kalman filters"
% ICASSP 2018

%%
mu_x=GMM_mean(:,1:Dim);
mu_y=GMM_mean(:,1+Dim:end);
N=size(GMM_mean,2)-Dim;

for i=1:length(GMM_var)
    covar_xx{i}=GMM_var{i}(1:Dim,1:Dim);
    covar_yx{i}=GMM_var{i}(Dim+1:end,1:Dim);
    covar_xy{i}=GMM_var{i}(1:Dim,Dim+1:end);
    covar_yy{i}=GMM_var{i}(1+Dim:end,1+Dim:end);
end

posterior_weight=Conditional_LogLikelihood(test_data', mu_x', covar_xx', GMM_weight');

for i=1:length(GMM_weight)
    
    Condi_GMM_mean_frame{i}=repmat(mu_y(i,:)',1,size(test_data,1))+covar_yx{i}*inv(covar_xx{i})*(test_data-repmat(mu_x(i,:),size(test_data,1),1))';
    Condi_GMM_cov_frame{i}=covar_yy{i}-covar_yx{i}*inv(covar_xx{i})*covar_xy{i};
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Only considering the expectation of the
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%label instead of the delta label
    
    %% original labels where intergrating over the delta labels%%%%%%%%%%%%%%%
    Condi_GMM_mean_frame{i}=Condi_GMM_mean_frame{i}(1,:);
    Condi_GMM_cov_frame{i}=Condi_GMM_cov_frame{i}(1,1);
end
