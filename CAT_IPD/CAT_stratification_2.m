'CAT_stratification_2'
sparse_matrix_stra_2=U_2;
examinee_record_stra_2=zeros(N,test_length);
theta_stra_2=zeros(N,1);
sample_size=zeros(n,1);
%%
for j6=1:N
    examinee=j6
    %% randomly choose several intial items to each examinee
    examinee_record=randsample(strata_1_1,1);
    examinee_record_stra_2(j6,1)=examinee_record;
    u=U_2(j6,examinee_record); %get the response for the first m items
    theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
    sample_size(examinee_record)=sample_size(examinee_record)+1;
    %% start the operational CAT
    for j7=1:test_length
        if j7~=test_length
            %compute fisher informtion for all the operational items unselected
            if j7<test_length/3
                whole=strata_1_1;
            elseif j7<2*test_length/3
                whole=strata_2_1;
            else
                whole=strata_3_1;
            end
            unselected_index=setdiff(whole,examinee_record);
            matching=abs(theta_hat-b_1(unselected_index));
            %select items based on maximum fisher estimation method
            [sort_information,sort_index]=sort(matching,'ascend');
            %get the highest 4 fisher information items and randomly choose one
            rand_index=sort_index(1);
            next_item=unselected_index(rand_index);
            %apply next the item 
            examinee_record=[examinee_record next_item];
            examinee_record_stra_2(j6,length(examinee_record))=next_item;
            sample_size(next_item)=sample_size(next_item)+1;
            u=U_2(j6,examinee_record);
            %get the theta estimate, final step use MLE, intermidiate step use
            %EAP based on previous theta_hat as prior mean
            theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
        else
            theta_hat=mle_theta(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u);
        end
    end
    %get the estimate
    theta_stra_2(j6)=theta_hat;
    %get the sparse matrix
    sparse_matrix_stra_2(j6,setdiff(1:n,examinee_record))=9;
end
for jj=1:n
    exposure_stra_2(replication,jj)=sum(sparse_matrix_stra_2(:,jj)~=9)/N;
end