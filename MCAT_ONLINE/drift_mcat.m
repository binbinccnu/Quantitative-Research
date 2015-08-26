%% Data simulation
clear; clc; close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')
%
N = 5000; %number of examinees
n = 600;  %number of operational items
J = 9;    %number of pretest items
test_cali        = 3;   %length of pretest
index_cali       = 1:J; %index of pretest items 
target_sample    = 300; %target sample size of pretest items
test_operational = 47;  %length of operational test

%
BIAS_METHODA = zeros(4,3);
BIAS_OEM     = zeros(4,3);
BIAS_MEM     = zeros(4,3);
RMSE_METHODA = zeros(4,3);
RMSE_OEM     = zeros(4,3);
RMSE_MEM     = zeros(4,3);
POWER        = zeros(4,1);
NULL         = zeros(4,1);
    
sparse_operational = 9*ones(N,n);
examinee_record_operational = zeros(N,test_operational);

%%
for replication = 1:100;
    replication
    %%
    [theta,a,b,U] = MIRT_data_simulation(N,n+J);
    a_pre  = a(1:J,:);
    a_old  = [a_pre(1:round(J/2),:) + .5; a_pre(round(J/2)+1 : J,:)];
    a_oper = a(J+1:size(a,1),:);
    b_pre  = b(1:J);
    b_old  = [b_pre(1:round(J/2)); b_pre(round(J/2)+1 : J) + .5];
    b_oper = b(J+1:length(b),:);
    U_oper = U(:,1+J:n+J);
    U_pre  = U(:,1:J);
    
    sparse_operational = 9*ones(N,n);
    examinee_record_operational = zeros(N,test_operational);
    theta_mle = theta;
    
    examinee_record_operational = examinee_record_operational + J;
    
%% online calibration

M_FQ_practical2
M_sitter_practical2
M_D_practical
M_random_practical

%% likelihood ratio test
LR 
POWER = POWER + [pow_FQ; pow_sitter; pow_D; pow_random];
NULL  = NULL  + [Nul_FQ; Nul_sitter; Nul_D; Nul_random];
end

%%
POWER        = POWER/replication
NULL         = NULL /replication