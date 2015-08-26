function [s_est,g_est] = Maximization(s,g,item,Q,sparse)
%%% s g are column vectors
%%% item is the item number to be calibrated
%%% Q is the Q matrix
%%% sparse is the sparse matrix 
%%% s_est and g_est are column vectors

persons = find(sparse(:,item)~=9);
alpha_permute = AlphaPermute(Q);

post = post_alpha(s,g,Q,sparse);
post = post(persons,:);

eta = Eta(alpha_permute,Q);
eta = eta(:,item);
 
L = post * eta;

n0 = persons - sum(L);
r0 = sum(sparse(persons,item).*(1-L));
n1 = sum(L);
r1 = sum(response(persons,item).*L);

g_est = r0 / n0;
s_est = (n1-r1) / n1;

