function etas = Eta(alpha,Q)
%alpha is a person by item matrix
%Q is the Q matrix
%etas is a person by item matrix

eta0 = alpha*Q';
sumQ = sum(Q,2)';
sumQ_ = Q*Q';
etas = eta0==sumQ(ones(size(eta0,1),1),:);
