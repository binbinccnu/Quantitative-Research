function U = CD_response(s,g,alpha,Q)
% s and g are column vectors
% alpha is a person by item matrix
% Q is the Q matrix

U = zeros(size(alpha,1),size(Q,1));
P = CD_prob_matrix(alpha,s,g,Q);
R = unifrnd(0,1,size(alpha,1),size(Q,1));
U(P>=R) = 1;
     