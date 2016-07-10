number_points=5;

%% for stratification
pp=number_points;

    %%this is the modified sibtest
    'Modified SIBTEST';
    intervals=linspace(-3,2.5,pp)';
    intervals=[intervals,[intervals(2:size(intervals,1));3]];  %divide the whole theta span into intervals
    intervals(1,1)=-10;
    intervals(size(intervals,1),2)=10; %adjust upper and lower bounds
    
    weights_1=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item for this fi
    totalscore_1=zeros(n,size(intervals,1)); %mean total score for a interval for an item
    weights_2=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item 
    totalscore_2=zeros(n,size(intervals,1)); %mean total score for a interval for an item
    interval_1=zeros(N,1);
    interval_2=zeros(N,1);
    
    %for each item, get the examinees who have selected it
    for jj=1:N
        for jjj=1:size(intervals,1)
            %which interval does this examinee falls into
            if (theta_stra_1(jj)>=intervals(jjj,1) && theta_stra_1(jj)<intervals(jjj,2))
                interval_1(jj)=jjj;
            end
            if (theta_stra_2(jj)>=intervals(jjj,1) && theta_stra_2(jj)<intervals(jjj,2))
                interval_2(jj)=jjj;
            end
        end
        for j=1:test_length 
            %for all items this examinees took
            current_item_1=examinee_record_stra_1(jj,j);
            totalscore_1(current_item_1,interval_1(jj))=totalscore_1(current_item_1,interval_1(jj))+sparse_matrix_stra_1(jj,current_item_1);
            weights_1(current_item_1,interval_1(jj))=weights_1(current_item_1,interval_1(jj))+1;        
            current_item_2=examinee_record_stra_2(jj,j);     
            totalscore_2(current_item_2,interval_2(jj))=totalscore_2(current_item_2,interval_2(jj))+sparse_matrix_stra_2(jj,current_item_2);   
            weights_2(current_item_2,interval_2(jj))=weights_2(current_item_2,interval_2(jj))+1;
        end
    end
    %%
    weights=weights_1+weights_2;
    p_=weights./(sum(weights,2)*ones(1,size(intervals,1)));
    %the mean score for a interval for an item, may have NA values
    meanscore_1=totalscore_1./weights_1;
    meanscore_2=totalscore_2./weights_2;
     %revise the NaN;
    meanscore_1(isnan(meanscore_1))=0;
    meanscore_2(isnan(meanscore_2))=0;
    
    %the variance for a interval for an item, may have NA values
    variance_1=(totalscore_1+weights_1.*meanscore_1.*meanscore_1-2.*meanscore_1.*totalscore_1)./(weights_1-1);
    variance_2=(totalscore_2+weights_2.*meanscore_2.*meanscore_2-2.*meanscore_2.*totalscore_2)./(weights_2-1);
    variance_1(isnan(variance_1))=0;
    variance_2(isnan(variance_2))=0;
%%
    meanscore_hat=zeros(n,1);
    variance_hat=zeros(n,1);
    for j=1:n
        for jj=1:size(intervals,1)
            meanscore_hat(j)=meanscore_hat(j)+p_(j,jj)*(meanscore_1(j,jj)-meanscore_2(j,jj));
            if weights_1(j,jj)~=0 && weights_2(j,jj)~=0
                variance_hat(j)=variance_hat(j)+p_(j,jj)*p_(j,jj)*(variance_1(j,jj)/weights_1(j,jj)+variance_2(j,jj)/weights_2(j,jj));      
            elseif weights_1(j,jj)~=0 && weights_2(j,jj)==0           
                variance_hat(j)=variance_hat(j)+weights_1(j,jj)*variance_1(j,jj);      
            elseif weights_1(j,jj)==0 && weights_2(j,jj)~=0         
                variance_hat(j)=variance_hat(j)+weights_2(j,jj)*variance_2(j,jj);       
            end           
        end        
    end
       %%
    %compute test statistic, which follows a normal (0,1) distribution
    b_hat_stra_sib=meanscore_hat./variance_hat.^(1/2);
    %gathering the results
    flag_sib_stra=abs(b_hat_stra_sib)>1.64;
    
    flag_sib_stra=find(flag_sib_stra==1);
    typeIrate_stra_sib=length(flag_sib_stra(flag_sib_stra>k))/k;
    power_stra_sib=length(flag_sib_stra(flag_sib_stra<=k))/k;
