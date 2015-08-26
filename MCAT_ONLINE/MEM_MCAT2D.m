function [a1_temp,a2_temp,b_temp]=MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali)
%%% this function proceeds online calibration method using M-MEM for MCAT
%%% person_select indicates person id who answers this item to be estimated
%%% a and b are vectors, i.e., parameter estimates for an item, but a(:,(test_operational+1):(test_operational+test_cali)) should be unkown

%%
a1_est = a(:,1);
a2_est = a(:,2);
b_est  = b;
person = 1:size(sparse,1);

diff=1;
iteration=0;
%%
while diff > 0.05 && iteration <= 20
    % estimate pretest item parameters
    iteration = iteration + 1;
    
    a1_temp = zeros(length(index_cali),1);
    a2_temp = a1_temp;
    b_temp  = a2_temp;
    for cali_item_index = 1:length(index_cali)
        cali_item = index_cali(cali_item_index);
        
        % get the persons who answered this pretest item
        person_select = person(sum(examinee_record(:,(test_operational+1) : (test_operational+test_cali)) == index_cali(cali_item),2) > 0);
    
        % M-OEM
        if iteration == 1;
            test = test_operational;
        else
            test = test_operational + test_cali;
        end
        [a1_temp(cali_item),a2_temp(cali_item),b_temp(cali_item)] = OEM_MCAT(sparse,index_cali,examinee_record,test_operational,cali_item,a,b,person_select);
    end
    
    % check difference between a_cat and a_prior
    diff = sum((a1_temp - a1_est(index_cali))' * (a1_temp - a1_est(index_cali)) + ...
               (a2_temp - a2_est(index_cali))' * (a2_temp - a2_est(index_cali)) + ...
               (b_temp  - b_est(index_cali))'  * (b_temp  - b_est(index_cali)));
           
    a1_est(index_cali) = a1_temp;
    a2_est(index_cali) = a2_temp;
    b_est(index_cali)  = b_temp ;
end 



