function [sparse_random,sparse_examinee,sparse_D,sparse_sitter,sparse_target,theta_mle,item_record_random,item_record_examinee,item_record_D,item_record_sitter,item_record_target]...
    = CAT_simulation(U,a,b,index_cali,test_operational,test_cali,proportion,random_switch,examinee_switch,D_switch,sitter_switch,target_switch)
%%
N = size(U,1);
n = size(U,2);
theta_mle = zeros(N,2);
target_sample = 300;
zone_target_sample = target_sample / 4;
item_record = zeros(length(index_cali),4);

% give different methods
if random_switch ==1
    sparse_random = 9 * ones(N,n);
    item_record_random = zeros(length(index_cali),target_sample);
    finished_random = [];
else
    sparse_random = [];
    item_record_random = [];
end

if examinee_switch ==1
    sparse_examinee = 9 * ones(N,n);
    item_record_examinee = zeros(length(index_cali),target_sample);
    finished_examinee = [];
else
    sparse_examinee = [];
    item_record_examinee = [];
end

if D_switch == 1
    sparse_D = 9 * ones(N,n);
    item_record_D = zeros(length(index_cali),target_sample);
    finished_D = [];
else
    sparse_D = [];
    item_record_D = [];
end

if target_switch == 1
    sparse_target = 9 * ones(N,n);
    item_record_target = zeros(length(index_cali),target_sample);
    
    %find target point for each item
    target_1 = zeros(length(index_cali),2); 
    target_2 = zeros(length(index_cali),2); 
    target_3 = zeros(length(index_cali),2); 
    target_4 = zeros(length(index_cali),2); 
    for item = 1:length(index_cali)
        [target_1(item,1),target_1(item,2),target_2(item,1),target_2(item,2),target_3(item,1),target_3(item,2),target_4(item,1),target_4(item,2)]...
            = find_target_theta(a(index_cali(item),1),a(index_cali(item),2),b(index_cali(item)));
    end
    finished_target = [];
    finished_target_1 = [];
    finished_target_2 = [];
    finished_target_3 = [];
    finished_target_4 = [];
else 
    sparse_target = [];
    item_record_target = [];
end

if sitter_switch == 1
    sparse_sitter = 9 * ones(N,n);
    item_record_sitter = zeros(length(index_cali),target_sample);
    T = ones(length(index_cali),1)*N*test_cali/length(index_cali);
    t = zeros(length(index_cali),1);    
    finished_sitter = [];
else
    sparse_sitter = [];
    item_record_sitter = [];
end

%%
for j = 1:N
    examinee = j;
    % Select the first 5 items randomly
    item_select = randsample(setdiff(1:n,index_cali),5);
    response = U(examinee,item_select); % Get the response for the first 5 items  
    
    if random_switch == 1
        sparse_random(examinee,item_select) = response;
    end
    if examinee_switch == 1
        sparse_examinee(examinee,item_select) = response;
    end
    if D_switch == 1
        sparse_D(examinee,item_select) = response;
    end
    if sitter_switch == 1
        sparse_sitter(examinee,item_select) = response;
    end
    if target_switch == 1
        sparse_target(examinee,item_select) = response;
    end
    
    theta_mle(examinee,:) = MLE_MIRT2D(a(:,1),a(:,2),b,item_select,response);
    
    %%
    for jj = 5:test_operational-1
        unselected = setdiff(setdiff(1:n,index_cali),item_select);
        information = Doptimality2D(theta_mle(examinee,1),theta_mle(examinee,2),a(:,1),a(:,2),b,item_select);    
        % Select items based on D optimality          
        [~,sort_index]=sort(information(unselected),'descend'); 
        next_item = unselected(sort_index(1));  
        item_select = [item_select next_item];   
        
        if random_switch == 1
            sparse_random(examinee,next_item) = U(examinee,next_item);
        end
        if examinee_switch == 1
            sparse_examinee(examinee,next_item) = U(examinee,next_item);
        end
        if D_switch == 1
            sparse_D(examinee,next_item) = U(examinee,next_item);
        end
        if sitter_switch == 1
            sparse_sitter(examinee,next_item) = U(examinee,next_item);
        end
        if target_switch == 1
            sparse_target(examinee,next_item) = U(examinee,next_item);
        end
        response = U(examinee,item_select);
        % Get the theta estimate
        theta_mle(examinee,:) = MLE_MIRT2D(a(:,1),a(:,2),b,item_select,response);        
    end
    
    % begin online calibration process
    if random_switch == 1
        select_cali_random = []; %administered pretest item for this examinee
    end
    if examinee_switch == 1
        select_cali_examinee = [];
    end
    if D_switch == 1
        select_cali_D = [];
    end
    if sitter_switch == 1
        select_cali_sitter = [];
    end
    if target_switch == 1
        select_cali_target = [];
        zone = zone_divide(theta_mle(examinee,:));
    end
    %%
    for jj = 0:test_cali-1
        %% random selection
        if random_switch == 1
            unselected_cali_random = setdiff(index_cali,select_cali_random);
            unselected_cali_finished_random = setdiff(unselected_cali_random,finished_random);
            if ~isempty(unselected_cali_finished_random)
                if length(unselected_cali_finished_random) > 1
                    next_item = randsample(unselected_cali_finished_random,1);
                else
                    next_item = unselected_cali_finished_random;
                end
                sparse_random(examinee,next_item) = U(examinee,next_item);
                select_cali_random = [select_cali_random next_item];
                item_record_random(next_item,sum(item_record_random(next_item,:)~=0)+1) = examinee;
                % apply the next item
                if sum(sparse_random(:,next_item)~=9) == target_sample
                    finished_random = [finished_random next_item];
                end
            end
        end
        %% examinee-centered method 
        if examinee_switch == 1
            unselected_cali_examinee = setdiff(index_cali,select_cali_examinee);
            unselected_cali_finished_examinee = setdiff(unselected_cali_examinee,finished_examinee);
            if ~isempty(unselected_cali_finished_examinee)
                if examinee < N*proportion+1
                    if length(unselected_cali_finished_examinee) > 1
                        next_item = randsample(unselected_cali_finished_examinee,1); 
                    else 
                        next_item = unselected_cali_finished_examinee;
                    end
                else
                    information = Doptimality2D(theta_mle(examinee,1),theta_mle(examinee,2),a(:,1),a(:,2),b,item_select);           
                    % Select items based on D optimality                 
                    [~,sort_index_examinee]=sort(information(unselected),'descend');         
                    next_item = unselected_cali_finished_examinee(sort_index_examinee(1));          
                    item_select = [item_select next_item];           
                    if length(next_item) > 1
                        next_item = randsample(next_item,1);
                    end
                end
                sparse_examinee(examinee,next_item) = U(examinee,next_item);
                if sum(sparse_examinee(:,next_item)~=9) == target_sample
                    finished_examinee = [finished_examinee next_item];
                end
                select_cali_examinee = [select_cali_examinee next_item];
                % apply the next item
                item_record_examinee(next_item,sum(item_record_examinee(next_item,:)~=0)+1) = examinee;
            end
        end
        
        %% D index
        if D_switch == 1
            unselected_cali_D = setdiff(index_cali,select_cali_D);
            unselected_cali_finished_D = setdiff(unselected_cali_D,finished_D);
            if ~isempty(unselected_cali_finished_D)
                if examinee < N*proportion+1
                    if length(unselected_cali_finished_D) > 1
                        next_item = randsample(unselected_cali_finished_D,1); 
                    else 
                        next_item = unselected_cali_finished_D;
                    end
                else
                    Dvalue = Doptimality2Dpar(theta_mle(:,1),theta_mle(:,2),a(:,1),a(:,2),b,sparse_D,j,index_cali);
                    Priority = (T-t)./T.*Dvalue;
                    [~,sort_index_D]=sort(Priority(unselected_cali_finished_D),'descend'); 
                    next_item = unselected_cali_finished_D(sort_index_D(1));  
                    if length(next_item) > 1
                        next_item = randsample(next_item,1);
                    end
                end
                t(next_item) = t(next_item)+1;
                sparse_D(examinee,next_item) = U(examinee,next_item);
                if sum(sparse_D(:,next_item)~=9) == target_sample
                    finished_D = [finished_D next_item];
                end
                select_cali_D = [select_cali_D next_item];
                % apply the next item
                item_record_D(next_item,sum(item_record_D(next_item,:)~=0)+1) = examinee;
            end
        end
        
        %% target points
        if target_switch == 1
            % find which zone this examinee belong to
            zone = zone_divide(theta_mle(examinee,:));
            
            if zone == 1    % first  quadrant
                unselected_cali_target_1 = setdiff(index_cali,select_cali_target);
                unselected_cali_finished_target = setdiff(unselected_cali_target_1,finished_target_1);
                distance = (theta_mle(examinee,1) - target_1(:,1)).^2 + (theta_mle(examinee,2) - target_1(:,2)).^2;
            elseif zone ==2 % second quadrant
                unselected_cali_target_2 = setdiff(index_cali,select_cali_target);
                unselected_cali_finished_target = setdiff(unselected_cali_target_2,finished_target_2);
                distance = (theta_mle(examinee,1) - target_2(:,1)).^2 + (theta_mle(examinee,2) - target_2(:,2)).^2;
            elseif zone ==3 % third  quadrant
                unselected_cali_target_3 = setdiff(index_cali,select_cali_target);
                unselected_cali_finished_target = setdiff(unselected_cali_target_3,finished_target_3);
                distance = (theta_mle(examinee,1) - target_3(:,1)).^2 + (theta_mle(examinee,2) - target_3(:,2)).^2;
            elseif zone ==4 % fourth quadrant 
                unselected_cali_target_4 = setdiff(index_cali,select_cali_target);
                unselected_cali_finished_target = setdiff(unselected_cali_target_4,finished_target_4);
                distance = (theta_mle(examinee,1) - target_4(:,1)).^2 + (theta_mle(examinee,2) - target_4(:,2)).^2;
            end
            unselected_cali_target = setdiff(index_cali,select_cali_target);
            unselected_cali_finished_target = setdiff(unselected_cali_target,finished_target);
            if ~isempty(unselected_cali_finished_target)
                if examinee < N * proportion+1
                    % check if it reaches the zone target sample size
                    next_item = randsample(unselected_cali_finished_target,1); 
                else
                    % find which zone this person belongs to
                    [~,sort_index_target]=sort(distance(unselected_cali_finished_target));
                    index = 1;
                    while index <= length(unselected_cali_finished_target)
                        if length(unselected_cali_finished_target) > 1
                            next_item = unselected_cali_finished_target(sort_index_target(index));
                        else
                            next_item = unselected_cali_finished_target;
                        end
                        if item_record(next_item,zone) < zone_target_sample
                            break
                        else
                            index = index + 1;
                        end
                    end
                end
                if index <= length(unselected_cali_finished_target)
                    if distance(sort_index_target(index)) < 1
                        sparse_target(examinee,next_item) = U(examinee,next_item);
                        select_cali_target = [select_cali_target next_item];
                        item_record_target(next_item,sum(item_record_target(next_item,:)~=0)+1) = examinee;
                        item_record(next_item,zone) = item_record(next_item,zone) + 1;
                        % apply the next item
                        if zone == 1
                            if item_record(next_item,zone) >= zone_target_sample
                                finished_target_1 = unique([finished_target_1 next_item]);
                            end
                        elseif zone == 2
                            if item_record(next_item,zone) >= zone_target_sample
                                finished_target_2 = unique([finished_target_2 next_item]);
                            end
                        elseif zone == 3
                            if item_record(next_item,zone) >= zone_target_sample
                                finished_target_3 = unique([finished_target_3 next_item]);
                            end
                        elseif zone == 4
                            if item_record(next_item,zone) >= zone_target_sample
                                finished_target_4 = unique([finished_target_4 next_item]);
                            end
                        end
                    end
                    if sum(sparse_target(:,next_item)~=9) == target_sample
                        finished_target = [finished_target next_item];
                    end
                else 
                    next_item = [];
                end
                
            else 
                next_item = [];
            end
        end
    end
end
