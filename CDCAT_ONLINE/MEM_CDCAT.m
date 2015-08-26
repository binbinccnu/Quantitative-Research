function [s_temp,g_temp]=MEM_CDCAT(s,g,index_cali,Q,sparse)
%%% this function proceeds online calibration method using M-MEM for CDCAT
%%% person_select indicates person id who answers this item to be estimated
%%% s and g are vectors, i.e., parameter estimates for an item, but s(index_cali) should be unkown

s_est = s;
g_est = g;
%person = 1:size(sparse,1);

diff=1;
iteration=0;
%%
while diff > 0.01 && iteration <= 30
    % estimate pretest item parameters
    iteration = iteration + 1;
    
    s_temp = zeros(length(index_cali),1);
    g_temp = s_temp;
    for cali_item = index_cali
        
        % get the persons who answered this pretest item
        % person_select = person(sum(examinee_record(:,(test_operational+1) : (test_operational+test_cali)) == index_cali(cali_item),2) > 0);
    
        % M-OEM
        if iteration == 1;
            index_c = index_cali;
        else
            index_c = setdiff(index_cali,cali_item);
        end
        [s_temp(cali_item),g_temp(cali_item)] = OEM_CDCAT(s,g,index_c,cali_item,Q,sparse);
    end
    
    % check difference between a_cat and a_prior
    diff = sum((s_temp - g_est(index_cali))' * (s_temp - g_est(index_cali)) + ...
               (s_temp - g_est(index_cali))' * (s_temp - g_est(index_cali)));
           
    s_est(index_cali) = s_temp;
    g_est(index_cali) = g_temp;
end 



