function [P] = CD_prob_matrix(alpha,s,g,Q)
% alpha is a "person" by item matrix 
% s and g are column vectors
% Q is the Q matrix
% output P is a person by item matrix

etas = Eta(alpha,Q);
ss = s';
ss = ss(ones(size(etas,1),1),:);
gg = g';
gg = gg(ones(size(etas,1),1),:);

P = (1-ss).*etas+gg.*(1-etas);

P(P<.0001) = .0001;
P(P>.9999) = .9999;
