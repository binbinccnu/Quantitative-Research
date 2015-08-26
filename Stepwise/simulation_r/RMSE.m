function rmse=RMSE(true,estimate)
%% this function computes the root mean squared error of an estimator
%input 'true' is the true value, can be a vector
%input 'estimate' is the estimated value, also can be a vector

rmse=sqrt(sum((true-estimate)'*(true-estimate))/length(true));
