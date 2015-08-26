function [sparse_random,sparse_order,sparse_suitability,theta_mle,examinee_record_random,examinee_record_order,examinee_record_suitability]...
    = CAT_simulation_variable_sample(U,a,b,index_cali,test_operational,test_cali,proportion,random_switch,suitability_switch,order_switch)

N = size(U,1);
n = size(U,2);
theta_mle = zeros(N,2);

% three different methods
if random_switch ==1
    sparse_random = 9 * ones(N,n);
    examinee_record_random = zeros(N,test_operational+test_cali);
else
    sparse_random = [];
    examinee_record_random = [];
end

if suitability_switch == 1
    sparse_suitability = 9 * ones(N,n);
    examinee_record_suitability = zeros(N,test_operational+test_cali);
    T = ones(length(index_cali),1)*N*test_cali/length(index_cali);
    t = zeros(length(index_cali),1);    
    finished_suitability = [];
else
    sparse_suitability = [];
    examinee_record_suitability = [];
end

if order_switch == 1
    sparse_order = 9 * ones(N,n);
    examinee_record_order = zeros(N,test_operational+test_cali);
    finished_order = [];
else 
    sparse_order = [];
    examinee_record_order = [];
end

%
for j = 1:N
    examinee = j;
    % Select the first 5 items randomly
    item_select = randsample(setdiff(1:n,index_cali),5);
    response = U(examinee,item_select); % Get the response for the first 5 items  
    
    if random_switch == 1
        sparse_random(examinee,item_select) = response;
        examinee_record_random(examinee,1:5) = item_select;
    end
    
    if suitability_switch == 1
        examinee_record_suitability(examinee,1:5) = item_select;
        sparse_suitability(examinee,item_select) = response;
    end
    
    if order_switch == 1
        examinee_record_order(examinee,1:5) = item_select; 
        sparse_order(examinee,item_select) = response;
    end
    
    theta_mle(examinee,:) = MLE_MIRT2D(a(:,1),a(:,2),b,item_select,response);
    
    for jj = 5:test_operational-1
        unselected = setdiff(setdiff(1:n,index_cali),item_select);
        information = Doptimality2D(theta_mle(examinee,1),theta_mle(examinee,2),a(:,1),a(:,2),b,item_select);    
        % Select items based on D optimality          
        [sort_information,sort_index]=sort(information(unselected),'descend'); 
        next_item = unselected(sort_index(1));  
        item_select = [item_select next_item];   
        
        if random_switch == 1
            sparse_random(examinee,next_item) = U(examinee,next_item);
            examinee_record_random(examinee,length(item_select)) = next_item;
        end
        
        if suitability_switch == 1
            sparse_suitability(examinee,next_item) = U(examinee,next_item);
            examinee_record_order(examinee,length(item_select)) = next_item;
        end
        
        if order_switch == 1
            sparse_order(examinee,next_item) = U(examinee,next_item);
            examinee_record_order(examinee,length(item_select)) = next_item;
        end
        
        response = U(examinee,item_select);
        
        % Get the theta estimate
        theta_mle(examinee,:) = MLE_MIRT2D(a(:,1),a(:,2),b,item_select,response);        
    end
    % begin online calibration process
    if random_switch == 1
        select_cali_random = []; %administered pretest item for this examinee
    end
    if order_switch == 1
        select_cali_order = [];
    end
    if suitability_switch == 1
        select_cali_suitability = [];
    end
    
    for jj = 0:test_cali-1
        %%% random selection
        if random_switch == 1
            unselected_cali_random = setdiff(index_cali,select_cali_random);
            next_item = randsample(unselected_cali_random,1);
            sparse_random(examinee,next_item) = U(examinee,next_item);
            select_cali_random = [select_cali_random next_item];
            % apply the next item
            examinee_record_random(examinee,test_operational+length(select_cali_random)) = next_item;
        end
        
        %%% suitability index
        if suitability_switch == 1
            unselected_cali_suitability = setdiff(index_cali,select_cali_suitability);
            unselected_cali_finished_suitability = setdiff(unselected_cali_suitability,finished_suitability);
            if ~isempty(unselected_cali_finished_suitability)
                if examinee < N*proportion+1
                    next_item = randsample(unselected_cali_finished_suitability,1); 
                else
                    Dvalue = Doptimality2Dpar(theta_mle(:,1),theta_mle(:,2),a(:,1),a(:,2),b,sparse_suitability,j,index_cali);
                    Priority = (T-t)./T.*Dvalue;
                    [sort_information,sort_index]=sort(Priority(unselected_cali_finished_suitability),'descend'); 
                    next_item = unselected_cali_finished_suitability(sort_index(1));  
                    if length(next_item) > 1
                        next_item = randsample(next_item,1);
                    end
                end
            else
                next_item = randsample(unselected_cali_suitability,1);
            end
            t(next_item) = t(next_item)+1;
            sparse_suitability(examinee,next_item) = U(examinee,next_item);
            if sum(sparse_suitability(:,next_item)~=9) == N*test_cali/length(index_cali)
                finished_suitability = [finished_suitability next_item];
            end
            select_cali_suitability = [select_cali_suitability next_item];
            % apply the next item
            examinee_record_suitability(examinee,test_operational+length(select_cali_suitability)) = next_item;
        end
        
        %%% order information
        if order_switch == 1
            unselected_cali_order = setdiff(index_cali,select_cali_order);
            unselected_cali_finished_order = setdiff(unselected_cali_order,finished_order);
            if ~isempty(unselected_cali_finished_order)
                if examinee < N*proportion+1
                    next_item = randsample(unselected_cali_finished_order,1);     
                else
                    orderstat = order_stat(20,a,b,theta_mle,sparse_order,unselected_cali_finished_order,examinee);
                    next_item = unselected_cali_finished_order(min(orderstat)==orderstat);
                    if length(next_item) > 1
                        next_item = randsample(next_item,1);
                    end
                end
            else
                next_item = randsample(unselected_cali_order,1);
            end
            sparse_order(examinee,next_item) = U(examinee,next_item);
            if sum(sparse_order(:,next_item)~=9) == N*test_cali/length(index_cali)
                finished_order = [finished_order next_item];
            end
            select_cali_order = [select_cali_order next_item];
            % apply the next item
            examinee_record_order(examinee,test_operational+length(select_cali_order)) = next_item;
        end
    end
end


