clear
close all
clc
cd('~/dropbox/dissertation/simulation/mirt/mcat online calibration')

N = 5000;                 % number of examinees
n = 500;                   % number of items in the item pool
index_cali = 1:3;         % the first 30 items in the item pool are needed to be calibrated
test_operational = 37;
test_cali = 500;
Proportion = [0];          % the proportion after which adaptive design begins

number_method = 5;
random_switch = 1;         % random selection
examinee_switch = 0;       % examinee centered selection
D_switch = 0;              % item centered direct D comparison
sitter_switch =0;          % sitter and torsney's method
target_switch = 1;         % proposed target-point method
 
%
BIAS_a1_METHOD_A = zeros(length(Proportion),number_method);
BIAS_a2_METHOD_A = zeros(length(Proportion),number_method);
BIAS_b_METHOD_A  = zeros(length(Proportion),number_method);
BIAS_a1_OEM      = zeros(length(Proportion),number_method);
BIAS_a2_OEM      = zeros(length(Proportion),number_method);
BIAS_b_OEM       = zeros(length(Proportion),number_method);
% BIAS_a1_MEM      = zeros(length(Proportion),number_method);
% BIAS_a2_MEM      = zeros(length(Proportion),number_method);
% BIAS_b_MEM       = zeros(length(Proportion),number_method);
    
RMSE_a1_METHOD_A = zeros(length(Proportion),number_method);
RMSE_a2_METHOD_A = zeros(length(Proportion),number_method);
RMSE_b_METHOD_A  = zeros(length(Proportion),number_method);
RMSE_a1_OEM      = zeros(length(Proportion),number_method);
RMSE_a2_OEM      = zeros(length(Proportion),number_method);
RMSE_b_OEM       = zeros(length(Proportion),number_method);
% RMSE_a1_MEM      = zeros(length(Proportion),number_method);
% RMSE_a2_MEM      = zeros(length(Proportion),number_method);
% RMSE_b_MEM       = zeros(length(Proportion),number_method);

%% replication begins
tic
for replication = 1
    replication 
    %% initialize parameters
    theta = mvnrnd([0;0],[.5,0;0,.5],N);
    theta(theta>2)  = 2;
    theta(theta<-2) = -2;
    a = mvnrnd([.25;.25],[.4,.1; .1,.4],n);
    a = exp(a);
    a(a>2) = 2; 
    b = normrnd(0,.5,n,1);
    b(b>2)  = 2;
    b(b<-2) = -2;
    U = MIRT_response2D(theta(:,1),theta(:,2),a(:,1),a(:,2),b);
%%
    bias_a1_METHOD_A = zeros(length(Proportion),number_method);
    bias_a2_METHOD_A = zeros(length(Proportion),number_method);
    bias_b_METHOD_A  = zeros(length(Proportion),number_method);
    bias_a1_OEM      = zeros(length(Proportion),number_method);
    bias_a2_OEM      = zeros(length(Proportion),number_method);
    bias_b_OEM       = zeros(length(Proportion),number_method);
%     bias_a1_MEM      = zeros(length(Proportion),number_method);
%     bias_a2_MEM      = zeros(length(Proportion),number_method);
%     bias_b_MEM       = zeros(length(Proportion),number_method);
    
    rmse_a1_METHOD_A = zeros(length(Proportion),number_method);
    rmse_a2_METHOD_A = zeros(length(Proportion),number_method);
    rmse_b_METHOD_A  = zeros(length(Proportion),number_method);
    rmse_a1_OEM      = zeros(length(Proportion),number_method);
    rmse_a2_OEM      = zeros(length(Proportion),number_method);
    rmse_b_OEM       = zeros(length(Proportion),number_method);
%     rmse_a1_MEM      = zeros(length(Proportion),number_method);
%     rmse_a2_MEM      = zeros(length(Proportion),number_method);
%     rmse_b_MEM       = zeros(length(Proportion),number_method);
%%
    ite = 0;
    %%
    % for each proportion value
    for proportion = Proportion
        proportion 
        %%
        ite = ite + 1;
        %%
        %%% CAT SIMULATION
        [sparse_random,sparse_examinee,sparse_D,sparse_sitter,sparse_target,theta_mle,item_record_random,item_record_examinee,item_record_D,item_record_sitter,item_record_target]...
            = CAT_simulation(U,a,b,index_cali,test_operational,test_cali,proportion,random_switch,examinee_switch,D_switch,sitter_switch,target_switch);

        %%
        bias_theta = [BIAS_compute(theta_mle(:,1),theta(:,1)) BIAS_compute(theta_mle(:,2),theta(:,2))];
        rmse_theta = [RMSE_compute(theta_mle(:,1),theta(:,1)) RMSE_compute(theta_mle(:,2),theta(:,2))];
        
        %%% estimation
        for method = 1:number_method
            if method ==1
                sparse = sparse_random;
                item_record = item_record_random;
                method_switch = random_switch;
            elseif method == 2
                sparse = sparse_examinee;
                item_record = item_record_examinee;
                method_switch = examinee_switch;
            elseif method == 3
                sparse = sparse_D;
                item_record = item_record_D;
                method_switch = D_switch;
            elseif method == 4
                sparse = sparse_sitter;
                item_record = item_record_sitter;
                method_switch = sitter_switch;
            elseif method == 5
                sparse = sparse_target;
                item_record = item_record_target;
                method_switch = target_switch;
            end
            
            if method_switch == 1
                %%% M-METHOD A
                a1_Method_A = zeros(length(index_cali),1);
                a2_Method_A = zeros(length(index_cali),1);
                b_Method_A  = zeros(length(index_cali),1);
                for cali_item = index_cali
                    % get the persons who answered this pretest item
                    person_select   = item_record(cali_item,:)';
                    person_select = person_select(person_select~=0);
                    response_select = sparse(person_select,index_cali(cali_item));
                    [a1_Method_A(cali_item),a2_Method_A(cali_item),b_Method_A(cali_item)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
                end
                % measure the accuracy
                bias_a1_METHOD_A(ite,method) = BIAS_compute(a1_Method_A,a(index_cali,1));
                bias_a2_METHOD_A(ite,method) = BIAS_compute(a2_Method_A,a(index_cali,2));
                bias_b_METHOD_A(ite,method)  = BIAS_compute(b_Method_A ,b(index_cali  ));
                rmse_a1_METHOD_A(ite,method) = RMSE_compute(a1_Method_A,a(index_cali,1));
                rmse_a2_METHOD_A(ite,method) = RMSE_compute(a2_Method_A,a(index_cali,2));
                rmse_b_METHOD_A(ite,method)  = RMSE_compute(b_Method_A ,b(index_cali  ));
                %%% M-OEM
                a1_OEM = zeros(length(index_cali),1);
                a2_OEM = zeros(length(index_cali),1);
                b_OEM  = zeros(length(index_cali),1);
                for cali_item = index_cali
                    person_select = item_record(cali_item,:)';
                    person_select = person_select(person_select~=0);
                    [a1_OEM(cali_item),a2_OEM(cali_item),b_OEM(cali_item)] = OEM_MCAT(sparse,index_cali,item_record,test_operational,cali_item,a,b,person_select);
                end
                bias_a1_OEM(ite,method) = BIAS_compute(a1_OEM,a(index_cali,1));
                bias_a2_OEM(ite,method) = BIAS_compute(a2_OEM,a(index_cali,2));
                bias_b_OEM(ite,method)  = BIAS_compute(b_OEM ,b(index_cali  ));
                rmse_a1_OEM(ite,method) = RMSE_compute(a1_OEM,a(index_cali,1));
                rmse_a2_OEM(ite,method) = RMSE_compute(a2_OEM,a(index_cali,2));
                rmse_b_OEM(ite,method)  = RMSE_compute(b_OEM ,b(index_cali  ));
%                 %%% M-MEM
%                 [a1_MEM,a2_MEM,b_MEM] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);
%                 bias_a1_MEM(ite,method) = BIAS_compute(a1_MEM,a(index_cali,1));
%                 bias_a2_MEM(ite,method) = BIAS_compute(a2_MEM,a(index_cali,2));
%                 bias_b_MEM(ite,method)  = BIAS_compute(b_MEM ,b(index_cali  ));
%                 rmse_a1_MEM(ite,method) = RMSE_compute(a1_MEM,a(index_cali,1));
%                 rmse_a2_MEM(ite,method) = RMSE_compute(a2_MEM,a(index_cali,2));
%                 rmse_b_MEM(ite,method)  = RMSE_compute(b_MEM ,b(index_cali  ));
            end
        end
    end
        
    BIAS_a1_METHOD_A = BIAS_a1_METHOD_A + bias_a1_METHOD_A;
    BIAS_a2_METHOD_A = BIAS_a2_METHOD_A + bias_a2_METHOD_A;
    BIAS_b_METHOD_A  = BIAS_b_METHOD_A + bias_b_METHOD_A;
    BIAS_a1_OEM = BIAS_a1_OEM + bias_a1_OEM;
    BIAS_a2_OEM = BIAS_a2_OEM + bias_a2_OEM;
    BIAS_b_OEM  = BIAS_b_OEM + bias_b_OEM;
%     BIAS_a1_MEM = BIAS_a1_MEM + bias_a1_MEM;
%     BIAS_a2_MEM = BIAS_a2_MEM + bias_a2_MEM;
%     BIAS_b_MEM  = BIAS_b_MEM + bias_b_MEM;
    
    RMSE_a1_METHOD_A = RMSE_a1_METHOD_A + rmse_a1_METHOD_A;
    RMSE_a2_METHOD_A = RMSE_a2_METHOD_A + rmse_a2_METHOD_A;
    RMSE_b_METHOD_A  = RMSE_b_METHOD_A + rmse_b_METHOD_A;
    RMSE_a1_OEM = RMSE_a1_OEM + rmse_a1_OEM;
    RMSE_a2_OEM = RMSE_a2_OEM + rmse_a2_OEM;
    RMSE_b_OEM  = RMSE_b_OEM + rmse_b_OEM;
%     RMSE_a1_MEM = RMSE_a1_MEM + rmse_a1_MEM;
%     RMSE_a2_MEM = RMSE_a2_MEM + rmse_a2_MEM;
%     RMSE_b_MEM  = RMSE_b_MEM + rmse_b_MEM;
end

%%
BIAS_a1_METHOD_A = BIAS_a1_METHOD_A / replication;
BIAS_a2_METHOD_A = BIAS_a2_METHOD_A / replication;
BIAS_b_METHOD_A  = BIAS_b_METHOD_A / replication;
BIAS_a1_OEM = BIAS_a1_OEM / replication;
BIAS_a2_OEM = BIAS_a2_OEM / replication;
BIAS_b_OEM  = BIAS_b_OEM / replication;
% BIAS_a1_MEM = BIAS_a1_MEM / replication;
% BIAS_a2_MEM = BIAS_a2_MEM / replication;
% BIAS_b_MEM  = BIAS_b_MEM / replication;
    
RMSE_a1_METHOD_A = RMSE_a1_METHOD_A / replication
RMSE_a2_METHOD_A = RMSE_a2_METHOD_A / replication
RMSE_b_METHOD_A  = RMSE_b_METHOD_A / replication
RMSE_a1_OEM = RMSE_a1_OEM / replication
RMSE_a2_OEM = RMSE_a2_OEM / replication
RMSE_b_OEM  = RMSE_b_OEM / replication
% RMSE_a1_MEM = RMSE_a1_MEM / replication
% RMSE_a2_MEM = RMSE_a2_MEM / replication
% RMSE_b_MEM  = RMSE_b_MEM / replication

toc
