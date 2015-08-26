function posterior = posterior_alpha(selected,response_select,s,g,Q,prior)
%%% computes posterior alpha for a person given selected items
%%% s g are column vectors for all items
%%% Q is the Q matrix for all items

alpha_perm = AlphaPermute(Q);

% for l = 1:size(alpha_perm,1)
%     L(l) = 1;
%     for item = 1:length(selected)
%         p = CD_prob_matrix(alpha_perm(l,:),s(selected(item)),g(selected(item)),Q(selected(item),:));
%         ln = p^(response_select(item)) * (1-p)^(1-response_select(item));
%         L(l) = L(l) * ln ;
%     end
% end

p  = CD_prob_matrix(alpha_perm,s(selected),g(selected),Q(selected,:));
response_select = repmat(response_select,size(alpha_perm,1),1);
ln = p.^(response_select) .* (1-p).^(1-response_select);
L  = prod(ln,2);

L_pi = L .* prior;
sum_L_pi = sum(L_pi);
posterior = L_pi ./ sum_L_pi;