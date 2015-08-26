%% first run SH CAT to get information of P(S)
sparse_matrix_sh_2=U_2;
examinee_record_sh_2=zeros(N,test_length);
theta_sh_2=zeros(N,1);
%
'CAT_SH_2'
for j6=1:N
    
    m=3;
    examinee_record=randsample(1:n,m);
    examinee_record_sh_2(j6,1:m)=examinee_record;
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
            next_item=sort_index(1);
            next_item=unselected_index(next_item);
            %apply next the item 
            examinee_record=[examinee_record next_item];
            examinee_record_sh_2(j6,length(examinee_record))=next_item;
            u=U_2(j6,examinee_record);
            %get the theta estimate, final step use MLE, intermidiate step use
            %EAP based on previous theta_hat as prior mean
            theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
        else
            theta_hat=mle_theta(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u);
        end
    end
    theta_sh_2(j6)=theta_hat; 
    
    %get the sparse matrix
    sparse_matrix_sh_2(j6,setdiff(1:n,examinee_record))=9;
end

%compute the item exposure rate P(S), namely, S
S=zeros(n,1);
for jj=1:n
    S(jj)=sum(sparse_matrix_sh_2(:,jj)~=9)/N;
end
A_S=ones(n,1);
A=S;
%  now administer the sympson hetter method
outiter=0;
diff=10;
while diff>0 && outiter<10
    outiter=outiter+1;
    %
    A_=A;
    sparse_matrix_sh_2=U_2;
    examinee_record_sh_2=zeros(N,test_length);
    theta_sh_2=zeros(N,1);
    for jj=1:n 
        if S(jj)>.2 
            A_S(jj)=.2/S(jj);
        end
    end

    S=zeros(n,1);
    %
    for j6=1:N
    
        m=3;
        examinee_record=randsample(1:n,m);
        candidates=examinee_record;
        
        examinee_record_sh_2(j6,1:m)=examinee_record;
        u=U_2(j6,examinee_record); %get the response for the first m items
        theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
      
  
        % start the  CAT
        for j7=m:test_length
            if j7~=test_length
                %compute fisher informtion for all the operational items unselected
                unselected_index=setdiff(1:n,candidates);
                information=fisher(theta_hat,a_1(unselected_index),b_1(unselected_index),c_1(unselected_index),D);
                %select items based on maximum fisher estimation method
                [sort_information,sort_index]=sort(information,'descend');
                flag=0;
                iter=0;
                %using sympson-hetter method
                while flag==0
                    iter=iter+1 ;          
                    rand_index=sort_index(iter);          
                    candidate=unselected_index(rand_index);
                    candidates=[candidates candidate];
                    S(candidate)=S(candidate)+1/N;
                    %randomly generate a uniformly distributed number
                    rand_u=unifrnd(0,1,1,1);
                    if rand_u<=A_S(candidate);
                        next_item=candidate; %sucessfully administered this item
                        flag=1;               
                    end
                end
                
                %apply next the item 
                examinee_record=[examinee_record next_item];
                examinee_record_sh_2(j6,length(examinee_record))=next_item;
                u=U_2(j6,examinee_record);
                %get the theta estimate, final step use MLE, intermidiate step use
                %EAP based on previous theta_hat as prior mean
                theta_hat=eap(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u,nqt,0);
            else
                theta_hat=mle_theta(a_1(examinee_record),b_1(examinee_record),c_1(examinee_record),D,u);
            end
        end
        theta_sh_2(j6)=theta_hat; 
      
        %get the sparse matrix
        sparse_matrix_sh_2(j6,setdiff(1:n,examinee_record))=9;
    end

    %compute the item exposure rate
    A=zeros(n,1);  %this is the administration rate
    for jj=1:n
        A(jj)=sum(sparse_matrix_sh_2(:,jj)~=9)/N;
    end
    diff=sum(abs(A_-A));
    
end
%
figure(2)
plot(1:n,A)
title 'Item Exposure Rate for SH CAT, year 2';
