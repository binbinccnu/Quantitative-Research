%% M_Method_A_random
sparse_R = 9*ones(N,J);
item_record_R = zeros(length(index_cali),target_sample);
person_finish = [];
person_unselect = 1:N;
examinee_record_random = zeros(N,test_cali);
   
%%
for cali_item_index = 1:length(index_cali)        
    cali_item = index_cali(cali_item_index);
    
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
    
      
    for pp = 1:length(person_select)
        test_index = sum(examinee_record_random(person_select(pp),:)~=0) + 1;
        examinee_record_random(person_select(pp),test_index) = cali_item;
    end
end


%% estimate pretest item parameters through M-METHOD A
a1_Method_A_random = zeros(length(index_cali),1);
a2_Method_A_random = zeros(length(index_cali),1);
b_Method_A_random  = zeros(length(index_cali),1);
a1_OEM_random = zeros(length(index_cali),1);                
a2_OEM_random = zeros(length(index_cali),1);               
b_OEM_random  = zeros(length(index_cali),1);

%%
sparse = [sparse_R sparse_operational];
examinee_record = [examinee_record_operational examinee_record_random];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_R(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_R(person_select,index_cali(j));    
    [a1_Method_A_random(j),a2_Method_A_random(j),b_Method_A_random(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
%     [a1_OEM_random(j),a2_OEM_random(j),b_OEM_random(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
% [a1_MEM_random,a2_MEM_random,b_MEM_random] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_random = sum(abs(a1_Method_A_random - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_random = sum(abs(a2_Method_A_random - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_random  = sum(abs(b_Method_A_random  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_random = sqrt(sum((a1_Method_A_random - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_random = sqrt(sum((a2_Method_A_random - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_random  = sqrt(sum((b_Method_A_random  - b_pre(index_cali)).^2)   / length(index_cali));     

% % 
% bias_a1_OEM_random = sum(abs(a1_OEM_random - a(index_cali,1))) / length(index_cali);
% bias_a2_OEM_random = sum(abs(a2_OEM_random - a(index_cali,2))) / length(index_cali);
% bias_b_OEM_random  = sum(abs(b_OEM_random  - b(index_cali)))   / length(index_cali);
% rmse_a1_OEM_random = sqrt(sum((a1_OEM_random - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_OEM_random = sqrt(sum((a2_OEM_random - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_OEM_random  = sqrt(sum((b_OEM_random  - b(index_cali)).^2)   / length(index_cali));     
% 
% %
% bias_a1_MEM_random = sum(abs(a1_MEM_random - a(index_cali,1))) / length(index_cali);
% bias_a2_MEM_random = sum(abs(a2_MEM_random - a(index_cali,2))) / length(index_cali);
% bias_b_MEM_random  = sum(abs(b_MEM_random  - b(index_cali)))   / length(index_cali);
% rmse_a1_MEM_random = sqrt(sum((a1_MEM_random - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_MEM_random = sqrt(sum((a2_MEM_random - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_MEM_random  = sqrt(sum((b_MEM_random  - b(index_cali)).^2)   / length(index_cali));     
