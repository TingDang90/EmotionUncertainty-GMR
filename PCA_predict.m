function [ PCred_TST] = PCA_predict(test_data,model)
% function [predictions, PCred_TST] = PCA_predict(test_data,model)
% normalise if done to training data
% test_data  --- m * n matrix
%       m -- frames
%       n --  feature dimensions

if model.znorm
    n = size(test_data,1);
    test_data = (test_data - repmat(model.muTR,[n 1])) ./ repmat(model.sigmaTR,[n 1]);
    test_data(isnan(test_data))=0;
    test_data(isinf(test_data))=0;
end

% perform PCA using train data coefficients
PC_TST = test_data*model.PCcoef_TR;

% reduce test coefficients
PCred_TST = PC_TST(:,1:model.k);
PCred_TST(isnan(PCred_TST))=0;
PCred_TST(isinf(PCred_TST))=0;
% Predict
X2 = [ones(size(PCred_TST,1),1) PCred_TST];
%     predictions = X2*model.beta;

end
