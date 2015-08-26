%% M_Method_A_FQ
sparse_FQ = 9*ones(N,J);
item_record_FQ = zeros(length(index_cali),target_sample);
person_finish = [];
examinee_record_FQ = zeros(N,test_cali);
number_step = 1;
target_sample_step = target_sample / number_step;
people = 1:N;
targets1 = [];
targets2 = [];
targets3 = [];
targets4 = [];

%%
for step = 1:number_step
    %%
%     seq = randsample(index_cali,length(index_cali));
    seq = 1:J;
    for cali_item_index = 1:length(seq)
        %%
        unselect = 1:N;
        cali_item = seq(cali_item_index);  
        [row,col] = find(examinee_record_FQ == cali_item);
        unselect  = setdiff(unselect,row);
        logit_optimal = untitled(b_pre(cali_item));
    
        target1 = [min(2,logit_optimal*a_pre(cali_item,1)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))   min(2,logit_optimal*a_pre(cali_item,2)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))];       
        target2 = [max(-2,-2*a_pre(cali_item,2)/a_pre(cali_item,1)) min( 2, 2*a_pre(cali_item,1)/a_pre(cali_item,2))];       
        target3 = [min( 2, 2*a_pre(cali_item,2)/a_pre(cali_item,1)) max(-2,-2*a_pre(cali_item,1)/a_pre(cali_item,2))];    
        target4 = [max(-2,-logit_optimal*a_pre(cali_item,1)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2)) max(-2,-logit_optimal*a_pre(cali_item,2)/(a_pre(cali_item,1)^2+a_pre(cali_item,2)^2))]; %focus on first
        
        targets1 = [targets1; target1];
        targets2 = [targets2; target2];
        targets3 = [targets3; target3];
        targets4 = [targets4; target4];
        
        unselect = setdiff(unselect,person_finish); unselect_thetq = theta_mle(unselect,:);        
        dif1 = abs(unselect_thetq - repmat(target1,size(unselect_thetq,1),1)); dif1 = sum(dif1,2);     
        [~,sort_index] = sort(dif1);       
        person1 = unselect(sort_index(1:target_sample_step/4));
           
        unselect = setdiff(unselect,person1);       
        unselect_thetq = theta_mle(unselect,:);      
        dif2 = abs(unselect_thetq - repmat(target2,size(unselect_thetq,1),1)); dif2 = sum(dif2,2);      
        [~,sort_index] = sort(dif2);      
        person2 = unselect(sort_index(1:target_sample_step/4));
    
        unselect = setdiff(unselect,person2);    
        unselect_thetq = theta_mle(unselect,:);  
        dif3 = abs(unselect_thetq - repmat(target3,size(unselect_thetq,1),1)); dif3 = sum(dif3,2);          
        [~,sort_index] = sort(dif3);
        person3 = unselect(sort_index(1:target_sample_step/4));        
    
        unselect = setdiff(unselect,person3);      
        unselect_thetq = theta_mle(unselect,:);      
        dif4 = abs(unselect_thetq - repmat(target4,size(unselect_thetq,1),1)); dif4 = sum(dif4,2);       
        [~,sort_index] = sort(dif4);
        person4 = unselect(sort_index(1:target_sample_step/4));
        
        person_select = [person1';person2';person3';person4'];       
        sparse_FQ(person_select,cali_item) = U_pre(person_select,cali_item);    
        item_record_FQ(cali_item,1:length(person_select)) = person_select;          
        sparse_select_FQ = sparse_FQ; sparse_select_FQ(sparse_select_FQ~=9)=1; sparse_select_FQ(sparse_select_FQ==9)=0;   
        person_finish = find(sum(sparse_select_FQ,2) >= test_cali);        
        
        for pp = 1:length(person_select)      
            test_index = sum(examinee_record_FQ(person_select(pp),:)~=0) + 1;
            examinee_record_FQ(person_select(pp),test_index) = cali_item;   
        end      
    end
end


%% estimate pretest item parameters through M-METHOD A
a1_Method_A_FQ = zeros(length(index_cali),1);
a2_Method_A_FQ = zeros(length(index_cali),1);
b_Method_A_FQ  = zeros(length(index_cali),1);
a1_OEM_FQ = zeros(length(index_cali),1);                
a2_OEM_FQ = zeros(length(index_cali),1);               
b_OEM_FQ  = zeros(length(index_cali),1);


%%
sparse = [sparse_FQ sparse_operational];
examinee_record = [examinee_record_operational examinee_record_FQ];
%     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_FQ(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_FQ(person_select,index_cali(j));    
    [a1_Method_A_FQ(j),a2_Method_A_FQ(j),b_Method_A_FQ(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
%     [a1_OEM_FQ(j),a2_OEM_FQ(j),b_OEM_FQ(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
% [a1_MEM_FQ,a2_MEM_FQ,b_MEM_FQ] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_FQ = sum(abs(a1_Method_A_FQ - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_FQ = sum(abs(a2_Method_A_FQ - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_FQ  = sum(abs(b_Method_A_FQ  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_FQ = sqrt(sum((a1_Method_A_FQ - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_FQ = sqrt(sum((a2_Method_A_FQ - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_FQ  = sqrt(sum((b_Method_A_FQ  - b_pre(index_cali)).^2)   / length(index_cali));     
% 
% % 
% bias_a1_OEM_FQ = sum(abs(a1_OEM_FQ - a(index_cali,1))) / length(index_cali);
% bias_a2_OEM_FQ = sum(abs(a2_OEM_FQ - a(index_cali,2))) / length(index_cali);
% bias_b_OEM_FQ  = sum(abs(b_OEM_FQ  - b(index_cali)))   / length(index_cali);
% rmse_a1_OEM_FQ = sqrt(sum((a1_OEM_FQ - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_OEM_FQ = sqrt(sum((a2_OEM_FQ - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_OEM_FQ  = sqrt(sum((b_OEM_FQ  - b(index_cali)).^2)   / length(index_cali));     
% 
% %
% bias_a1_MEM_FQ = sum(abs(a1_MEM_FQ - a(index_cali,1))) / length(index_cali);
% bias_a2_MEM_FQ = sum(abs(a2_MEM_FQ - a(index_cali,2))) / length(index_cali);
% bias_b_MEM_FQ  = sum(abs(b_MEM_FQ  - b(index_cali)))   / length(index_cali);
% rmse_a1_MEM_FQ = sqrt(sum((a1_MEM_FQ - a(index_cali,1)).^2) / length(index_cali));
% rmse_a2_MEM_FQ = sqrt(sum((a2_MEM_FQ - a(index_cali,2)).^2) / length(index_cali));
% rmse_b_MEM_FQ  = sqrt(sum((b_MEM_FQ  - b(index_cali)).^2)   / length(index_cali));     
