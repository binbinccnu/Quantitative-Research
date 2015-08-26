function [s_est,g_est]=MLE_PAR_CDCAT(alpha_mle,Q_cali,response_select)
% this function proceeds online calibration method using M-METHOD A for
% CDCAT
% alpha_est is a person by item matrix
% Q is the Q matrix
% response_select indicates responses from persons who answered this item
% s_est,g_est are scalars, i.e., parameter estimates for an item


% tempo=-500000000000000000000000000000000000;
% 
% epsilo = .01;
% s0 =  0 : epsilo : .2;
% g0 =  0 : epsilo : .2;
% [quadrature1,quadrature2] = meshgrid(s0,g0);
% quadrature = [quadrature1(:) quadrature2(:)];
% 
% Q_cali = Q_cali(ones(size(quadrature,1),1),:);
% p = CD_prob_matrix(alpha_mle,quadrature(:,1),quadrature(:,2),Q_cali);
% q = 1 - p;
% lnL = response_select' * log(p) + (1-response_select') * log(q);
% [max_value,index] = max(lnL);
% if(max_value > tempo) 
%     s_est = quadrature(index,1);             
%     g_est = quadrature(index,2);               
%     tempo=max_value;    
% end
% 
% 
% epsilo = .005;
% s0 =  0 : epsilo : .2;
% g0 =  0 : epsilo : .2;
% [quadrature1,quadrature2] = meshgrid(s0,g0);
% quadrature = [quadrature1(:) quadrature2(:)];
% 
% Q_cali = Q_cali(ones(size(quadrature,1),1),:);
% p = CD_prob_matrix(alpha_mle,quadrature(:,1),quadrature(:,2),Q_cali);
% q = 1 - p;
% lnL = response_select' * log(p) + (1-response_select') * log(q);
% [max_value,index] = max(lnL);
% if(max_value > tempo) 
%     s_est = quadrature(index,1);             
%     g_est = quadrature(index,2);       
% end

etas = Eta(alpha_mle,Q_cali);

if sum(etas == 0)
    s_est = .1;
elseif sum(1-etas)==0
    g_est = .1;
else    
    g_est = sum(response_select .* (1 - etas)) / sum(1 - etas);
    s_est = sum((1 - response_select) .* etas) / sum(etas);
end


% 
% n1 = sum(etas + response_select == 0);
% n12  = sum(etas == 0);
% g_est = (n12-n1)/n12;
% 
% n4 = sum(etas + response_select == 2);
% n34 = sum(etas == 1);
% s_est = (n34-n4)/n34;