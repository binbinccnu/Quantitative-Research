function [s_est,g_est]=METHOD_A_CDCAT(alpha_mle,Q_cali,response_select)
% this function proceeds online calibration method using M-METHOD A for
% CDCAT
% alpha_est is a person by item matrix
% Q is the Q matrix
% response_select indicates responses from persons who answered this item
% s_est,g_est are scalars, i.e., parameter estimates for an item


etas = Eta(alpha_mle,Q_cali);

if sum(etas) == 0
    s_est = .1;
    g_est = sum(response_select .* (1 - etas)) / sum(1 - etas);
elseif sum(1-etas)==0
    g_est = .1;
    s_est = sum((1 - response_select) .* etas) / sum(etas);
else    
    g_est = sum(response_select .* (1 - etas)) / sum(1 - etas);
    s_est = sum((1 - response_select) .* etas) / sum(etas);
end