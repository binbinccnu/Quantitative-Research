%% Data simulation
clear; clc; close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')

%
threshold_initial = .022; % the bigger the threshold, the bi
BIAS_METHODA = zeros(4,3);
BIAS_OEM     = zeros(4,3);
BIAS_MEM     = zeros(4,3);
RMSE_METHODA = zeros(4,3);
RMSE_OEM     = zeros(4,3);
RMSE_MEM     = zeros(4,3);
    
%
N = 5000; %number of examinees
n = 1000; %number of operational items
J = 9;    %number of pretest items
test_cali        = 3;   %length of pretest
index_cali       = 1:J; %index of pretest items 
target_sample    = 300; %target sample size of pretest items
test_operational = 47;  %length of operational test
    
%%
for replication = 1:100;
    replication
    %%
    [theta,a,b,U] = MIRT_data_simulation(N,n+J);
    a_pre  = a(1:J,:);
    b_pre  = b(1:J);
    U_oper = U(:,1+J:n+J);
    U_pre  = U(:,1:J);
    
    sparse_operational = 9*ones(N,n);
    examinee_record_operational = zeros(N,test_operational);
    theta_mle = theta;
    
    %% online calibration
    M_FQ_practical2
    M_sitter_practical2
    M_D_practical
    M_random_practical

%%
    BIAS_METHODA = BIAS_METHODA + [bias_a1_METHOD_A_FQ_practical bias_a2_METHOD_A_FQ_practical bias_b_METHOD_A_FQ_practical;...
        bias_a1_METHOD_A_sitter_practical bias_a2_METHOD_A_sitter_practical bias_b_METHOD_A_sitter_practical;...
        bias_a1_METHOD_A_D_practical bias_a2_METHOD_A_D_practical bias_b_METHOD_A_D_practical;...
        bias_a1_METHOD_A_random_practical bias_a2_METHOD_A_random_practical bias_b_METHOD_A_random_practical];
   
    RMSE_METHODA = RMSE_METHODA + [rmse_a1_METHOD_A_FQ_practical rmse_a2_METHOD_A_FQ_practical rmse_b_METHOD_A_FQ_practical;...
        rmse_a1_METHOD_A_sitter_practical rmse_a2_METHOD_A_sitter_practical rmse_b_METHOD_A_sitter_practical;...
        rmse_a1_METHOD_A_D_practical rmse_a2_METHOD_A_D_practical rmse_b_METHOD_A_D_practical;...
        rmse_a1_METHOD_A_random_practical rmse_a2_METHOD_A_random_practical rmse_b_METHOD_A_random_practical];
    
    max_examinee = [max(max(item_record_FQ_practical)) max(max(item_record_sitter_practical)) max(max(item_record_D_practical))]
    sum_examinee = [sum(sum(item_record_FQ_practical~=0)) sum(sum(item_record_sitter_practical~=0)) sum(sum(item_record_D_practical~=0))]
end

%%
BIAS_METHODA = BIAS_METHODA/replication
RMSE_METHODA = RMSE_METHODA/replication
