%% Data simulation
clear; clc; close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')

%
BIAS_METHODA = zeros(4,3);
BIAS_OEM     = zeros(4,3);
BIAS_MEM     = zeros(4,3);
RMSE_METHODA = zeros(4,3);
RMSE_OEM     = zeros(4,3);
RMSE_MEM     = zeros(4,3);
    
%
N = 5000; %number of examinees
n = 600;  %number of operational items
J = 9;    %number of pretest items
test_cali        = 3;   %length of pretest
index_cali       = 1:J; %index of pretest items 
target_sample    = 300; %target sample size of pretest items
test_operational = 47;  %length of operational test
    
%%
for replication = 1:10;
    replication
    %%
    [theta,a,b,U] = MIRT_data_simulation(N,n+J);
    a_pre  = a(1:J,:);
    a_oper = a(J+1:size(a,1),:);
    b_pre  = b(1:J);
    b_oper = b(J+1:length(b),:);
    U_oper = U(:,1+J:n+J);
    U_pre  = U(:,1:J);
    
    sparse_operational = 9*ones(N,n);
    examinee_record_operational = zeros(N,test_operational);
    theta_mle = theta;
    
    % conduct a normal CAT process
    for examinee = 1:N
        
        %randomly select the first 5 items   
        item_select = randsample(1:n,5);   
        response    = U_oper(examinee,item_select); % Get the response for the first 5 items    
        sparse_operational(examinee,item_select)  = response;    
        examinee_record_operational(examinee,1:5) = item_select;
        theta_mle(examinee,:) = MLE_MIRT2D(a_oper(:,1),a_oper(:,2),b_oper,item_select,response);    
        for test = 6:test_operational        
            unselected  = setdiff(1:n,item_select);        
            information = Doptimality2D(theta(examinee,1),theta(examinee,2),a_oper(1:n,1),a_oper(1:n,2),b_oper(1:n),item_select);            
            max_index   = find(information(unselected) == max(information(unselected)));
            next_item   = unselected(max_index);          
            item_select = [item_select next_item];           
            response    = U_oper(examinee,item_select);        
            sparse_operational(examinee,item_select)   = response;       
            examinee_record_operational(examinee,test) = next_item;
        end     
        theta_mle(examinee,:) = MLE_MIRT2D(a_oper(:,1),a_oper(:,2),b_oper,item_select,response);           
        
    end   
    examinee_record_operational = examinee_record_operational + J;
    
    %% online calibration
    M_FQ_practical3
    M_sitter_practical3
    M_D_practical1
    M_random_practical1

%%
    BIAS_METHODA = BIAS_METHODA + [bias_a1_METHOD_A_FQ_practical bias_a2_METHOD_A_FQ_practical bias_b_METHOD_A_FQ_practical;...
        bias_a1_METHOD_A_sitter_practical bias_a2_METHOD_A_sitter_practical bias_b_METHOD_A_sitter_practical;...
        bias_a1_METHOD_A_D_practical bias_a2_METHOD_A_D_practical bias_b_METHOD_A_D_practical;...
        bias_a1_METHOD_A_random_practical bias_a2_METHOD_A_random_practical bias_b_METHOD_A_random_practical];
   
    BIAS_OEM = BIAS_OEM + [bias_a1_OEM_FQ_practical bias_a2_OEM_FQ_practical bias_b_OEM_FQ_practical;...
        bias_a1_OEM_sitter_practical bias_a2_OEM_sitter_practical bias_b_OEM_sitter_practical;...
        bias_a1_OEM_D_practical bias_a2_OEM_D_practical bias_b_OEM_D_practical;...
        bias_a1_OEM_random_practical bias_a2_OEM_random_practical bias_b_OEM_random_practical];
%         
    BIAS_MEM = BIAS_MEM + [bias_a1_MEM_FQ_practical bias_a2_MEM_FQ_practical bias_b_MEM_FQ_practical;...
        bias_a1_MEM_sitter_practical bias_a2_MEM_sitter_practical bias_b_MEM_sitter_practical;...
        bias_a1_MEM_D_practical bias_a2_MEM_D_practical bias_b_MEM_D_practical;...
        bias_a1_MEM_random_practical bias_a2_MEM_random_practical bias_b_MEM_random_practical];
% %    
    RMSE_METHODA = RMSE_METHODA + [rmse_a1_METHOD_A_FQ_practical rmse_a2_METHOD_A_FQ_practical rmse_b_METHOD_A_FQ_practical;...
        rmse_a1_METHOD_A_sitter_practical rmse_a2_METHOD_A_sitter_practical rmse_b_METHOD_A_sitter_practical;...
        rmse_a1_METHOD_A_D_practical rmse_a2_METHOD_A_D_practical rmse_b_METHOD_A_D_practical;...
        rmse_a1_METHOD_A_random_practical rmse_a2_METHOD_A_random_practical rmse_b_METHOD_A_random_practical];
   
    RMSE_OEM = RMSE_OEM + [rmse_a1_OEM_FQ_practical rmse_a2_OEM_FQ_practical rmse_b_OEM_FQ_practical;...
        rmse_a1_OEM_sitter_practical rmse_a2_OEM_sitter_practical rmse_b_OEM_sitter_practical;...
        rmse_a1_OEM_D_practical rmse_a2_OEM_D_practical rmse_b_OEM_D_practical;...
        rmse_a1_OEM_random_practical rmse_a2_OEM_random_practical rmse_b_OEM_random_practical];
%         
    RMSE_MEM = RMSE_MEM + [rmse_a1_MEM_FQ_practical rmse_a2_MEM_FQ_practical rmse_b_MEM_FQ_practical;...
        rmse_a1_MEM_sitter_practical rmse_a2_MEM_sitter_practical rmse_b_MEM_sitter_practical;...
        rmse_a1_MEM_D_practical rmse_a2_MEM_D_practical rmse_b_MEM_D_practical;...
        rmse_a1_MEM_random_practical rmse_a2_MEM_random_practical rmse_b_MEM_random_practical];
%     
    max_examinee = [max(max(item_record_FQ_practical)) max(max(item_record_sitter_practical)) max(max(item_record_D_practical))]
    sum_examinee = [sum(sum(item_record_FQ_practical~=0)) sum(sum(item_record_sitter_practical~=0)) sum(sum(item_record_D_practical~=0))]
end

%%
BIAS_METHODA = BIAS_METHODA/replication
RMSE_METHODA = RMSE_METHODA/replication
% 
BIAS_OEM = BIAS_OEM/replication
RMSE_OEM = RMSE_OEM/replication

BIAS_MEM = BIAS_MEM/replication
RMSE_MEM = RMSE_MEM/replication