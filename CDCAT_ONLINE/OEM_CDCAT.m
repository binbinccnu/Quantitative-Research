function [s_est,g_est]=OEM_CDCAT(s,g,index_cali,cali_item,Q,sparse)
%%% s g are column vectors
%%% item is the item number to be calibrated
%%% Q is the Q matrix
%%% sparse is the sparse matrix 
%%% s_est and g_est are column vectors

persons = find(sparse(:,cali_item)~=9);
alpha_perm = AlphaPermute(Q);
% response = sparse(persons,cali_item);

post = post_alpha(s,g,Q,sparse,index_cali,cali_item);
%post = post(persons,:);

eta = Eta(alpha_perm,Q);
eta = eta(:,cali_item);
% 
% I0 = 0;
% R0 = 0;
% I1 = 0;
% R1 = 0;
% for l = 1:size(alpha_perm,1)
%     if eta(l) == 0
%         L_p = zeros(length(persons),size(alpha_perm,1));
%         for i = 1:length(persons)
%             p = CD_prob_matrix(alpha_perm(l,:),s(cali_item),g(cali_item),Q(cali_item,:));        
%             L = p^response(i)*(1-p)^(1-response(i));
%             L_p(i,l) = L*post(l);
%         end
%         sum_L_p = sum(L_p,2);
%         temp0 = L_p(:,l) ./ sum_L_p;
%         temp1 = temp0 .* response;
%         I0 = I0 + sum(temp0);
%         R0 = R0 + sum(temp1);
%     else
%         L_p = zeros(length(persons),size(alpha_perm,1));
%         for i = 1:length(persons)
%             p = CD_prob_matrix(alpha_perm(l,:),s(cali_item),g(cali_item),Q(cali_item,:));        
%             L = p^response(i)*(1-p)^(1-response(i));
%             L_p(i,l) = L*post(l);
%         end
%         sum_L_p = sum(L_p,2);
%         temp0 = L_p(:,l) ./ sum_L_p;
%         temp1 = temp0 .* response;
%         I1 = I1 + sum(temp0);
%         R1 = R1 + sum(temp1);
%     end
% end
% 
% g_est = R0 / I0;
% s_est = (I1-R1) / I1;


%  
% temp = -40000000000;
% for s0 = 0:.02:.2
%     for g0 = 0:.02:.2
%         l = 0;
%         for i = 1:length(persons)
%             L_p = 0;
%             for l = 1:size(alpha_perm,1)
%                 p = CD_prob_matrix(alpha_perm(l,:),s(cali_item),g(cali_item),Q(cali_item,:));        
%                 L = p.^response(i) * (1-p).^(1-response(i));
%                 L_p = L_p + L * post(l);
%             end
%             l = l + log(L_p);
%         end
% 
%         if l > temp
%             temp = l;
%             s_est = s0;
%             g_est = g0;
%         end
%     end
% end




L = post * eta;

n0 = length(persons) - sum(L);
r0 = sum(sparse(persons,cali_item).*(1-L));
n1 = sum(L);
r1 = sum(sparse(persons,cali_item).*L);

g_est = r0 / n0;
s_est = (n1-r1) / n1;
