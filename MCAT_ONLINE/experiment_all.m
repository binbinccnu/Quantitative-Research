clear;  close all; cd('~/dropbox/dissertation/simulation//mirt/mcat online calibration')
N =5000; n = 10; index_cali = 1:n; target_sample = 300; RMSE = zeros(3,2); BIAS = RMSE;
test_cali = 3; 

%%
for replicate = 1:100
    theta = mvnrnd([0;0],[.5,0;0,.5],N); theta(theta>2)  =  2   ; theta(theta<-2) = -2;
    a = mvnrnd([0;0],[.5,.1; .1,.5],n) ; a = exp(a); a(a>2) = 2 ; 
%     b = normrnd(0,.5,n,1); b(b>2)  = 2 ; b(b<-2) = -2;
    b = zeros(n,1);
    U = MIRT_response2D(theta(:,1),theta(:,2),a(:,1),a(:,2),b)  ;
    
    %% adaptive choice four-quadrant method
    sparse_D = 9*ones(size(U,1),size(U,2));
    item_record_D = zeros(length(index_cali),target_sample);
    person_finish = [];
    k = 2.399;
    
    for cali_item_index = 1:length(index_cali)
        cali_item = index_cali(cali_item_index);
        target1 = [a(cali_item,1)/(a(cali_item,1)^2+a(cali_item,2)^2) * 1.8153 , a(cali_item,2)/(a(cali_item,1)^2+a(cali_item,2)^2) * 1.8153];
        target2 = [a(cali_item,1)/(a(cali_item,1)^2+a(cali_item,2)^2) * -1.8153, a(cali_item,2)/(a(cali_item,1)^2+a(cali_item,2)^2) * -1.8153];
        target3 = -target1; 
        target4 = -target2;
       
        unselect = setdiff(1:N,person_finish); unselect_theta = theta(unselect,:);
        dif1 = abs(unselect_theta - repmat(target1,size(unselect_theta,1),1)); dif1 = sum(dif1,2);
        [sort_Dif,sort_index] = sort(dif1);
        person1 = unselect(sort_index(1:target_sample/4));
        
        unselect = setdiff(unselect,person_finish);
        unselect_theta = theta(unselect,:);
        dif2 = abs(unselect_theta - repmat(target2,size(unselect_theta,1),1)); dif2 = sum(dif2,2);
        [sort_Dif,sort_index] = sort(dif2);
        person2 = unselect(sort_index(1:target_sample/4));
        
        unselect = setdiff(unselect,person_finish);
        unselect_theta = theta(unselect,:);
        dif3 = abs(unselect_theta - repmat(target3,size(unselect_theta,1),1)); dif3 = sum(dif3,2);
        [sort_Dif,sort_index] = sort(dif3);
        person3 = unselect(sort_index(1:target_sample/4));
        
        unselect = setdiff(unselect,person_finish);
        unselect_theta = theta(unselect,:);
        dif4 = abs(unselect_theta - repmat(target4,size(unselect_theta,1),1)); dif4 = sum(dif4,2);
        [sort_Dif,sort_index] = sort(dif4);
        person4 = unselect(sort_index(1:target_sample/4));
        
        person_select = [person1';person2';person3';person4']; 
        sparse_D(person_select,cali_item) = U(person_select,cali_item);
        item_record_D(cali_item,1:length(person_select)) = person_select;
        
        sparse_select_D = sparse_D; sparse_select_D(sparse_select_D~=9)=1; sparse_select_D(sparse_select_D==9)=0;
        person_finish = find(sum(sparse_select_D(:,1:cali_item),2) >= test_cali);
    end
    
    % estimate pretest item parameters
    a1_Method_A_D = zeros(length(index_cali),1);
    a2_Method_A_D = zeros(length(index_cali),1);
    b_Method_A_D  = zeros(length(index_cali),1);

    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select = item_record_D(j,:);
        person_select = person_select(person_select ~= 0);
        response_select = sparse_D(person_select,index_cali(j));
        [a1_Method_A_D(j),a2_Method_A_D(j),b_Method_A_D(j)] = METHOD_A_MCAT2D(theta(person_select,1),theta(person_select,2),response_select);
    end
    
    bias_a1_METHOD_A_D = sum(abs(a1_Method_A_D - a(index_cali,1))) / length(index_cali);
    bias_a2_METHOD_A_D = sum(abs(a2_Method_A_D - a(index_cali,2))) / length(index_cali);
    bias_b_METHOD_A_D  = sum(abs(b_Method_A_D  - b(index_cali)))   / length(index_cali);
    rmse_a1_METHOD_A_D = sqrt(sum((a1_Method_A_D - a(index_cali,1)).^2) / length(index_cali));
    rmse_a2_METHOD_A_D = sqrt(sum((a2_Method_A_D - a(index_cali,2)).^2) / length(index_cali));
    rmse_b_METHOD_A_D  = sqrt(sum((b_Method_A_D  - b(index_cali)).^2)   / length(index_cali));     

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
    a1_Method_A_R = zeros(length(index_cali),1);
    a2_Method_A_R = zeros(length(index_cali),1);
    b_Method_A_R  = zeros(length(index_cali),1);
    for j = 1:length(index_cali)
        % get the persons who answered this pretest item
        person_select   = item_record_R(j,:);
        person_select = person_select(person_select ~= 0);
        response_select = sparse_R(person_select,index_cali(j));
        [a1_Method_A_R(j),a2_Method_A_R(j),b_Method_A_R(j)] = METHOD_A_MCAT2D(theta(person_select,1),theta(person_select,2),response_select);
    end
    bias_a1_METHOD_A_R = sum(abs(a1_Method_A_R - a(index_cali,1))) / length(index_cali);
    bias_a2_METHOD_A_R = sum(abs(a2_Method_A_R - a(index_cali,2))) / length(index_cali);
    bias_b_METHOD_A_R  = sum(abs(b_Method_A_R  - b(index_cali)))   / length(index_cali);
    rmse_a1_METHOD_A_R = sqrt(sum((a1_Method_A_R - a(index_cali,1)).^2) / length(index_cali));
    rmse_a2_METHOD_A_R = sqrt(sum((a2_Method_A_R - a(index_cali,2)).^2) / length(index_cali));
    rmse_b_METHOD_A_R  = sqrt(sum((b_Method_A_R  - b(index_cali)).^2)   / length(index_cali));
    
    %% summarize
    BIAS = BIAS + [bias_a1_METHOD_A_D  bias_a1_METHOD_A_R;...
        bias_a2_METHOD_A_D  bias_a2_METHOD_A_R;...
        bias_b_METHOD_A_D    bias_b_METHOD_A_R];
    RMSE = RMSE + [rmse_a1_METHOD_A_D  rmse_a1_METHOD_A_R;...
        rmse_a2_METHOD_A_D  rmse_a2_METHOD_A_R;...
        rmse_b_METHOD_A_D    rmse_b_METHOD_A_R];
end
BIAS = BIAS/replicate
RMSE = RMSE/replicate
