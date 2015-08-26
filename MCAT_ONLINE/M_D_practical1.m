'D optimal'
examinee_record_D_practical = zeros(size(theta,1),test_cali);
item_record_D_practical = zeros(J,target_sample);
unselect = index_cali;
item_finish = [];
random_sample_size = 50;
sparse_D_practical = [9*ones(N,J) sparse_operational];
power = .1;

% first 50 examinee randomly choose items
for examinee = 1:random_sample_size
    unselect = setdiff(unselect,item_finish);
    item_chosen = randsample(unselect,test_cali);

    for item = 1:length(item_chosen)
        item_record_D_practical(item_chosen(item),sum(item_record_D_practical(item_chosen(item),:)~=0)+1) = examinee;  
        sparse_D_practical(examinee,item_chosen(item)) = U_pre(examinee,item_chosen(item));
        examinee_record_D_practical(examinee,1:length(item_chosen)) = item_chosen;
    end
    % check if this item has been finished
    item_finish = unique([item_finish find(sum(item_record_D_practical~=0,2) >= target_sample)']);
end
item_finish = unique(find(sum(item_record_D_practical~=0,2) >= target_sample)');


%% then choose based on D values
unselect = index_cali;
for examinee = random_sample_size+1 : N
    Dvalue = zeros(length(index_cali),3);
    unselect = setdiff(unselect,item_finish);
    for item = 1:length(index_cali)
        [Dvalue(item,1),Dvalue(item,2),Dvalue(item,3)] = Doptimality2Dpar_matrix1(theta_mle(:,1),theta_mle(:,2),a(:,1),a(:,2),b,sparse_D_practical,examinee,index_cali(item));
    end
    [sorted_dif,sort_index] = sort(Dvalue(unselect,3),'descend');
    item_chosen = unselect(sort_index(1:min(test_cali,length(unselect)))); 
    index = 1;
    
    for item_index = 1:length(item_chosen)
        item = item_chosen(item_index);
        threshold = (sum(item_record_D_practical(item,:)~=0))^power;
        % check increment of the D value
        if sorted_dif(item_index) >= threshold
            item_record_D_practical(item_chosen(item_index),sum(item_record_D_practical(item_chosen(item_index),:)~=0)+1) = examinee;  
            sparse_D_practical(examinee,item_chosen(item_index)) = U_pre(examinee,item_chosen(item_index));
            examinee_record_D_practical(examinee,index) = item_chosen(item_index);
            index = index + 1;
        end
    end
    % check if this item has been finished
    item_finish = unique([item_finish find(sum(item_record_D_practical~=0,2) >= target_sample)']);
end

%% estimate pretest item parameters through M-METHOD A
a1_Method_A_D_practical = zeros(length(index_cali),1);
a2_Method_A_D_practical = zeros(length(index_cali),1);
b_Method_A_D_practical  = zeros(length(index_cali),1);
a1_OEM_D_practical = zeros(length(index_cali),1);                
a2_OEM_D_practical = zeros(length(index_cali),1);               
b_OEM_D_practical  = zeros(length(index_cali),1);

% 
% %%
sparse = [sparse_D_practical sparse_operational];
examinee_record = [examinee_record_operational examinee_record_D_practical];
% %     
%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_D_practical(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_D_practical(person_select,index_cali(j));    
    [a1_Method_A_D_practical(j),a2_Method_A_D_practical(j),b_Method_A_D_practical(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
    [a1_OEM_D_practical(j),a2_OEM_D_practical(j),b_OEM_D_practical(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
[a1_MEM_D_practical,a2_MEM_D_practical,b_MEM_D_practical] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             


%% summarize restuls
bias_a1_METHOD_A_D_practical = sum(abs(a1_Method_A_D_practical - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_D_practical = sum(abs(a2_Method_A_D_practical - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_D_practical  = sum(abs(b_Method_A_D_practical  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_D_practical = sqrt(sum((a1_Method_A_D_practical - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_D_practical = sqrt(sum((a2_Method_A_D_practical - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_D_practical  = sqrt(sum((b_Method_A_D_practical  - b_pre(index_cali)).^2)   / length(index_cali));     
% 
bias_a1_OEM_D_practical = sum(abs(a1_OEM_D_practical - a(index_cali,1))) / length(index_cali);
bias_a2_OEM_D_practical = sum(abs(a2_OEM_D_practical - a(index_cali,2))) / length(index_cali);
bias_b_OEM_D_practical  = sum(abs(b_OEM_D_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_OEM_D_practical = sqrt(sum((a1_OEM_D_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_OEM_D_practical = sqrt(sum((a2_OEM_D_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_OEM_D_practical  = sqrt(sum((b_OEM_D_practical  - b(index_cali)).^2)   / length(index_cali));     

%
bias_a1_MEM_D_practical = sum(abs(a1_MEM_D_practical - a(index_cali,1))) / length(index_cali);
bias_a2_MEM_D_practical = sum(abs(a2_MEM_D_practical - a(index_cali,2))) / length(index_cali);
bias_b_MEM_D_practical  = sum(abs(b_MEM_D_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_MEM_D_practical = sqrt(sum((a1_MEM_D_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_MEM_D_practical = sqrt(sum((a2_MEM_D_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_MEM_D_practical  = sqrt(sum((b_MEM_D_practical  - b(index_cali)).^2)   / length(index_cali));     
