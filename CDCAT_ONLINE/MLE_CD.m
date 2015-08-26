function [alpha_mle]=MLE_CD(s,g,Q,item_select,response)
% s and g are column vectors
% response is a row vector this person has answered
% Q is the Q matrix
% item_selecton is row vector indicating selected items for this person

%%%%%%%%%%% Instead of using N-R algorithm as introduced above, we use a
%%%%%%%%%%% grid search instead%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempo = -5000000000000000000000000000000;

% get all possible alphas
alpha_perm = AlphaPermute(Q);

p = CD_prob_matrix(alpha_perm,s(item_select),g(item_select),Q(item_select,:));
lnL = log(p) * response' + log(1-p) * (1-response');

[max_value,index] = max(lnL);
if(max_value>tempo) 
    alpha_mle = alpha_perm(index,:);             
end
