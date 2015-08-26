function [entropy] = Shannon_CD(selected,response_select,s,g,Q,unselected)
%posterior_alpha is a column vector, which has the alpha distribution for
%this person after applying selected items
%selected is selected items, row vector
%response is selected responses, row vector
%s and g are column vectors
%unselected is unselected items, row vector

alpha_perm = AlphaPermute(Q);
prior = 1/2^size(Q,1);
posterior = posterior_alpha(selected,response_select,s,g,Q,prior);
 
% for item = 1:length(unselected)
%     entropy(item)=0;
%     for q = 0:1
%         posterior_alpha1 = posterior_alpha([selected unselected(item)],[response_select q],s,g,Q,prior);
%         % compute H
%         H = 0;
%         for l = 1:size(alpha_perm,1)
%             temp = posterior_alpha1(l) * log(posterior_alpha1(l));
%             H = H - temp;
%         end
%         % compute p(q|x)
%         p = 0;
%         for l = 1:size(alpha_perm,1)
%             prob = CD_prob_matrix(alpha_perm(l,:),s(unselected(item)),g(unselected(item)),Q(unselected(item),:));
%             prob_q = prob^q*(1-prob)^(1-q);
%             temp = posterior(l)*prob_q;
%             p = p + temp;
%         end
%         entropy(item) = entropy(item) + H * p;
%     end
% end

% 
% for item = 1:length(unselected)
%     entropy(item)=0;
%     for q = 0:1
%         posterior_alpha1 = posterior_alpha([selected unselected(item)],[response_select q],s,g,Q,prior)
%         % compute H
%         temp = posterior_alpha1 .* log(posterior_alpha1);
%         H = -sum(temp);        
%         % compute p(q|x)
%         prob = CD_prob_matrix(alpha_perm,s(unselected(item)),g(unselected(item)),Q(unselected(item),:));
%         prob_q = prob.^q .* (1-prob).^(1-q);
%         temp1 = posterior .* prob_q;        
%         p = sum(temp1);
%         entropy(item) = entropy(item) + H * p;
%     end
% end


prob = CD_prob_matrix(alpha_perm,s(unselected),g(unselected),Q(unselected,:));
posterior_rep = repmat(posterior,1,length(unselected));

entropy = zeros(1,length(unselected));
for q = 0:1
    for item = 1:length(unselected)
        posterior_alpha1(:,item) = posterior_alpha([selected unselected(item)],[response_select q],s,g,Q,prior);
    end
    % compute H
    temp = posterior_alpha1 .* log(posterior_alpha1);
    H = -sum(temp);        
    % compute p(q|x)
    prob_q = prob.^q .* (1-prob).^(1-q);
    temp1 = posterior_rep .* prob_q;        
    p = sum(temp1);
    entropy = entropy + H .* p;
end