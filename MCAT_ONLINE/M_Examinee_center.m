%% M_Method_A_D
sparse_E = 9*ones(N,J);
item_record_E = zeros(length(index_cali),target_sample);
person_finish = [];
examinee_record_E = zeros(N,test_cali);
Dvalue = zeros(N,length(index_cali));
unselect = 1:N;
random_sample = round(2/5 *target_sample);

%%
% first randomly choose 100 examinees
for cali_item_index = 1:length(index_cali)
    cali_item = index_cali(cali_item_index);
    person_select = randsample(unselect,min(random_sample,length(unselect)));
    sparse_E(person_select,cali_item) = U_pre(person_select,cali_item);
    item_record_E(cali_item,1:length(person_select)) = person_select;
    sparse_select_E = sparse_E; sparse_select_E(sparse_select_E~=9)=1; sparse_select_E(sparse_select_E==9)=0;
    person_finish = find(sum(sparse_select_E(:,1:cali_item),2) >= test_cali);         
    unselect = setdiff(1:N,person_finish); 
    for pp = 1:length(person_select)
        test_index = sum(sparse_select_E(person_select(pp),1:cali_item),2);
        examinee_record_E(person_select(pp),test_index) = cali_item;
    end
end
    
    
for cali_item_index = 1:length(index_cali)
    cali_item = index_cali(cali_item_index);
    
    unselect = setdiff(unselect,item_record_E(cali_item,item_record_E(cali_item,:)~=0));
    Dvalue(:,cali_item) = Doptimality2Dpar_matrix(theta_mle(:,1),theta_mle(:,2),a(:,1),a(:,2),b,sparse_E,1:N,cali_item);       
    [~,sort_index]=sort(Dvalue(unselect,cali_item),'descend');
    person_select = unselect(sort_index(1:min(target_sample-random_sample,length(person_unselect)))); 
    sparse_E(person_select,cali_item) = U_pre(person_select,cali_item);       
                                
    item_record_E(cali_item,1:length(person_select)) = person_select;       
    sparse_select_E = sparse_E; sparse_select_E(sparse_select_E~=9)=1; sparse_select_E(sparse_select_E==9)=0;
    person_finish = find(sum(sparse_select_E(:,1:cali_item),2) >= test_cali);     
                       
    for pp = 1:length(person_select)
        test_index = sum(sparse_select_E(person_select(pp),1:cali_item),2);
        examinee_record_E(person_select(pp),test_index) = cali_item;
    end
end


%% estimate pretest item parameters through M-METHOD A
a1_Method_A_E = zeros(length(index_cali),1);
a2_Method_A_E = zeros(length(index_cali),1);
b_Method_A_E  = zeros(length(index_cali),1);
a1_OEM_E = zeros(length(index_cali),1);                
a2_OEM_E = zeros(length(index_cali),1);               
b_OEM_E  = zeros(length(index_cali),1);


%%
sparse = [sparse_E sparse_operational];
examinee_record = [examinee_record_operational examinee_record_E];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_E(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_E(person_select,index_cali(j));    
    [a1_Method_A_E(j),a2_Method_A_E(j),b_Method_A_E(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
    [a1_OEM_E(j),a2_OEM_E(j),b_OEM_E(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
[a1_MEM_E,a2_MEM_E,b_MEM_E] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_E = sum(abs(a1_Method_A_E - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_E = sum(abs(a2_Method_A_E - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_E  = sum(abs(b_Method_A_E  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_E = sqrt(sum((a1_Method_A_E - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_E = sqrt(sum((a2_Method_A_E - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_E  = sqrt(sum((b_Method_A_E  - b_pre(index_cali)).^2)   / length(index_cali));     

% 
bias_a1_OEM_E = sum(abs(a1_OEM_E - a(index_cali,1))) / length(index_cali);
bias_a2_OEM_E = sum(abs(a2_OEM_E - a(index_cali,2))) / length(index_cali);
bias_b_OEM_E  = sum(abs(b_OEM_E  - b(index_cali)))   / length(index_cali);
rmse_a1_OEM_E = sqrt(sum((a1_OEM_E - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_OEM_E = sqrt(sum((a2_OEM_E - a(index_cali,2)).^2) / length(index_cali));
rmse_b_OEM_E  = sqrt(sum((b_OEM_E  - b(index_cali)).^2)   / length(index_cali));     

%
bias_a1_MEM_E = sum(abs(a1_MEM_E - a(index_cali,1))) / length(index_cali);
bias_a2_MEM_E = sum(abs(a2_MEM_E - a(index_cali,2))) / length(index_cali);
bias_b_MEM_E  = sum(abs(b_MEM_E  - b(index_cali)))   / length(index_cali);
rmse_a1_MEM_E = sqrt(sum((a1_MEM_E - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_MEM_E = sqrt(sum((a2_MEM_E - a(index_cali,2)).^2) / length(index_cali));
rmse_b_MEM_E  = sqrt(sum((b_MEM_E  - b(index_cali)).^2)   / length(index_cali));     
