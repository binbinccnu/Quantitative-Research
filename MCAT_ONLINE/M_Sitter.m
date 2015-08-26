%% M_Method_A_sitter
sparse_sitter = 9*ones(N,J);
item_record_sitter = zeros(length(index_cali),target_sample);
person_finish = [];
examinee_record_sitter = zeros(N,test_cali);
   
%%
for cali_item_index = 1:length(index_cali)        
    cali_item = index_cali(cali_item_index);
    
    [x1,x2,x3,x4,y1,y2,y3,y4] = sitter(a(cali_item,1),a(cali_item,2),b(cali_item));
    target1 = [x1 y1];     
    target2 = [x2 y2];    
    target3 = [x3 y3];    
    target4 = [x3 y4];
    
    unselect = setdiff(1:N,person_finish); unselect_thetq = theta_mle(unselect,:);    
    dif1 = abs(unselect_thetq - repmat(target1,size(unselect_thetq,1),1)); dif1 = sum(dif1,2); 
    [~,sort_index] = sort(dif1);    
    person1 = unselect(sort_index(1:target_sample/4));
        
    unselect = setdiff(unselect,person1);    
    unselect_thetq = theta_mle(unselect,:);   
    dif2 = abs(unselect_thetq - repmat(target2,size(unselect_thetq,1),1)); dif2 = sum(dif2,2);   
    [~,sort_index] = sort(dif2);  
    person2 = unselect(sort_index(1:target_sample/4));
    
    unselect = setdiff(unselect,person2);
    unselect_thetq = theta_mle(unselect,:);
    dif3 = abs(unselect_thetq - repmat(target3,size(unselect_thetq,1),1)); dif3 = sum(dif3,2);        
    [~,sort_index] = sort(dif3);
    person3 = unselect(sort_index(1:target_sample/4));        
    
    unselect = setdiff(unselect,person3);    
    unselect_thetq = theta_mle(unselect,:);    
    dif4 = abs(unselect_thetq - repmat(target4,size(unselect_thetq,1),1)); dif4 = sum(dif4,2);    
    [~,sort_index] = sort(dif4);
    person4 = unselect(sort_index(1:target_sample/4));
            
    person_select = [person1';person2';person3';person4'];   
    sparse_sitter(person_select,cali_item) = U_pre(person_select,cali_item);
    item_record_sitter(cali_item,1:length(person_select)) = person_select;       
    sparse_select_sitter = sparse_sitter; sparse_select_sitter(sparse_select_sitter~=9)=1; sparse_select_sitter(sparse_select_sitter==9)=0;
    person_finish = find(sum(sparse_select_sitter(:,1:cali_item),2) >= test_cali);    
    for pp = 1:length(person_select)
        test_index = sum(examinee_record_sitter(person_select(pp),:)~=0) + 1;
        examinee_record_sitter(person_select(pp),test_index) = cali_item;
    end
end


%% estimate pretest item parameters through M-METHOD A
a1_Method_A_sitter = zeros(length(index_cali),1);
a2_Method_A_sitter = zeros(length(index_cali),1);
b_Method_A_sitter  = zeros(length(index_cali),1);
a1_OEM_sitter = zeros(length(index_cali),1);                
a2_OEM_sitter = zeros(length(index_cali),1);               
b_OEM_sitter  = zeros(length(index_cali),1);


%%
sparse = [sparse_sitter sparse_operational];
examinee_record = [examinee_record_operational examinee_record_sitter];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_sitter(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_sitter(person_select,index_cali(j));    
    [a1_Method_A_sitter(j),a2_Method_A_sitter(j),b_Method_A_sitter(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
%     [a1_OEM_sitter(j),a2_OEM_sitter(j),b_OEM_sitter(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
% [a1_MEM_sitter,a2_MEM_sitter,b_MEM_sitter] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_sitter = sum(abs(a1_Method_A_sitter - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_sitter = sum(abs(a2_Method_A_sitter - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_sitter  = sum(abs(b_Method_A_sitter  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_sitter = sqrt(sum((a1_Method_A_sitter - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_sitter = sqrt(sum((a2_Method_A_sitter - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_sitter  = sqrt(sum((b_Method_A_sitter  - b_pre(index_cali)).^2)   / length(index_cali));     
% 
% % 
% bias_a1_OEM_sitter = sum(abs(a1_OEM_sitter - a(index_cali,1))) / length(index_cali);
% bias_a2_OEM_sitter = sum(abs(a2_OEM_sitter - a(index_cali,2))) / length(index_cali);
% bias_b_OEM_sitter  = sum(abs(b_OEM_sitter  - b(index_cali)))   / length(index_cali);
% rmse_a1_OEM_sitter = sqrt(sum((a1_OEM_sitter - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_OEM_sitter = sqrt(sum((a2_OEM_sitter - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_OEM_sitter  = sqrt(sum((b_OEM_sitter  - b(index_cali)).^2)   / length(index_cali));     
% 
% %
% bias_a1_MEM_sitter = sum(abs(a1_MEM_sitter - a(index_cali,1))) / length(index_cali);
% bias_a2_MEM_sitter = sum(abs(a2_MEM_sitter - a(index_cali,2))) / length(index_cali);
% bias_b_MEM_sitter  = sum(abs(b_MEM_sitter  - b(index_cali)))   / length(index_cali);
% rmse_a1_MEM_sitter = sqrt(sum((a1_MEM_sitter - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_MEM_sitter = sqrt(sum((a2_MEM_sitter - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_MEM_sitter  = sqrt(sum((b_MEM_sitter  - b(index_cali)).^2)   / length(index_cali));     
