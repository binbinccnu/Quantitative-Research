'Random'
sparse_random_practical = 9*ones(N,J);
examinee_record_random_practical = zeros(size(theta,1),test_cali);
item_record_random_practical = zeros(J,target_sample);
unselect = index_cali;
item_finish = [];

%%
for examinee = 1:N
    unselect = setdiff(unselect,item_finish);
    item_chosen = randsample(unselect,min(test_cali,length(unselect)));
    
    for item = 1:length(item_chosen)
        item_record_random_practical(item_chosen(item),sum(item_record_random_practical(item_chosen(item),:)~=0)+1) = examinee;  
        sparse_random_practical(examinee,item_chosen(item)) = U_pre(examinee,item_chosen(item));
        examinee_record_random_practical(examinee,1:length(item_chosen)) = item_chosen;
    end
    % check if this item has been finished
    item_finish = unique([item_finish find(sum(item_record_random_practical~=0,2) >= target_sample)']);
end

%% estimate pretest item parameters through M-METHOD A
a1_Method_A_random_practical = zeros(length(index_cali),1);
a2_Method_A_random_practical = zeros(length(index_cali),1);
b_Method_A_random_practical  = zeros(length(index_cali),1);
a1_OEM_random_practical = zeros(length(index_cali),1);                
a2_OEM_random_practical = zeros(length(index_cali),1);               
b_OEM_random_practical  = zeros(length(index_cali),1);


%%
sparse = [sparse_random_practical sparse_operational];
examinee_record = [examinee_record_operational examinee_record_random_practical];
% %     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_random_practical(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_random_practical(person_select,index_cali(j));    
    [a1_Method_A_random_practical(j),a2_Method_A_random_practical(j),b_Method_A_random_practical(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
    [a1_OEM_random_practical(j),a2_OEM_random_practical(j),b_OEM_random_practical(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
[a1_MEM_random_practical,a2_MEM_random_practical,b_MEM_random_practical] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             


%% summarize restuls
bias_a1_METHOD_A_random_practical = sum(abs(a1_Method_A_random_practical - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_random_practical = sum(abs(a2_Method_A_random_practical - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_random_practical  = sum(abs(b_Method_A_random_practical  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_random_practical = sqrt(sum((a1_Method_A_random_practical - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_random_practical = sqrt(sum((a2_Method_A_random_practical - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_random_practical  = sqrt(sum((b_Method_A_random_practical  - b_pre(index_cali)).^2)   / length(index_cali));     

bias_a1_OEM_random_practical = sum(abs(a1_OEM_random_practical - a(index_cali,1))) / length(index_cali);
bias_a2_OEM_random_practical = sum(abs(a2_OEM_random_practical - a(index_cali,2))) / length(index_cali);
bias_b_OEM_random_practical  = sum(abs(b_OEM_random_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_OEM_random_practical = sqrt(sum((a1_OEM_random_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_OEM_random_practical = sqrt(sum((a2_OEM_random_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_OEM_random_practical  = sqrt(sum((b_OEM_random_practical  - b(index_cali)).^2)   / length(index_cali));     

%
bias_a1_MEM_random_practical = sum(abs(a1_MEM_random_practical - a(index_cali,1))) / length(index_cali);
bias_a2_MEM_random_practical = sum(abs(a2_MEM_random_practical - a(index_cali,2))) / length(index_cali);
bias_b_MEM_random_practical  = sum(abs(b_MEM_random_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_MEM_random_practical = sqrt(sum((a1_MEM_random_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_MEM_random_practical = sqrt(sum((a2_MEM_random_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_MEM_random_practical  = sqrt(sum((b_MEM_random_practical  - b(index_cali)).^2)   / length(index_cali));     
