%% Data simulation
clear; clc; close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')

%%
tic
BIAS_METHODA = zeros(4,3);
BIAS_OEM     = zeros(4,3);
BIAS_MEM     = zeros(4,3);
RMSE_METHODA = zeros(4,3);
RMSE_OEM     = zeros(4,3);
RMSE_MEM     = zeros(4,3);
    
for replication = 1:10;
    replication
    %%
    N = 5000; %number of examinees
    n = 1000; %number of operational items
    J = 9;    %number of pretest items
    test_cali        = 3;   %length of pretest
    index_cali       = 1:J; %index of pretest items 
    target_sample    = 300; %target sample size of pretest items
    test_operational = 47;  %length of operational test
    
    [theta,a,b,U] = MIRT_data_simulation(N,n+J);
    
%     [theta1,theta2] = meshgrid(linspace(-2,2,35));
%     theta  = [theta1(:) theta2(:)];
    theta = sortrows(theta,1);
%     N = size(theta,1);
    U      = MIRT_response2D(theta(:,1),theta(:,2),a(:,1),a(:,2),b);
% 

    a_pre  = a(1:J,:);
    b_pre  = b(1:J);
    U_oper = U(:,1+J:n+J);
    U_pre  = U(:,1:J);

    theta_mle = zeros(N,2);
    sparse_operational = 9*ones(N,n);
    examinee_record_operational = zeros(N,test_operational);

%     %% conduct a normal CAT process
%     for examinee = 1:N
%         %randomly select the first 5 items   
%         item_select = randsample(1:n,5);   
%         response    = U_oper(examinee,item_select); % Get the response for the first 5 items    
%         sparse_operational(examinee,item_select)  = response;    
%         examinee_record_operational(examinee,1:5) = item_select;
%         theta_mle(examinee,:) = MLE_MIRT2D(a_oper(:,1),a_oper(:,2),b_oper,item_select,response);    
%         for test = 6:test_operational        
%             unselected  = setdiff(1:n,item_select);        
%             information = Doptimality2D(theta_mle(examinee,1),theta_mle(examinee,2),a_oper(1:n,1),a_oper(1:n,2),b_oper(1:n),item_select);            
%             max_index   = find(information(unselected) == max(information(unselected)));
%             next_item   = unselected(max_index);          
%             item_select = [item_select next_item];           
%             response    = U_oper(examinee,item_select);        
%             sparse_operational(examinee,item_select)   = response;       
%             examinee_record_operational(examinee,test) = next_item;
%             theta_mle(examinee,:) = MLE_MIRT2D(a_oper(:,1),a_oper(:,2),b_oper,item_select,response);           
%         end        
%     end  
%     examinee_record_operational = examinee_record_operational + J;
% 
%     %
%     BIAS_theta = BIAS_compute(theta,theta_mle);
%     RMSE_theta = RMSE_compute(theta,theta_mle);
% 
%     estimated_theta = theta_mle;
    %%
    theta_mle = theta;
    %% online calibration
    
%     conduct M-Method A
%     M_FQ_practical
%     M_sitter_practical
%     M_D_practical
%     M_random_practical
    
    M_FQ
    M_Sitter
    M_DirectD1
    M_Random
%     

%%
    BIAS_METHODA = BIAS_METHODA + [bias_a1_METHOD_A_FQ bias_a2_METHOD_A_FQ bias_b_METHOD_A_FQ;...
        bias_a1_METHOD_A_sitter bias_a2_METHOD_A_sitter bias_b_METHOD_A_sitter;...
        bias_a1_METHOD_A_D bias_a2_METHOD_A_D bias_b_METHOD_A_D;...
        bias_a1_METHOD_A_random bias_a2_METHOD_A_random bias_b_METHOD_A_random];
%     
%     BIAS_OEM = BIAS_OEM + [bias_a1_OEM_FQ bias_a2_OEM_FQ bias_b_OEM_FQ;...
%         bias_a1_OEM_sitter bias_a2_OEM_sitter bias_b_OEM_sitter;...
%         bias_a1_OEM_D bias_a2_OEM_D bias_b_OEM_D;...
%         bias_a1_OEM_random bias_a2_OEM_random bias_b_OEM_random];
%         
%     BIAS_MEM = BIAS_MEM + [bias_a1_MEM_FQ bias_a2_MEM_FQ bias_b_MEM_FQ;...
%         bias_a1_MEM_sitter bias_a2_MEM_sitter bias_b_MEM_sitter;...
%         bias_a1_MEM_D bias_a2_MEM_D bias_b_MEM_D;...
%         bias_a1_MEM_random bias_a2_MEM_random bias_b_MEM_random];
% %     

%   
    RMSE_METHODA = RMSE_METHODA + [rmse_a1_METHOD_A_FQ rmse_a2_METHOD_A_FQ rmse_b_METHOD_A_FQ;...
        rmse_a1_METHOD_A_sitter rmse_a2_METHOD_A_sitter rmse_b_METHOD_A_sitter;...
        rmse_a1_METHOD_A_D rmse_a2_METHOD_A_D rmse_b_METHOD_A_D;...
        rmse_a1_METHOD_A_random rmse_a2_METHOD_A_random rmse_b_METHOD_A_random];
%     
%     RMSE_OEM = RMSE_OEM + [rmse_a1_OEM_FQ rmse_a2_OEM_FQ rmse_b_OEM_FQ;...
%         rmse_a1_OEM_sitter rmse_a2_OEM_sitter rmse_b_OEM_sitter;...
%         rmse_a1_OEM_D rmse_a2_OEM_D rmse_b_OEM_D;...
%         rmse_a1_OEM_random rmse_a2_OEM_random rmse_b_OEM_random];
%         
%     RMSE_MEM = RMSE_MEM + [rmse_a1_MEM_FQ rmse_a2_MEM_FQ rmse_b_MEM_FQ;...
%         rmse_a1_MEM_sitter rmse_a2_MEM_sitter rmse_b_MEM_sitter;...
%         rmse_a1_MEM_D rmse_a2_MEM_D rmse_b_MEM_D;...
%         rmse_a1_MEM_random rmse_a2_MEM_random rmse_b_MEM_random];
end
toc
%%
BIAS_METHODA = BIAS_METHODA/replication
% BIAS_OEM     = BIAS_OEM/replication
% BIAS_MEM     = BIAS_MEM/replication

RMSE_METHODA = RMSE_METHODA/replication
% RMSE_OEM     = RMSE_OEM/replication
% RMSE_MEM     = RMSE_MEM/replication

