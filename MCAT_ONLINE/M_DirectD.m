%% M_Method_A_D
sparse_D = 9*ones(N,J);
item_record_D = zeros(length(index_cali),target_sample);
person_finish = [];
examinee_record_D = zeros(N,test_cali);
Dvalue   = zeros(N,length(index_cali));
unselect = 1:N;
random_sample = round(1/10 *target_sample);

%%
% first randomly choose 100 examinees
for cali_item_index = 1:length(index_cali)
    cali_item = index_cali(cali_item_index);
    person_select = randsample(unselect,min(random_sample,length(unselect)));
    sparse_D(person_select,cali_item) = U_pre(person_select,cali_item);
    item_record_D(cali_item,1:length(person_select)) = person_select;
    sparse_select_D = sparse_D; sparse_select_D(sparse_select_D~=9)=1; sparse_select_D(sparse_select_D==9)=0;
    person_finish = find(sum(sparse_select_D(:,1:cali_item),2) >= test_cali);         
    unselect = setdiff(1:N,person_finish); 
    for pp = 1:length(person_select)
        test_index = sum(examinee_record_D(person_select(pp),:)~=0) + 1;
        examinee_record_D(person_select(pp),test_index) = cali_item;
    end
end
    
  %%  
for cali_item_index = 1:length(index_cali)
    %%
    cali_item = index_cali(cali_item_index);
    
    unselect = setdiff(1:N,person_finish);
    [row,col] = find(examinee_record_D == cali_item);
    unselect  = setdiff(unselect,row);
        
    Dvalue(:,cali_item) = Doptimality2Dpar_matrix(theta_mle(:,1),theta_mle(:,2),a(:,1),a(:,2),b,sparse_D,1:N,cali_item);       
    [~,sort_index]=sort(Dvalue(unselect,cali_item),'descend');
    person_select = unselect(sort_index(1:min(target_sample-random_sample,length(unselect)))); 
    sparse_D(person_select,cali_item) = U_pre(person_select,cali_item);       
                                
    item_record_D(cali_item,random_sample+1:random_sample+length(person_select)) = person_select;       
    sparse_select_D = sparse_D; sparse_select_D(sparse_select_D~=9)=1; sparse_select_D(sparse_select_D==9)=0;
    person_finish = find(sum(sparse_select_D,2) >= test_cali);     
                       
    for pp = 1:length(person_select)
        test_index = sum(examinee_record_D(person_select(pp),:)~=0) + 1;
        examinee_record_D(person_select(pp),test_index) = cali_item;
    end
end


%% estimate pretest item parameters through M-METHOD A
a1_Method_A_D = zeros(length(index_cali),1);
a2_Method_A_D = zeros(length(index_cali),1);
b_Method_A_D  = zeros(length(index_cali),1);
a1_OEM_D      = zeros(length(index_cali),1);                
a2_OEM_D      = zeros(length(index_cali),1);               
b_OEM_D       = zeros(length(index_cali),1);


%%
sparse = [sparse_D sparse_operational];
examinee_record = [examinee_record_operational examinee_record_D];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select   = item_record_D(j,:);
    person_select   = person_select(person_select ~= 0);    
    response_select = sparse_D(person_select,index_cali(j));    
    [a1_Method_A_D(j),a2_Method_A_D(j),b_Method_A_D(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
%     [a1_OEM_D(j),a2_OEM_D(j),b_OEM_D(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
% [a1_MEM_D,a2_MEM_D,b_MEM_D] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_D = sum(abs(a1_Method_A_D - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_D = sum(abs(a2_Method_A_D - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_D  = sum(abs(b_Method_A_D  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_D = sqrt(sum((a1_Method_A_D - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_D = sqrt(sum((a2_Method_A_D - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_D  = sqrt(sum((b_Method_A_D  - b_pre(index_cali)).^2)   / length(index_cali));     

% % 
% bias_a1_OEM_D = sum(abs(a1_OEM_D - a(index_cali,1))) / length(index_cali);
% bias_a2_OEM_D = sum(abs(a2_OEM_D - a(index_cali,2))) / length(index_cali);
% bias_b_OEM_D  = sum(abs(b_OEM_D  - b(index_cali)))   / length(index_cali);
% rmse_a1_OEM_D = sqrt(sum((a1_OEM_D - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_OEM_D = sqrt(sum((a2_OEM_D - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_OEM_D  = sqrt(sum((b_OEM_D  - b(index_cali)).^2)   / length(index_cali));     
% 
% %
% bias_a1_MEM_D = sum(abs(a1_MEM_D - a(index_cali,1))) / length(index_cali);
% bias_a2_MEM_D = sum(abs(a2_MEM_D - a(index_cali,2))) / length(index_cali);
% bias_b_MEM_D  = sum(abs(b_MEM_D  - b(index_cali)))   / length(index_cali);
% rmse_a1_MEM_D = sqrt(sum((a1_MEM_D - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_MEM_D = sqrt(sum((a2_MEM_D - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_MEM_D  = sqrt(sum((b_MEM_D  - b(index_cali)).^2)   / length(index_cali));     
