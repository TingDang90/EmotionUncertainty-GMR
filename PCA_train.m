function [model, cumVAR, PCred_TR] = PCA_train(train_data,k,znorm)
    %% Inputs
    %  train_data m by n matrix
    %       m = number of samples
    %       n = feature dimensionality

    % k = number of PCA coefficents to retain set between 1 to n
    
    % znorm ->set to 1 to perform znormalisation or 0 not to
    
    %% Outputs
    % model - everything needed for PCA_predict
    % cumVAR - cumulative variance captured in PCA - could be useful for deteriming K
    
    %% Function
    
    %Normalise of required
    if lt(nargin,4)
        znorm = 0;
    end

    if znorm
        [train_data, muTR, sigmaTR] = zscore(train_data);
        train_data(isnan(train_data))=0;
        train_data(isinf(train_data))=0;
    end

    % Perform PCA
    [PCcoef_TR, PC_TR, ~] = princomp(train_data);
    
    % cumVAR could be useful for calculating k
    cumVAR = cumsum(var(PC_TR)) / sum(var(PC_TR));
    
    % if k is not defined
    if lt(nargin,3)
        k = find(cumVAR>0.99,1,'first');
    elseif isequal(k,0)
        k = find(cumVAR>0.99,1,'first');
    elseif gt(k, size(train_data,2))
        k = size(train_data,2);
    end

    % Output
    model.PCcoef_TR = PCcoef_TR;
    model.k = k;
%     model.beta = beta;
    model.znorm = znorm;
    if znorm
        model.muTR = muTR;
        model.sigmaTR = sigmaTR;
    end
    
end
