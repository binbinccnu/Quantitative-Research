sparse_matrix_cat_2=U_2;
examinee_record_CAT_2=zeros(N,n);
theta_estimate_cat_2=zeros(N,1);

for j6=1:N
    % randomly choose several intial items to each examinee
    m=3;
    examinee_record=randsample(1:n,m);
    examinee_record_CAT_2(j6,1:m)=examinee_record;
    u=U_2(j6,examinee_record); %get the response for the first m items
    theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
    
    % start the operational CAT
    for j7=m:test_length
        if j7~=test_length
            %compute fisher informtion for all the operational items unselected
            unselected_index=setdiff(1:n,examinee_record);
            information=fisher(theta_hat,a_1(unselected_index),b_1(unselected_index),c_1(unselected_index),D);
            %select items based on maximum fisher estimation method
            [sort_information,sort_index]=sort(information,'descend');
            %get the highest 4 fisher information items and randomly choose one
            rand_index=randsample(sort_index(1:5),1);
            next_item=unselected_index(rand_index);
            %apply next the item 
            examinee_record=[examinee_record next_item];
            examinee_record_CAT_2(j6,length(examinee_record))=next_item;
            u=U_2(j6,examinee_record);
            %get the theta estimate, final step use MLE, intermidiate step use
            %EAP based on previous theta_hat as prior mean
            theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
        else
            theta_hat=mle_theta(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u);
        end
    end
    %get the sparse matrix
    sparse_matrix_cat_2(j6,setdiff(1:n,examinee_record))=9;
    theta_estimate_cat_2(j6)=theta_hat;
end

rmse_cat_2=sqrt(sum((theta_2-theta_estimate_cat_2).*(theta_2-theta_estimate_cat_2))/N);
for jj=1:n
    exposure_cat_2(y,jj)=sum(sparse_matrix_cat_2(:,jj)~=9)/N;
end