'sitter'
sparse_sitter_practical = 9*ones(N,J);
examinee_record_sitter_practical = zeros(size(theta,1),test_cali);
item_record_sitter_practical = zeros(J,target_sample);
unselect = index_cali;
item_finish = [];

target_p = target_sample/N;
r1 = zeros(length(index_cali),1); 
r2 = r1;
r3 = r1;
r4 = r1;

% find target points
targets1 = [];
targets2 = [];
targets3 = [];
targets4 = [];
for item = 1:J
    [x1,x2,x3,x4,y1,y2,y3,y4] = sitter(a(index_cali(item),1),a(index_cali(item),2),b(index_cali(item)));
    [r1(item),r2(item),r3(item),r4(item)] = target_radius([x1 y1],[x2 y2],[x3 y3],[x4 y4],target_p);
    
    targets1 = [targets1; [x1 y1]];
    targets2 = [targets2; [x2 y2]];
    targets3 = [targets3; [x3 y3]];
    targets4 = [targets4; [x4 y4]];
end

%%
times = 1.3;
for examinee = 1:N
    unselect = setdiff(unselect,item_finish);
    
    dif1 = sum(abs(repmat(theta(examinee,:),length(unselect),1) - targets1(unselect,:)),2);
    dif2 = sum(abs(repmat(theta(examinee,:),length(unselect),1) - targets2(unselect,:)),2);
    dif3 = sum(abs(repmat(theta(examinee,:),length(unselect),1) - targets3(unselect,:)),2);
    dif4 = sum(abs(repmat(theta(examinee,:),length(unselect),1) - targets4(unselect,:)),2);
    
    dif = [dif1 dif2 dif3 dif4];
    [sorted,sorted_zone] = sort(dif,2,'ascend');
    [sorted_dif,item] = sort(sorted(:,1));
    item_chosen = item(1:min(length(item),test_cali));
    zone = sorted_zone(item_chosen,1);
    item_chosen = unselect(item_chosen);
    index = 1;
    
    for item_index = 1:length(item_chosen)
        item = item_chosen(item_index);
        if zone(item_index) == 1;
            targets = targets1;
            r = r1*times;
        elseif zone(item_index) == 2;
            targets = targets2;
            r = r2*times;
        elseif zone(item_index) == 3;
            targets = targets3;
            r = r3*times;
        else 
            targets = targets4;
            r = r4*times;
        end
        if sorted_dif(item_index) <= r(item_chosen(item_index))
            item_record_sitter_practical(item_chosen(item_index),sum(item_record_sitter_practical(item_chosen(item_index),:)~=0)+1) = examinee;  
            sparse_sitter_practical(examinee,item_chosen(item_index)) = U_pre(examinee,item_chosen(item_index));
            examinee_record_sitter_practical(examinee,index) = item_chosen(item_index);
            index = index + 1;
        end
    end
    % check if this item has been finished
    item_finish = unique([item_finish find(sum(item_record_sitter_practical~=0,2) >= target_sample)']);
end

%% estimate pretest item parameters through M-METHOD A
a1_Method_A_sitter_practical = zeros(length(index_cali),1);
a2_Method_A_sitter_practical = zeros(length(index_cali),1);
b_Method_A_sitter_practical  = zeros(length(index_cali),1);
a1_OEM_sitter_practical = zeros(length(index_cali),1);                
a2_OEM_sitter_practical = zeros(length(index_cali),1);               
b_OEM_sitter_practical  = zeros(length(index_cali),1);

% %%
sparse = [sparse_sitter_practical sparse_operational];
examinee_record = [examinee_record_operational examinee_record_sitter_practical];


%%
for j = 1:length(index_cali)
    % get the persons who answered this pretest item    
    person_select = item_record_sitter_practical(j,:);
    person_select = person_select(person_select ~= 0);    
    response_select = sparse_sitter_practical(person_select,index_cali(j));    
    [a1_Method_A_sitter_practical(j),a2_Method_A_sitter_practical(j),b_Method_A_sitter_practical(j)] = METHOD_A_MCAT2D(theta_mle(person_select,1),theta_mle(person_select,2),response_select);
    [a1_OEM_sitter_practical(j),a2_OEM_sitter_practical(j),b_OEM_sitter_practical(j)] = OEM_MCAT2D(sparse,examinee_record,test_operational,j,a,b,person_select);
end
[a1_MEM_sitter_practical,a2_MEM_sitter_practical,b_MEM_sitter_practical] = MEM_MCAT2D(sparse,examinee_record,test_operational,test_cali,a,b,index_cali);                             

%% summarize restuls
bias_a1_METHOD_A_sitter_practical = sum(abs(a1_Method_A_sitter_practical - a_pre(index_cali,1))) / length(index_cali);
bias_a2_METHOD_A_sitter_practical = sum(abs(a2_Method_A_sitter_practical - a_pre(index_cali,2))) / length(index_cali);
bias_b_METHOD_A_sitter_practical  = sum(abs(b_Method_A_sitter_practical  - b_pre(index_cali)))   / length(index_cali);
rmse_a1_METHOD_A_sitter_practical = sqrt(sum((a1_Method_A_sitter_practical - a_pre(index_cali,1)).^2) / length(index_cali));
rmse_a2_METHOD_A_sitter_practical = sqrt(sum((a2_Method_A_sitter_practical - a_pre(index_cali,2)).^2) / length(index_cali));
rmse_b_METHOD_A_sitter_practical  = sqrt(sum((b_Method_A_sitter_practical  - b_pre(index_cali)).^2)   / length(index_cali));   

bias_a1_OEM_sitter_practical = sum(abs(a1_OEM_sitter_practical - a(index_cali,1))) / length(index_cali);
bias_a2_OEM_sitter_practical = sum(abs(a2_OEM_sitter_practical - a(index_cali,2))) / length(index_cali);
bias_b_OEM_sitter_practical  = sum(abs(b_OEM_sitter_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_OEM_sitter_practical = sqrt(sum((a1_OEM_sitter_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_OEM_sitter_practical = sqrt(sum((a2_OEM_sitter_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_OEM_sitter_practical  = sqrt(sum((b_OEM_sitter_practical  - b(index_cali)).^2)   / length(index_cali));     
% 
% %
bias_a1_MEM_sitter_practical = sum(abs(a1_MEM_sitter_practical - a(index_cali,1))) / length(index_cali);
bias_a2_MEM_sitter_practical = sum(abs(a2_MEM_sitter_practical - a(index_cali,2))) / length(index_cali);
bias_b_MEM_sitter_practical  = sum(abs(b_MEM_sitter_practical  - b(index_cali)))   / length(index_cali);
rmse_a1_MEM_sitter_practical = sqrt(sum((a1_MEM_sitter_practical - a(index_cali,1)).^2) / length(index_cali));
rmse_a2_MEM_sitter_practical = sqrt(sum((a2_MEM_sitter_practical - a(index_cali,2)).^2) / length(index_cali));
rmse_b_MEM_sitter_practical  = sqrt(sum((b_MEM_sitter_practical  - b(index_cali)).^2)   / length(index_cali));  