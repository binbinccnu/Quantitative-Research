sparse_FQ_practical = 9*ones(N,J);
examinee_record_FQ_practical = zeros(size(theta,1),test_cali);
item_record_FQ_practical = zeros(J,target_sample);
unselect = index_cali;
item_finish = [];
item_record_zone = zeros(length(index_cali),4);

% find target points
targets1 = [];
targets2 = [];
targets3 = [];
targets4 = [];
target_p = target_sample/N;
r1 = zeros(length(index_cali),1); 
r2 = r1;
r3 = r1;
r4 = r1;

%%
for cali_item = 1:J
    logit_optimal = untitled(b_pre(cali_item));
    target1 = [min(2,logit_optimal*a_pre(cali_item,1)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))   min(2,logit_optimal*a_pre(cali_item,2)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))];       
    target2 = [max(-2,-2*a_pre(cali_item,2)/a_pre(cali_item,1)) min( 2, 2*a_pre(cali_item,1)/a_pre(cali_item,2))];       
    target3 = [min( 2, 2*a_pre(cali_item,2)/a_pre(cali_item,1)) max(-2,-2*a_pre(cali_item,1)/a_pre(cali_item,2))];    
    target4 = [max(-2,-logit_optimal*a_pre(cali_item,1)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2)) max(-2,-logit_optimal*a_pre(cali_item,2)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))]; %focus on first
        
    % compute radius for each target point
    
    [r1(cali_item),r2(cali_item),r3(cali_item),r4(cali_item)] = target_radius(target1,target2,target3,target4,target_p);
    
    targets1 = [targets1; target1];
    targets2 = [targets2; target2];
    targets3 = [targets3; target3];
    targets4 = [targets4; target4];
end


%%
for examinee = 1:N
    unselect = setdiff(unselect,item_finish);
    % decide which zone it is
    zone = zone_divide(theta(examinee,:));
    times = 1.4;
    if zone == 1
        targets = targets1;
        dif = sum(sqrt((repmat(theta(examinee,:),J,1) - targets1).^2),2);
        r = r1*times;
    elseif zone == 2
        targets = targets2;
        dif = sum(sqrt((repmat(theta(examinee,:),J,1) - targets2).^2),2);
        r = r2*times;
    elseif zone == 3
        targets = targets4;
        dif = sum(sqrt((repmat(theta(examinee,:),J,1) - targets4).^2),2);
        r = r4*times;
    elseif zone == 4
        targets = targets3;
        dif = sum(sqrt((repmat(theta(examinee,:),J,1) - targets3).^2),2);
        r = r3*times;
    end
    [sorted_diff,sort_index] = sort(dif(unselect),'ascend');
    item_chosen = unselect(sort_index(1:min(test_cali,length(unselect))));
    index = 1;
    for item = 1:length(item_chosen)
        if sorted_diff(item) <= r(item_chosen(item))
            item_record_FQ_practical(item_chosen(item),sum(item_record_FQ_practical(item_chosen(item),:)~=0)+1) = examinee;  
            sparse_FQ_practical(examinee,item_chosen(item)) = U_pre(examinee,item_chosen(item));      
            examinee_record_FQ_practical(examinee,index) = item_chosen(item);
            item_record_zone(item_chosen(item),zone) = item_record_zone(item_chosen(item),zone) + 1;
            index = index + 1;
        end
    end
    % check if this item has been finished
    item_finish = unique([item_finish find(sum(item_record_FQ_practical~=0,2) >= target_sample)']);
end

%% estimate pretest item parameters through M-METHOD A
a1_Method_A_FQ_practical = zeros(length(index_cali),1);
a2_Method_A_FQ_practical = zeros(length(index_cali),1);
b_Method_A_FQ_practical  = zeros(length(index_cali),1);
% a1_OEM_FQ_practical = zeros(length(index_cali),1);                
% a2_OEM_FQ_practical = zeros(length(index_cali),1);               
% b_OEM_FQ_practical  = zeros(length(index_cali),1);


% %%
% sparse = [sparse_FQ_practical sparse_operational];
% examinee_record = [examinee_record_operational examinee_record_FQ_practical];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_FQ_practical(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_FQ_practical(person_select,index_cali(j));    
    [a1_Method_A_FQ_practical(j),a2_Method_A_FQ_practical(j),b_Method_A_FQ_practical(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
end

%% summarize restuls
bias_a1_METHOD_A_FQ_practical = sum(abs(a1_Method_A_FQ_practical - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_FQ_practical = sum(abs(a2_Method_A_FQ_practical - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_FQ_practical  = sum(abs(b_Method_A_FQ_practical  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_FQ_practical = sqrt(sum((a1_Method_A_FQ_practical - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_FQ_practical = sqrt(sum((a2_Method_A_FQ_practical - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_FQ_practical  = sqrt(sum((b_Method_A_FQ_practical  - b_pre(index_cali)).^2)   / length(index_cali));    
