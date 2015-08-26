function bias=BIAS(true,estimate)
%% this function computes the bias of an estimate
%input 'true' is the true value, can be a column vector
%output 'estimate' is the estimated value, also can be a column vector

bias=mean(estimate-true);