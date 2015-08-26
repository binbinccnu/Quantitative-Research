clear
close all
clc

N = 3000;                  % number of examinees
dim = 5;
test = 30;
p = 10;
index_cali = 1:20;         % the first 30 items in the item pool are needed to be calibrated
test_operational = 27;
test_cali = 3;

% Data simulation
alpha = randsample([1 0],N*dim,true);
alpha = reshape(alpha,N,dim);

Q1 = Permute(dim,1);
Q1 = repmat(Q1,5*p,1);
Q2 = Permute(dim,2);
Q2 = repmat(Q2,2*p,1);
Q3 = Permute(dim,3);
Q3 = repmat(Q3,p,1);
Q = [Q1;Q2;Q3];
n = size(Q,1);

s = unifrnd(0,.2,n,1);
g = unifrnd(0,.2,n,1);

U = CD_response(s,g,alpha,Q);

%%
% CAT simulation
'CAT Simulation'
tic
sparse = U;
alpha_mle = zeros(N,dim);
examinee_record = zeros(N,test_operational+test_cali);

for j = 1:N
    j
    % Select the first 5 items randomly
    item_select = randsample(setdiff(1:n,index_cali),5);    
    examinee_record(j,1:5) = item_select;
    response = U(j,item_select); % Get the response for the first 5 items
    alpha_mle(j,:) = MLE_CD(s,g,Q,item_select,response);
    for jj = 5:test_operational-1
        unselected = setdiff(setdiff(1:n,index_cali),item_select);
        information = Shannon_CD(item_select,response,s,g,Q,unselected);    
        % Select items based on Shannon Entropy         
        [sort_information,sort_index]=sort(information,'ascend'); 
        next_item = unselected(sort_index(1));   
        item_select = [item_select next_item];   
%         next_item = randsample(unselected,1);
%         item_select = [item_select next_item];
        examinee_record(j,length(item_select)) = next_item;
        response = U(j,item_select);
        % Get the theta estimate
        alpha_mle(j,:) = MLE_CD(s,g,Q,item_select,response);          
    end
    % begin online calibration process
    select_cali = []; %administered pretest item for this examinee
    for jj = 0:test_cali-1
        unselected_cali = setdiff(index_cali,select_cali);
        next_item = randsample(unselected_cali,1);
        select_cali = [select_cali next_item];
        % apply the next item
        examinee_record(j,test_operational+length(select_cali)) = next_item;
    end
    sparse(j,setdiff(1:n,[item_select select_cali])) = 9;
end

bias = sum(abs(alpha_mle - alpha))/N
rmse = sqrt(sum((alpha_mle - alpha).^2/N))
toc
clear ans select_cali next_item unselected item_select response j jj information sort_information sort_index unselected_cali


%%
s_est = zeros(length(index_cali),1);
g_est = zeros(length(index_cali),1);

for j = 1:length(index_cali)
    Q_cali = Q(index_cali(j),:);
    
    % M-METHOD A
    [s_est(j),g_est(j)] = METHOD_A_CDCAT(alpha,Q_cali,U(:,index_cali(j)));
end

% measure the accuracy
bias_s = sum(abs(s_est - s(index_cali))) / length(index_cali)
bias_g = sum(abs(g_est - g(index_cali))) / length(index_cali)

rmse_s = sqrt((s_est - s(index_cali))' * (s_est - s(index_cali)) / length(index_cali))
rmse_g = sqrt((g_est - g(index_cali))' * (g_est - g(index_cali)) / length(index_cali))



%% CD-METHOD A
'CD - METHOD A'
tic
s_Method_A = zeros(length(index_cali),1);
g_Method_A = zeros(length(index_cali),1);

person = 1:N;
for j = 1:length(index_cali)
    % get the persons who answered this pretest item
    person_select   = person(sum(examinee_record(:,(test_operational+1) : (test_operational+test_cali)) == index_cali(j),2) > 0);
    response_select = sparse(person_select,index_cali(j));
    Q_cali = Q(index_cali(j),:);
    
    % M-METHOD A
    [s_Method_A(j),g_Method_A(j)] = METHOD_A_CDCAT(alpha_mle(person_select,:),Q_cali,response_select);
end

% measure the accuracy
bias_s_METHOD_A = sum(abs(s_Method_A - s(index_cali))) / length(index_cali)
bias_g_METHOD_A = sum(abs(g_Method_A - g(index_cali))) / length(index_cali)

rmse_s_METHOD_A = sqrt((s_Method_A - s(index_cali))' * (s_Method_A - s(index_cali)) / length(index_cali))
rmse_g_METHOD_A = sqrt((g_Method_A - g(index_cali))' * (g_Method_A - g(index_cali)) / length(index_cali))
toc


%% CD-OEM
tic
'M - OEM'
s_OEM = zeros(length(index_cali),1);
g_OEM = zeros(length(index_cali),1);

for cali_item = index_cali
    
    % CD - OEM
    [s_OEM(cali_item),g_OEM(cali_item)] = OEM_CDCAT(s,g,index_cali,cali_item,Q,sparse);
end


% measure the accuracy
bias_s_OEM = sum(abs(s_OEM - s(index_cali))) / length(index_cali)
bias_g_OEM = sum(abs(g_OEM - g(index_cali))) / length(index_cali)

rmse_s_OEM = sqrt((s_OEM - s(index_cali))' * (s_OEM - s(index_cali)) / length(index_cali))
rmse_g_OEM = sqrt((g_OEM - g(index_cali))' * (g_OEM - g(index_cali)) / length(index_cali))
toc


%% CD - MEM
'M - MEM'
tic

[s_MEM,g_MEM] = MEM_CDCAT(s,g,index_cali,Q,sparse);

% measure the accuracy
bias_s_MEM = sum(abs(s_MEM - s(index_cali))) / length(index_cali)
bias_g_MEM = sum(abs(g_MEM - g(index_cali))) / length(index_cali)

rmse_s_MEM = sqrt((s_MEM - s(index_cali))' * (s_MEM - s(index_cali)) / length(index_cali))
rmse_g_MEM = sqrt((g_MEM - g(index_cali))' * (g_MEM - g(index_cali)) / length(index_cali))

toc
