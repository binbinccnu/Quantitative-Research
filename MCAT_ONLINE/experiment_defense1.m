%% Data simulation
clear; clc; close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')

% read in data from desktop
load '~/desktop/defense/prelim'

%%
clearvars -except a b a_pre b_pre index_cali U n U_pre N J theta test_cali target_sample sparse_operational...
theta_mle  theta test_operational;
%%
BIAS_METHODA = zeros(4,3);
BIAS_OEM     = zeros(4,3);
BIAS_MEM     = zeros(4,3);
RMSE_METHODA = zeros(4,3);
RMSE_OEM     = zeros(4,3);
RMSE_MEM     = zeros(4,3);
    
sparse_operational = 9*ones(N,n);
examinee_record_operational = zeros(N,test_operational);

%% online calibration

M_FQ_practical
M_sitter_practical
M_D_practical
M_random_practical
%     

%%
BIAS_METHODA = BIAS_METHODA + [bias_a1_METHOD_A_FQ_practical bias_a2_METHOD_A_FQ_practical bias_b_METHOD_A_FQ_practical;...
        bias_a1_METHOD_A_sitter_practical bias_a2_METHOD_A_sitter_practical bias_b_METHOD_A_sitter_practical;...
        bias_a1_METHOD_A_D_practical bias_a2_METHOD_A_D_practical bias_b_METHOD_A_D_practical;...
        bias_a1_METHOD_A_random_practical bias_a2_METHOD_A_random_practical bias_b_METHOD_A_random_practical];

RMSE_METHODA = RMSE_METHODA + [rmse_a1_METHOD_A_FQ_practical rmse_a2_METHOD_A_FQ_practical rmse_b_METHOD_A_FQ_practical;...
        rmse_a1_METHOD_A_sitter_practical rmse_a2_METHOD_A_sitter_practical rmse_b_METHOD_A_sitter_practical;...
        rmse_a1_METHOD_A_D_practical rmse_a2_METHOD_A_D_practical rmse_b_METHOD_A_D_practical;...
        rmse_a1_METHOD_A_random_practical rmse_a2_METHOD_A_random_practical rmse_b_METHOD_A_random_practical];
  
 
%%
replication  = 1;
BIAS_METHODA = BIAS_METHODA/replication
RMSE_METHODA = RMSE_METHODA/replication

