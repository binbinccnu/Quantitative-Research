number_points=80;
typeIrate_cat=zeros(number_points,1);
typeIrate_stra=zeros(number_points,1);
power_cat=typeIrate_cat;
power_stra=typeIrate_stra;

for pp=1:number_points
    %%this is the modified sibtest
    'Modified SIBTEST';
    intervals=linspace(-3,2.5,pp)';
    intervals=[intervals,[intervals(2:size(intervals,1));3]];  %divide the whole theta span into intervals
    intervals(1,1)=-10;
    intervals(size(intervals,1),2)=10;
    weights_1=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item 
    totalscore_1=zeros(n,size(intervals,1)); %mean total score for a interval for an item
    weights_2=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item 
    totalscore_2=zeros(n,size(intervals,1)); %mean total score for a interval for an item
    interval_1=zeros(N,1);
    interval_2=zeros(N,1);
    %for each item, get the examinees who have selected it
    for jj=1:N
        for jjj=1:size(intervals,1)
            %which interval does this examinee falls into
            if (theta_estimate_cat_1(jj)>=intervals(jjj,1) && theta_estimate_cat_1(jj)<intervals(jjj,2))
                interval_1(jj)=jjj;
            end
            if (theta_estimate_cat_2(jj)>=intervals(jjj,1) && theta_estimate_cat_2(jj)<intervals(jjj,2))
                interval_2(jj)=jjj;
            end
        end
        for j=1:test_length 
            %for all items this examinees took
            current_item_1=examinee_record_CAT_1(jj,j);
            totalscore_1(current_item_1,interval_1(jj))=totalscore_1(current_item_1,interval_1(jj))+sparse_matrix_cat_1(jj,current_item_1);
            weights_1(current_item_1,interval_1(jj))=weights_1(current_item_1,interval_1(jj))+1;        
            current_item_2=examinee_record_CAT_2(jj,j);     
            totalscore_2(current_item_2,interval_2(jj))=totalscore_2(current_item_2,interval_2(jj))+sparse_matrix_cat_2(jj,current_item_2);   
            weights_2(current_item_2,interval_2(jj))=weights_2(current_item_2,interval_2(jj))+1;
        end
    end
    weights=weights_1+weights_2;
    p_=weights./(sum(weights,2)*ones(1,size(intervals,1)));
    %the mean score for a interval for an item, may have NA values
    meanscore_1=totalscore_1./weights_1;
    meanscore_2=totalscore_2./weights_2;
    %revise the NaN;
    [cord1_1,cord2_1]=find(weights_1==0);
    [cord1_2,cord2_2]=find(weights_2==0);
    for j=1:length(cord1_1)
        meanscore_1(cord1_1(j),cord2_1(j))=0;
    end
    for j=1:length(cord1_2)
        meanscore_2(cord1_2(j),cord2_2(j))=0;
    end
    %the variance for a interval for an item, may have NA values
    variance_1=(totalscore_1+weights_1.*meanscore_1.*meanscore_1-2.*meanscore_1.*totalscore_1)./(weights_1-1);
    variance_2=(totalscore_2+weights_2.*meanscore_2.*meanscore_2-2.*meanscore_2.*totalscore_2)./(weights_2-1);
    %revise the NaN;
    [cord1_1,cord2_1]=find((weights_1-1)<=0);
    [cord1_2,cord2_2]=find((weights_2-1)<=0);
    for j=1:length(cord1_1)
        variance_1(cord1_1(j),cord2_1(j))=0;
    end
    for j=1:length(cord1_2)
        variance_2(cord1_2(j),cord2_2(j))=0;
    end

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
       
    %compute test statistic, which follows a normal (0,1) distribution
    b_hat=meanscore_hat./variance_hat.^(1/2);
    %gathering the results
    flag_sib=abs(b_hat)>1.96;
    
    flag_sib=find(flag_sib==1);
    typeIrate_cat(pp)=length(flag_sib(flag_sib>round(n*p)))/(n-round(n*p));
    power_cat(pp)=length(flag_sib(flag_sib<=round(n*p)))/round(n*p);
end


%% for stratification
for pp=1:number_points
    %%this is the modified sibtest
    'Modified SIBTEST';
    intervals=linspace(-3,2.5,pp)';
    intervals=[intervals,[intervals(2:size(intervals,1));3]];  %divide the whole theta span into intervals
    intervals(1,1)=-10;
    intervals(size(intervals,1),2)=10;
    weights_1=zeros(n,size(intervals,1));   %how many examinees are there for a interval for an item 
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
    weights=weights_1+weights_2;
    p_=weights./(sum(weights,2)*ones(1,size(intervals,1)));
    %the mean score for a interval for an item, may have NA values
    meanscore_1=totalscore_1./weights_1;
    meanscore_2=totalscore_2./weights_2;
    %revise the NaN;
    [cord1_1,cord2_1]=find(weights_1==0);
    [cord1_2,cord2_2]=find(weights_2==0);
    for j=1:length(cord1_1)
        meanscore_1(cord1_1(j),cord2_1(j))=0;
    end
    for j=1:length(cord1_2)
        meanscore_2(cord1_2(j),cord2_2(j))=0;
    end
    %the variance for a interval for an item, may have NA values
    variance_1=(totalscore_1+weights_1.*meanscore_1.*meanscore_1-2.*meanscore_1.*totalscore_1)./(weights_1-1);
    variance_2=(totalscore_2+weights_2.*meanscore_2.*meanscore_2-2.*meanscore_2.*totalscore_2)./(weights_2-1);
    %revise the NaN;
    [cord1_1,cord2_1]=find((weights_1-1)<=0);
    [cord1_2,cord2_2]=find((weights_2-1)<=0);
    for j=1:length(cord1_1)
        variance_1(cord1_1(j),cord2_1(j))=0;
    end
    for j=1:length(cord1_2)
        variance_2(cord1_2(j),cord2_2(j))=0;
    end

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
       
    %compute test statistic, which follows a normal (0,1) distribution
    b_hat=meanscore_hat./variance_hat.^(1/2);
    %gathering the results
    flag_sib=abs(b_hat)>1.96;
    
    flag_sib=find(flag_sib==1);
    typeIrate_stra(pp)=length(flag_sib(flag_sib>round(n*p)))/(n-round(n*p));
    power_stra(pp)=length(flag_sib(flag_sib<=round(n*p)))/round(n*p);
end