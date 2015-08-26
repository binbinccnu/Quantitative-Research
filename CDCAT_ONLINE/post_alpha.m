function post = post_alpha(s,g,Q,sparse,index_cali,cali_item)
%%% s g are column vectors for all items 
%%% sparse is the sparse response matrix
%%% Q is the Q matrix
%%% post is the expected proportion of examinees who have alpha_l given
%%% data

alpha_perm = AlphaPermute(Q);
persons = find(sparse(:,cali_item)~=9); % persons who answered this pretest item
prior = 1/2^size(Q,2);
lnprior = log(prior);

for j = 1:length(persons) % each person who answered this pretest item
    person = persons(j);
    % find the operational items
    items = find(sparse(person,:)~=9);
    items(items<=length(index_cali))=[];
    response = sparse(person,items);
    p = CD_prob_matrix(alpha_perm,s(items),g(items),Q(items,:));
    L = log(p)*response' + log(1-p)*(1-response)' ;
    L_p = L + lnprior;
    L_p = exp(L_p);
    
%     L_p1 = zeros(size(alpha_perm,1),1);
%     for l = 1:size(alpha_perm,1)
%         p = CD_prob_matrix(alpha_perm(l,:),s(items),g(items),Q(items,:));
%         L = p.^response .* (1-p).^(1-response);
%         L_p1(l) = prod(L) * prior;
%     end
    w_L_p(j,:) = L_p / sum(L_p);
end

post = w_L_p;





% ln_prior = -size(Q,2)*log(2); % uniform distribution
% alpha_perm = AlphaPermute(Q);
% p = CD_prob_matrix(alpha_perm,s(setdiff(1:length(s),index_cali)),g(setdiff(1:length(s),index_cali)),Q(setdiff(1:length(s),index_cali),:));
% 
% response = sparse(:,setdiff(1:size(sparse,2),index_cali));
% response(response==9) = 0;
% response_reverse = 1 - sparse(:,setdiff(1:size(sparse,2),index_cali));
% response_reverse(response_reverse==-8) = 0;
% 
% L_p = response*p' + response_reverse*(1-p') + ln_prior;
% L_p = exp(L_p);
% rowsum_Lp = sum(L_p,2);
% 
% post = L_p ./ rowsum_Lp(:,ones(1,size(alpha_perm,1)));
