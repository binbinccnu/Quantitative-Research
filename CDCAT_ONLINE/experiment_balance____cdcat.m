clear; clc; close all; cd('~/Dropbox/Dissertation/simulation/CDCAT/CDCAT ONLINE CALIBRATION')
N =5000; target_sample = 300; RMSE = zeros(2,4); BIAS = RMSE; dim = 5; p = 10;
n = 15; 
test_cali = 3; 

%%
for replicate = 1:1000
    alpha = randsample([1 0],N*dim,true); alpha = reshape(alpha,N,dim);
    % compute etas for each examinee, each item 
    Q1 = Permute(dim,1); Q1 = repmat(Q1,5*p,1);
    Q2 = Permute(dim,2); Q2 = repmat(Q2,2*p,1);
    Q3 = Permute(dim,3); Q3 = repmat(Q3,p,1);
    Q = [Q1;Q2;Q3]     ; 
    index_cali = 1:n;
    Q  = Q(randsample(size(Q,1),n),:);
    
    etas = Eta(alpha,Q);
    s = unifrnd(0,.2,n,1); s(s==0) = .01;
    g = unifrnd(0,.2,n,1); g(g==0) = .01;
    U = CD_response(s,g,alpha,Q);
    
    %% adaptive choice 1 : D-optimal
    sparse_D1 = 9*ones(size(U,1),size(U,2));
    item_record_D1 = zeros(length(index_cali),target_sample);
    person_finish = [];
    
    %
    for cali_item_index = 1:length(index_cali)
        cali_item = index_cali(cali_item_index);
       
        %n1 = target_sample/2;
        %n2 = round(target_sample*g(cali_item)*(1-g(cali_item))/(s(cali_item)*(1-s(cali_item))+g(cali_item)*(1-g(cali_item))));
        n0 = target_sample/2;
        unselect = setdiff(1:N,person_finish); unselect_eta = etas(unselect,:);
        unselect_0 = unselect(unselect_eta(:,cali_item) == 0);
        unselect_1 = unselect(unselect_eta(:,cali_item) == 1);

        person_0 = unselect_0(randsample(length(unselect_0),n0));
        person_1 = unselect_1(randsample(length(unselect_1),target_sample-n0));
        
        person_select = [person_0'; person_1']; 
        sparse_D1(person_select,cali_item) = U(person_select,cali_item);
        item_record_D1(cali_item,1:length(person_select)) = person_select;
        
        sparse_select_D1 = sparse_D1; sparse_select_D1(sparse_select_D1~=9)=1; sparse_select_D1(sparse_select_D1==9)=0;
        person_finish = find(sum(sparse_select_D1(:,1:cali_item),2) >= test_cali);
    end
    
    % estimate pretest item parameters
    s_Method_A_D1 = zeros(length(index_cali),1);
    g_Method_A_D1 = zeros(length(index_cali),1);
    
    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select = item_record_D1(j,:);
        response_select = sparse_D1(person_select,index_cali(j));
        
        [s_Method_A_D1(j),g_Method_A_D1(j)] = METHOD_A_CDCAT(alpha(person_select,:),Q(index_cali(j),:),response_select);
    end
    
    bias_s_METHOD_A_D1 = sum(abs(s_Method_A_D1 - s(index_cali))) / length(index_cali);
    bias_g_METHOD_A_D1 = sum(abs(g_Method_A_D1 - g(index_cali))) / length(index_cali);
    rmse_s_METHOD_A_D1 = sqrt(sum((s_Method_A_D1 - s(index_cali)).^2) / length(index_cali));
    rmse_g_METHOD_A_D1 = sqrt(sum((g_Method_A_D1 - g(index_cali)).^2) / length(index_cali));
    
    
        %% adaptive choice 2: 
    sparse_D2 = 9*ones(size(U,1),size(U,2));
    item_record_D2 = zeros(length(index_cali),target_sample);
    person_finish = [];
    
    %
    for cali_item_index = 1:length(index_cali)
        cali_item = index_cali(cali_item_index);
       
        n0 = round(target_sample*g(cali_item)*(1-g(cali_item))/(s(cali_item)*(1-s(cali_item))+g(cali_item)*(1-g(cali_item))));
        unselect = setdiff(1:N,person_finish); unselect_eta = etas(unselect,:);
        unselect_0 = unselect(unselect_eta(:,cali_item) == 0);
        unselect_1 = unselect(unselect_eta(:,cali_item) == 1);

        person_0 = unselect_0(randsample(length(unselect_0),n0));
        person_1 = unselect_1(randsample(length(unselect_1),target_sample-n0));
        
        person_select = [person_0'; person_1']; 
        sparse_D2(person_select,cali_item) = U(person_select,cali_item);
        item_record_D2(cali_item,1:length(person_select)) = person_select;
        
        sparse_select_D2 = sparse_D2; sparse_select_D2(sparse_select_D2~=9)=1; sparse_select_D2(sparse_select_D2==9)=0;
        person_finish = find(sum(sparse_select_D2(:,1:cali_item),2) >= test_cali);
    end
    
    % estimate pretest item parameters
    s_Method_A_D2 = zeros(length(index_cali),1);
    g_Method_A_D2 = zeros(length(index_cali),1);
    
    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select = item_record_D2(j,:);
        response_select = sparse_D2(person_select,index_cali(j));
        
        [s_Method_A_D2(j),g_Method_A_D2(j)] = METHOD_A_CDCAT(alpha(person_select,:),Q(index_cali(j),:),response_select);
    end
    
    bias_s_METHOD_A_D2 = sum(abs(s_Method_A_D2 - s(index_cali))) / length(index_cali);
    bias_g_METHOD_A_D2 = sum(abs(g_Method_A_D2 - g(index_cali))) / length(index_cali);
    rmse_s_METHOD_A_D2 = sqrt(sum((s_Method_A_D2 - s(index_cali)).^2) / length(index_cali));
    rmse_g_METHOD_A_D2 = sqrt(sum((g_Method_A_D2 - g(index_cali)).^2) / length(index_cali));
    

    %% adaptive choice 3: E-optimal
    sparse_D3 = 9*ones(size(U,1),size(U,2));
    item_record_D3 = zeros(length(index_cali),target_sample);
    person_finish = [];
    
    %
    for cali_item_index = 1:length(index_cali)
        cali_item = index_cali(cali_item_index);
        
        G = g(cali_item)*(1-g(cali_item)); S = s(cali_item)*(1-s(cali_item));
        if G/(S+G) > 2/3
            n0 = round(target_sample*2/3);
        elseif G/(S+G) < 1/3
            n0 = round(target_sample*1/3);
        else
            n0 = round(target_sample*G/(S+G));
        end
        unselect = setdiff(1:N,person_finish); unselect_eta = etas(unselect,:);
        unselect_0 = unselect(unselect_eta(:,cali_item) == 0);
        unselect_1 = unselect(unselect_eta(:,cali_item) == 1);

        person_0 = unselect_0(randsample(length(unselect_0),n0));
        person_1 = unselect_1(randsample(length(unselect_1),target_sample-n0));
        
        person_select = [person_0'; person_1']; 
        sparse_D3(person_select,cali_item) = U(person_select,cali_item);
        item_record_D3(cali_item,1:length(person_select)) = person_select;
        
        sparse_select_D3 = sparse_D3; sparse_select_D3(sparse_select_D3~=9)=1; sparse_select_D3(sparse_select_D3==9)=0;
        person_finish = find(sum(sparse_select_D3(:,1:cali_item),2) >= test_cali);
    end
    
    % estimate pretest item parameters
    s_Method_A_D3 = zeros(length(index_cali),1);
    g_Method_A_D3 = zeros(length(index_cali),1);
    
    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select = item_record_D3(j,:);
        response_select = sparse_D3(person_select,index_cali(j));
        
        [s_Method_A_D3(j),g_Method_A_D3(j)] = METHOD_A_CDCAT(alpha(person_select,:),Q(index_cali(j),:),response_select);
    end
    
    bias_s_METHOD_A_D3 = sum(abs(s_Method_A_D3 - s(index_cali))) / length(index_cali);
    bias_g_METHOD_A_D3 = sum(abs(g_Method_A_D3 - g(index_cali))) / length(index_cali);
    rmse_s_METHOD_A_D3 = sqrt(sum((s_Method_A_D3 - s(index_cali)).^2) / length(index_cali));
    rmse_g_METHOD_A_D3 = sqrt(sum((g_Method_A_D3 - g(index_cali)).^2) / length(index_cali));
    
    
    %% random choice
    sparse_R = 9*ones(size(U,1),size(U,2));
    item_record_R = zeros(length(index_cali),target_sample);
    person_unselect = 1:N;
        
    for cali_item = index_cali
        if length(person_unselect) >= target_sample
            person_select = randsample(person_unselect,target_sample);
        else 
            person_select = person_unselect;
        end
        sparse_R(person_select,cali_item) = U(person_select,cali_item);
        item_record_R(cali_item,1:length(person_select)) = person_select;
        sparse_select_R = sparse_R;
        sparse_select_R(sparse_select_R~=9)=1;
        sparse_select_R(sparse_select_R==9)=0;
        person_finish = find(sum(sparse_select_R(:,1:cali_item),2) >= test_cali);
        person_unselect = setdiff(1:N,person_finish);
    end
       
    % estimate pretest item parameters
    s_Method_A_R = zeros(length(index_cali),1);
    g_Method_A_R = zeros(length(index_cali),1);
    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select   = item_record_R(j,:);
        response_select = sparse_R(person_select,index_cali(j));
        [s_Method_A_R(j),g_Method_A_R(j)] = METHOD_A_CDCAT(alpha(person_select,:),Q(j,:),response_select);
    end
    bias_s_METHOD_A_R = sum(abs(s_Method_A_R - s(index_cali))) / length(index_cali);
    bias_g_METHOD_A_R = sum(abs(g_Method_A_R - g(index_cali))) / length(index_cali);
    rmse_s_METHOD_A_R = sqrt(sum((s_Method_A_R - s(index_cali)).^2) / length(index_cali));
    rmse_g_METHOD_A_R = sqrt(sum((g_Method_A_R - g(index_cali)).^2) / length(index_cali));    
    
    %% summarize
    BIAS = BIAS + [bias_s_METHOD_A_D1 bias_s_METHOD_A_D2 bias_s_METHOD_A_D3 bias_s_METHOD_A_R;...
        bias_g_METHOD_A_D1 bias_g_METHOD_A_D2 bias_g_METHOD_A_D3 bias_g_METHOD_A_R];
    RMSE = RMSE + [rmse_s_METHOD_A_D1 rmse_s_METHOD_A_D2 rmse_s_METHOD_A_D3 rmse_s_METHOD_A_R;...
        rmse_g_METHOD_A_D1 rmse_g_METHOD_A_D2 rmse_g_METHOD_A_D3 rmse_g_METHOD_A_R];
end
%%
BIAS = BIAS/replicate
RMSE = RMSE/replicate
